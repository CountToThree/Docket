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
import Firebase

class TaskViewController: UITableViewController {

    var tasks = [TaskItem]()
    var rowToEdit: Int!
    
    var selectedList: ListItem?
        
    let userID = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.title = nil
        loadTasksFromDatabase()
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
            if let id = self.tasks[indexPath.row].notificationID {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
            }
            self.ref.child("tasks/\(self.userID ?? "")/\(self.selectedList?.listID ?? "")/\(self.tasks[indexPath.row].taskID)").removeValue()
            self.tasks.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, index) in
            self.rowToEdit = index.row
            self.performSegue(withIdentifier: "editTaskSegue", sender: self)
        }
        editAction.backgroundColor = UIColor.lightGreen
        deleteAction.backgroundColor = UIColor.lightRed
        return [deleteAction, editAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasks[indexPath.row].done = !tasks[indexPath.row].done
        
        let childUpdates = ["tasks/\(userID ?? "")/\(selectedList?.listID ?? "")/\(tasks[indexPath.row].taskID)/completed": tasks[indexPath.row].done]
        ref.updateChildValues(childUpdates)
        
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
            destinationVC.parentID = (selectedList?.listID)!
            destinationVC.taskTitle = tasks[rowToEdit].title
            destinationVC.taskInfo = tasks[rowToEdit].desc!
            destinationVC.priorityValue = tasks[rowToEdit].priority
            destinationVC.itemID = tasks[rowToEdit].taskID
            if let date = tasks[rowToEdit].notificationDate {
                destinationVC.reminderDate = date
                let id = tasks[rowToEdit].notificationID
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id!])
            }
            destinationVC.editTask = true
        } else if segue.identifier == "showNewTask" {
            destinationVC.parentID = (selectedList?.listID)!
            destinationVC.editTask = false
        }
    }
    
    func dateToString(for Date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm a"
        return formatter.string(from: Date)
    }
    
    //MARK: - Data Manipulation Methods
    func loadTasksFromDatabase() {
        let parentID = selectedList!.listID
        let taskDB = ref.child("tasks/\(userID ?? "")/\(parentID)")
        taskDB.observe(.childAdded) { (snapshot) in
            self.getSnapshotData(from: snapshot)
        }
        
        
        taskDB.observe(.childChanged) { (snapshot) in
            self.getSnapshotData(from: snapshot)
        }
    }
    
    func getSnapshotData(from snap: DataSnapshot) {
        let snapshotValue = snap.value as? [String: AnyObject] ?? [:]
        guard let taskTitle = snapshotValue["title"] as? String else { return }
        guard let taskDesc = snapshotValue["description"] as? String else { return }
        guard let taskDone = snapshotValue["completed"] as? Bool else { return }
        guard let taskPriority = snapshotValue["priority"] as? Float else { return }
        let taskNotID: String?
        let taskNotDate: String?
        
        if let _ = snapshotValue["notificationID"] as? String {
            taskNotID = snapshotValue["notificationID"] as? String
        } else {
            taskNotID = nil
        }
        
        if let _ = snapshotValue["notificationDate"] as? String {
            taskNotDate = snapshotValue["notificationDate"] as? String
        } else {
            taskNotDate = nil
        }
        
        let id = snap.key
        
        let task = TaskItem(title: taskTitle, desc: taskDesc, done: taskDone, priority: taskPriority, notificationID: taskNotID, notificationDate: taskNotDate, taskID: id)
        
        var counter = 0
        for item in tasks {
            if item.taskID == id {
                tasks.remove(at: counter)
            }
            counter += 1
        }
        
        tasks.append(task)
        sortList()
        tableView.reloadData()
    }
    
    func sortList() {
        tasks.sort(by: {
            $0.priority > $1.priority
        })
    }
}
