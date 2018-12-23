//
//  SideMenuViewController.swift
//  DocketTest
//
//  Created by Max on 22.12.18.
//  Copyright © 2018 1409revest. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!
    
    let menuItems = ["LISTS","UPGRADE", "PROFILE", "SETTINGS", "LOG OUT"]
    let menuIcons = [UIImage(named: "ListIcon"), UIImage(named: "UpgradeMenuIcon"), UIImage(named: "ProfileMenuIcon"), UIImage(named: "SettingsMenuIcon"), UIImage(named: "LogOutMenuIcon")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "Max"
        profileImage.image = UIImage(named: "ProfileIcon")
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        menuTableView.contentInset = UIEdgeInsets(top: 15,left: 0,bottom: 0,right: 0)

    }
    
    //MARK: - TableView Setup
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            NotificationCenter.default.post(name: .showUpgrade, object: nil)
        case 2:
            NotificationCenter.default.post(name: .showProfile, object: nil)
        case 3:
            NotificationCenter.default.post(name: .showSettings, object: nil)
        case 4:
            NotificationCenter.default.post(name: .logOut, object: nil)
        default:
            print("lists selected")
        }
        NotificationCenter.default.post(name: .toggleSideMenu, object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuCell
        cell.menuItemTitle.text = menuItems[indexPath.row]
        cell.menuItemIcon.image = menuIcons[indexPath.row]
        return cell
    }
    
}
