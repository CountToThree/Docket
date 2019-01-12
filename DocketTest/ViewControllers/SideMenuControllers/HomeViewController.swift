//
//  ViewController.swift
//  DocketTest
//
//  Created by Max on 27.11.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase

class HomeViewController: UITableViewController {
    
    var lists = [ListItem]()
    var indexOnSelect: Int!
    var observer: NSObjectProtocol?
    var nextTitle = ""
    
    let ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()

        let backBtnImage = UIImage(named: "backButtonIcon")
        navigationController?.navigationBar.barTintColor = lightGreen
        
        navigationController?.navigationBar.backIndicatorImage = backBtnImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backBtnImage

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        loadFromDatabase()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showUpgradeVC), name: .showUpgrade, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showProfileVC), name: .showProfile, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showSettingsVC), name: .showSettings, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logOutAction), name: .logOut, object: nil)

        
    }

    //MARK: - TableView Setup Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listPrototype") as! ListCell
        cell.ListTitleLabel.text = lists[indexPath.row].name
//        let listTasks = lists[indexPath.row].tasks
//        var counter = 0
//        for item in listTasks {
//            if item.done {
//                counter += 1
//            }
//        }
//        cell.ListStatusLabel.text = "\(counter) / \(lists[indexPath.row].tasks.count)"
        cell.ListColorView.backgroundColor = UIColor.setColor(at: lists[indexPath.row].color)
        cell.ListColorView.layer.cornerRadius = cell.ListColorView.bounds.width / 2
        cell.ListStatusLabel.text = "0 / 0"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) in
            
            self.ref.child("users/\(self.userID ?? "")/\(self.lists[indexPath.row].listID)").removeValue()
            self.ref.child("tasks/\(self.userID ?? "")/\(self.lists[indexPath.row].listID)").removeValue()

            self.lists.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        action.backgroundColor = lightRed
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
        NotificationCenter.default.post(name: .toggleSideMenu, object: nil)
    }

    //MARK: - Model Manipulation Methods
    func loadFromDatabase() {
        let listDB = ref.child("users/\((Auth.auth().currentUser?.uid)!)")
        listDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as? [String: AnyObject] ?? [:]

            guard let listTitle = snapshotValue["name"] as? String else { return }
            guard let listID = snapshotValue["id"] as? String else { return }
            guard let color = snapshotValue["color"] as? String else { return }
            self.lists.append(ListItem(name: listTitle, color: color, listID: listID))

            self.tableView.reloadData()
        }
    }
    
    //MARK: - Segue Methods
    @objc func showUpgradeVC() {
        performSegue(withIdentifier: "showUpgradeVC", sender: self)
    }
    
    @objc func showProfileVC() {
        performSegue(withIdentifier: "showProfileVC", sender: self)
    }
    
    @objc func showSettingsVC() {
        performSegue(withIdentifier: "showSettingsVC", sender: self)
    }
    
    @objc func logOutAction() {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "unwindToFirstVC", sender: self)
        } catch {
            print("Error: There was a error signing out!")
        }
    }
    
}
