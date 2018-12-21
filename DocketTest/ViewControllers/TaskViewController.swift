//
//  TaskViewController.swift
//  DocketTest
//
//  Created by Max on 29.11.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class TaskViewController: UITableViewController {

    var tasks = [Task]()
    var rowToEdit: Int!
    
    var selectedList: List? {
        didSet {
            loadData()
        }
    }
    
    var observer: NSObjectProtocol?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getNewData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            if let observer = observer {
                NotificationCenter.default.removeObserver(observer)
            }
        }
        saveData()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskPrototype") as! TaskCell
        cell.setupCheckBox()
        if tasks[indexPath.row].done {
            cell.checkBoxImage.alpha = 1.0
        } else {
            cell.checkBoxImage.alpha = 0.0
        }
        cell.taskTitleLabel.text = tasks[indexPath.row].title
        cell.taskInfoLabel.text = tasks[indexPath.row].desc
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) in
            self.context.delete(self.tasks[indexPath.row])
            self.tasks.remove(at: indexPath.row)
            if let id = self.tasks[indexPath.row].notificationID {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
            }
            self.saveData()
        }
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, index) in
            print("Edit Task at \(index.row)")
            self.rowToEdit = index.row
            self.performSegue(withIdentifier: "editTaskSegue", sender: self)
        }
        editAction.backgroundColor = lightGreen
        deleteAction.backgroundColor = lightRed
        return [deleteAction, editAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(indexPath.row)")
        tasks[indexPath.row].done = !tasks[indexPath.row].done
        let cell = tableView.cellForRow(at: indexPath) as! TaskCell
        if tasks[indexPath.row].done {
            cell.checkBoxImage.taskComplete()
        } else {
            cell.checkBoxImage.taskNotComplete()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NewTaskViewController
        if segue.identifier == "editTaskSegue" {
            destinationVC.taskTitle = tasks[rowToEdit].title!
            destinationVC.taskInfo = tasks[rowToEdit].desc!
            destinationVC.priorityValue = tasks[rowToEdit].priority
            if let date = tasks[rowToEdit].notificationDate {
                destinationVC.reminderDate = dateToString(for: date)
                let id = tasks[rowToEdit].notificationID
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id!])
            }
            destinationVC.taskToDelete = rowToEdit
        }
    }
    
    func dateToString(for Date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm a"
        return formatter.string(from: Date)
    }
    
    //MARK: - Data Manipulation Methods
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving data \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let listPredicate = NSPredicate(format: "parentList.name MATCHES %@", (selectedList?.name)!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [listPredicate, additionalPredicate])
        } else {
            request.predicate = listPredicate
        }
        
        do {
            tasks = try context.fetch(request)
        } catch {
            print("Error loading data \(error)")
        }
    }
    
    //MARK: - Add new Tasks
    func getNewData() {
        observer = NotificationCenter.default.addObserver(forName: .saveNewTaskItems, object: nil, queue: OperationQueue.main, using: { (notification) in
            let newTaskData = notification.object as! NewTaskViewController
            let newItem = Task(context: self.context)
            newItem.title = newTaskData.taskNameTF.text!
            newItem.done = false
            if let info = newTaskData.taskInfoTF.text {
                newItem.desc = info
            } else {
                if let reminder = newTaskData.reminderTF.text {
                    newItem.desc = reminder
                }
            }
            newItem.priority = newTaskData.prioritySlider.value
            newItem.parentList = self.selectedList
            if let id = newTaskData.notID {
                newItem.notificationID = id
                newItem.notificationDate = newTaskData.reminderTF.datePicker.date
            }
            
            // delete Old Task
            if let item = newTaskData.taskToDelete {
                self.context.delete(self.tasks[item])
                self.tasks.remove(at: item)

            }

            print(newItem.priority)
            self.tasks.append(newItem)
            self.sortList()
            self.saveData()
            self.tableView.reloadData()
            NotificationCenter.default.removeObserver(self.observer as Any)
        })
    }
    
    func sortList() {
        tasks.sort(by: {
            $0.priority > $1.priority
        })
    }
}
