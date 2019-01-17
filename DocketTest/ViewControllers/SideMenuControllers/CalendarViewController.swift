//
//  CalendarViewController.swift
//  DocketTest
//
//  Created by Max on 15.01.19.
//  Copyright © 2019 1409revest. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var formerMonthBtn: UIButton!
    @IBOutlet weak var nextMonthBtn: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayesCollectionView: UICollectionView!
    @IBOutlet weak var collectionHeightConstr: NSLayoutConstraint!
    
    let months = ["January", "Febuary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var thisMonth = Calendar.current.component(Calendar.Component.month, from: Date()) - 1
    var thisYear = Calendar.current.component(Calendar.Component.year, from: Date())
    
    private let itemsPerRow: CGFloat = 7
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 0, right: 20.0)

    var range = Calendar.current.range(of: .day, in: .month, for: Date())
    var myDate = Date()
    var cellHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextMonthBtn.transform = nextMonthBtn.transform.rotated(by: CGFloat.pi)
        monthLabel.text = "\(months[thisMonth]) \(thisYear)"
        checkDate()
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
        setNewDate(date: "\(thisMonth + 1)-\(thisYear)")
        checkDate()
        monthLabel.text = "\(months[thisMonth]) \(thisYear)"
        dayesCollectionView.reloadData()
    }
    
    @IBAction func nextMonthPressed(_ sender: Any) {
        formerMonthBtn.isEnabled = true
        if thisMonth == 11 {
            thisYear += 1
            thisMonth = 0
        } else {
            thisMonth += 1
        }
        monthLabel.text = "\(months[thisMonth]) \(thisYear)"
        setNewDate(date: "\(thisMonth + 1)-\(thisYear)")
        setConstrHeight()
        dayesCollectionView.reloadData()
    }
    
    func setNewDate(date: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-yyyy"
        myDate = dateFormatter.date(from: date)!
        range = Calendar.current.range(of: .day, in: .month, for: myDate)
    }
    
    func setConstrHeight() {
        
    }
    
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return range!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath) as! CalendarCell
        let days = Array(1...range!.count)
        cell.dayLabel.text = String(days[indexPath.row])
        print(collectionHeightConstr.constant)
        var collHeight = (cell.frame.height * 4) + (10 + (sectionInsets.left * 4))
        
        if days.count > 28 && days.count < 40 {
            collHeight = collHeight + cell.frame.height + sectionInsets.left
        }
        collectionHeightConstr.constant = collHeight
        print(collectionHeightConstr.constant)
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
    
}
