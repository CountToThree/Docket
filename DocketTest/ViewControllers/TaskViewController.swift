//
//  TaskViewController.swift
//  DocketTest
//
//  Created by Max on 29.11.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UITableViewController {

    var tasks = [Task]()
    
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
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskPrototype") as! TaskCell
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
        let action = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) in
            self.context.delete(self.tasks[indexPath.row])
            self.tasks.remove(at: indexPath.row)
            self.saveData()
        }
        action.backgroundColor = UIColor(red: 249/255, green: 122/255, blue: 122/255, alpha: 1.0)
        return [action]
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
            newItem.done = true
            if let info = newTaskData.taskInfoTF.text {
                newItem.desc = info
            }
            newItem.parentList = self.selectedList
            self.tasks.append(newItem)
            self.saveData()
            self.tableView.reloadData()
            NotificationCenter.default.removeObserver(self.observer as Any)
        })
    }
}
