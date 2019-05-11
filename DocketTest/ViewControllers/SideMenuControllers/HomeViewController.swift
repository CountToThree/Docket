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
    
    var isSideMenuVisible = false
    
    let ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid

    var checkCon = false
    var connected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBtnImage = UIImage(named: "backButtonIcon")
        navigationController?.navigationBar.barTintColor = UIColor.mainColor
        
        navigationController?.navigationBar.backIndicatorImage = backBtnImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backBtnImage

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        loadFromDatabase()
        checkConnection()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadInfos), name: .updateListInfo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showUpgradeVC), name: .showUpgrade, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showProfileVC), name: .showProfile, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showCalendarVC), name: .showCalendar, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showContactVC), name: .showContact, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logOutAction), name: .logOut, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkCon = true
    }
    
    //MARK: - TableView Setup Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listPrototype") as! ListCell
        cell.ListTitleLabel.text = lists[indexPath.row].name
        cell.ListStatusLabel.text = lists[indexPath.row].infoText
        cell.ListColorView.backgroundColor = UIColor.setColor(at: lists[indexPath.row].color)
        cell.ListColorView.layer.cornerRadius = cell.ListColorView.bounds.width / 2
        
        tableView.isUserInteractionEnabled = true
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
        action.backgroundColor = UIColor.lightRed
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
        
        if isSideMenuVisible {
            isSideMenuVisible = false
            NotificationCenter.default.post(name: .hideSideMenu, object: nil)
        }
    }
    
    //MARK: - Button Setup Methods
    
    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        if isSideMenuVisible {
            isSideMenuVisible = false
            NotificationCenter.default.post(name: .hideSideMenu, object: nil)
        } else {
            isSideMenuVisible = true
            NotificationCenter.default.post(name: .showSideMenu, object: nil)
        }
        
    }

    //MARK: - Model Manipulation Methods
    func loadFromDatabase() {
        
        let listDB = ref.child("users/\((Auth.auth().currentUser?.uid)!)")
        listDB.observe(.childAdded) { (snapshot) in
            if let list = FirebaseApp.getListData(from: snapshot) {
                self.lists.append(list)
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Notification Selector Methods
    @objc func reloadInfos() {
        lists = []
        tableView.isUserInteractionEnabled = false
        let listDB = ref.child("users/\((Auth.auth().currentUser?.uid)!)")
        listDB.removeAllObservers()
        loadFromDatabase()
    }
    
    @objc func showUpgradeVC() {
        performSegue(withIdentifier: "showUpgradeVC", sender: self)
    }
    
    @objc func showProfileVC() {
        performSegue(withIdentifier: "showProfileVC", sender: self)
    }
    
    @objc func showCalendarVC() {
        performSegue(withIdentifier: "showCalendarVC", sender: self)
    }
    
    @objc func showContactVC() {
        performSegue(withIdentifier: "showContactVC", sender: self)
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
