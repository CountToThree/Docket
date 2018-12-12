//
//  ViewController.swift
//  DocketTest
//
//  Created by Max on 27.11.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit
import CoreData


class HomeViewController: UITableViewController {
    
    var lists = [List]()
    var indexOnSelect: Int!
    var observer: NSObjectProtocol?
    var nextTitle = ""
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //get new Data
        observer = NotificationCenter.default.addObserver(forName: .saveNewListName, object: nil, queue: OperationQueue.main) { (notification) in
            let newListName = notification.object as! NewListPopUp
            let newItem = List(context: self.context)
            newItem.name = newListName.nameTextField.text!
            self.lists.append(newItem)
            self.tableView.reloadData()
        }
        
        saveData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    //MARK: - TableView Setup Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listPrototype") as! ListCell
        cell.ListTitleLabel.text = lists[indexPath.row].name
        let listTasks = lists[indexPath.row].tasks?.allObjects as! [Task]
        var counter = 0
        for item in listTasks {   // get number of tasks that are already done
            if item.done {
                counter += 1;
            }
        }
        cell.ListStatusLabel.text = "\(counter) / \(lists[indexPath.row].tasks!.count)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) in
            self.context.delete(self.lists[indexPath.row])
            self.lists.remove(at: indexPath.row)
            self.saveData()
        }
        action.backgroundColor = UIColor(red: 249/255, green: 122/255, blue: 122/255, alpha: 1.0)
        return [action]
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTasksInList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTasksInList" {
            let destinationVC = segue.destination as! TaskViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedList = lists[indexPath.row]
                destinationVC.title = lists[indexPath.row].name
            }
        }
    }
    
    //MARK: - Button Setup Methods
    
    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        // show Menu
        
    }

    //MARK: - Model Manipulation Methods
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving data: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadData() {
        let request: NSFetchRequest<List> = List.fetchRequest()
        do {
            lists = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
}

//MARK: - Search Bar Methods
extension HomeViewController: UISearchBarDelegate {
    
}

