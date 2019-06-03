//
//  CalendarViewController.swift
//  DocketTest
//
//  Created by Max on 15.01.19.
//  Copyright © 2019 1409revest. All rights reserved.
//

import UIKit
import Firebase

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var formerMonthBtn: UIButton!
    @IBOutlet weak var nextMonthBtn: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayesCollectionView: UICollectionView!
    @IBOutlet weak var collectionHeightConstr: NSLayoutConstraint!
    @IBOutlet weak var tasksTableView: UITableView!
    
    let ref = Database.database().reference()
    
    let months = ["January", "Febuary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var thisMonth = Calendar.current.component(Calendar.Component.month, from: Date()) - 1
    var thisYear = Calendar.current.component(Calendar.Component.year, from: Date())
    var today = Calendar.current.component(Calendar.Component.day, from: Date())
    
    private let itemsPerRow: CGFloat = 7
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 0, right: 20.0)

    var range = Calendar.current.range(of: .day, in: .month, for: Date())
    var myDate = Date()
    var cellHeight: CGFloat!
    var days = [Int]()
    
    var calendarItems = [CalendarItem]()
    var thisMonthItems = [CalendarItem]()
    var selectedItems = [CalendarItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayesCollectionView.delegate = self
        dayesCollectionView.dataSource = self
        setNewDate(date: "\(thisMonth + 1)-01-\(thisYear)")
        nextMonthBtn.transform = nextMonthBtn.transform.rotated(by: CGFloat.pi)
        monthLabel.text = "\(months[thisMonth]) \(thisYear)"
        checkDate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setConstrHeight()
        loadDataFromDatabase()
    }
    
    func checkDate() {
        let m = Calendar.current.component(Calendar.Component.month, from: Date()) - 1
        let y = Calendar.current.component(Calendar.Component.year, from: Date())

        if months[thisMonth] == months[m] && thisYear == y {
            formerMonthBtn.isEnabled = false
        } else {
            formerMonthBtn.isEnabled = true
        }
    }
    
    //MARK: - Switch Month Buttons
    @IBAction func formerMonthPressed(_ sender: Any) {
        thisMonth -= 1
        if thisMonth < 0 {
            thisYear -= 1
            thisMonth = 11
        }
        checkDate()
        monthChangedActions()
    }
    
    @IBAction func nextMonthPressed(_ sender: Any) {
        formerMonthBtn.isEnabled = true
        if thisMonth == 11 {
            thisYear += 1
            thisMonth = 0
        } else {
            thisMonth += 1
        }
        monthChangedActions()
    }
    
    func monthChangedActions() {
        selectedItems = []
        monthLabel.text = "\(months[thisMonth]) \(thisYear)"
        setNewDate(date: "\(thisMonth + 1)-01-\(thisYear)")
        getMonthTasks()
        dayesCollectionView.reloadData()
        tasksTableView.reloadData()
        setConstrHeight()
    }
    
    func getMonthTasks() {
        thisMonthItems = []
        for item in calendarItems {
            let comp = Calendar.current.dateComponents([.month, .year], from: item.time)
            if comp.month == thisMonth+1 && comp.year == thisYear {
                thisMonthItems.append(item)
            }
        }
    }
    
    //Set the Date for the new Month
    func setNewDate(date: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        myDate = dateFormatter.date(from: date)!
        range = Calendar.current.range(of: .day, in: .month, for: myDate)
        
        setWeekday()
    }
    
    //Populats days Array and sets the 1. Weekday
    func setWeekday() {
        var weekday = Calendar.current.component(.weekday, from: myDate)
        weekday = weekday > 1 ? weekday - 2 : 6
        
        days = Array(1...range!.count)
        if weekday != 0 {
            for _ in 1...weekday {
                days.insert(0, at: 0)
            }
        }
    }
    
    func setConstrHeight() {
        guard let height = cellHeight else { return }
        var collHeight = (height * 4) + (10 + (sectionInsets.left * 4))

        if days.count > 35 {
            collHeight = collHeight + ((height + sectionInsets.left) * 2)
        } else if days.count > 28 {
            collHeight = collHeight + height + sectionInsets.left
        }

        collectionHeightConstr.constant = collHeight
    }
    
    func setTaskColor(date: Date, color: UIColor) {
        let comp = Calendar.current.dateComponents([.day, .month, .year], from: date)
        var index = -1
        for d in days {
            index += 1
            if d != 0 {
                if d == comp.day! {
                    break
                }
            }
        }
        if thisMonth+1 == comp.month! && thisYear == comp.year! {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = dayesCollectionView.cellForItem(at: indexPath) as! CalendarCell
            if cell.leftColorView.backgroundColor == .white {
                cell.leftColorView.backgroundColor = color
            } else if cell.midColorView.backgroundColor == .white {
                if cell.leftColorView.backgroundColor != color {
                    cell.midColorView.backgroundColor = color
                }
            } else if cell.rightColorView.backgroundColor == .white {
                if cell.leftColorView.backgroundColor != color && cell.midColorView.backgroundColor != color {
                    cell.rightColorView.backgroundColor = color
                }
            }
        }
    }
    
    //MARK: - Fetch Data from server
    func loadDataFromDatabase() {
        
        let listDB = ref.child("users/\((Auth.auth().currentUser?.uid)!)")
        listDB.observe(.childAdded) { (snapshot) in
            if let list = FirebaseApp.getListData(from: snapshot) {
                self.loadTasks(for: list.listID, color: .setColor(at: list.color))
            }
        }
    }
    
    func loadTasks(for key: String, color: UIColor) {
        
        let taskDB = ref.child("tasks/\((Auth.auth().currentUser?.uid)!)/\(key)")
        taskDB.observe(.childAdded) { (snapshot) in
            if let task = FirebaseApp.getTaskData(from: snapshot) {
                if let tcalDate = task.calendarDate {
                    var desc: String? = nil
                    if let d = task.desc {
                        desc = d
                    }
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
                    let calDate = dateFormatter.date(from: tcalDate)!
                    let newCalItem = CalendarItem(title: task.title, desc: desc, color: color, time: calDate)
                    
                    self.setTaskColor(date: calDate, color: newCalItem.color)
                    self.calendarItems.append(newCalItem)
                    self.sortList()
                }
            }
        }
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            let numberOfItems = self.dayesCollectionView.numberOfItems(inSection: 0)
            let indexPaths = [Int](0..<numberOfItems).map{ IndexPath(row: $0, section: 0) }
            self.dayesCollectionView.reloadItems(at: indexPaths)
        }
    }
    
    func sortList() {
        calendarItems = calendarItems.sorted(by: { $1.time.compare($0.time) == .orderedDescending})
    }
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath) as! CalendarCell
        if days[indexPath.row] != 0 {
            cell.dayLabel.text = String(days[indexPath.row])
            if days[indexPath.row] < today && thisMonth == Calendar.current.component(Calendar.Component.month, from: Date()) - 1 && thisYear == Calendar.current.component(Calendar.Component.year, from: Date()) {
                cell.dayLabel.textColor = UIColor.lightGray
                cell.isUserInteractionEnabled = false
            } else {
                cell.dayLabel.textColor = UIColor.black
                cell.isUserInteractionEnabled = true
            }
        } else {
            cell.dayLabel.text = ""
            cell.isUserInteractionEnabled = false
        }
        cellHeight = cell.frame.height
        cell.leftColorView.backgroundColor = .white
        cell.midColorView.backgroundColor = .white
        cell.rightColorView.backgroundColor = .white
        
        for item in thisMonthItems {
            if Calendar.current.component(Calendar.Component.day, from: item.time) == days[indexPath.row] {
                if cell.leftColorView.backgroundColor == .white {
                    cell.leftColorView.backgroundColor = item.color
                } else if cell.midColorView.backgroundColor == .white {
                    if cell.leftColorView.backgroundColor != item.color {
                        cell.midColorView.backgroundColor = item.color
                    }
                } else if cell.rightColorView.backgroundColor == .white {
                    if cell.leftColorView.backgroundColor != item.color && cell.midColorView.backgroundColor != item.color {
                        cell.rightColorView.backgroundColor = item.color
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = (sectionInsets.left * 2) + (15 * (itemsPerRow - 1))
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        cellHeight = widthPerItem
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    //MARK: - selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCell
        cell.dayLabel.textColor = UIColor.lightGreen
        selectedItems = []
        for item in calendarItems {
            let date = item.time
            let comp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            if cell.dayLabel.text != "" {
                if "\(thisMonth+1)-\(cell.dayLabel.text!)-\(thisYear)" == "\(comp.month!)-\(comp.day!)-\(comp.year!)" {
                    selectedItems.append(item)
                }
            }
        }
        tasksTableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCell
        cell.dayLabel.textColor = UIColor.black
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarTaskCell") as! CalendarTableCell
        cell.nameLabel.text = selectedItems[indexPath.row].title
        let date = selectedItems[indexPath.row].time
        let comp = Calendar.current.dateComponents([.hour, .minute], from: date)
        var timeText = "\(comp.minute!)"
        if comp.minute! < 10 {
            timeText = "0\(comp.minute!)"
        }
        cell.timeLabel.text = "\(comp.hour!):\(timeText)"
        cell.colorView.backgroundColor = selectedItems[indexPath.row].color
        
        return cell
    }
}
