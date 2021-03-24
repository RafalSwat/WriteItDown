//
//  ViewController.swift
//  WriteItDown
//
//  Created by Rafał Swat on 23/03/2021.
//

import UIKit
import FSCalendar

class ViewController: UIViewController {

    fileprivate weak var calendar: FSCalendar!
    var formatter        = DateFormatter()
    let screenWidth      = UIScreen.main.bounds.width
    let halfScreenHeight = UIScreen.main.bounds.height/2
    //var toDoItems = [ToDoItem]()
    var dates            = [Date]()
    var label            = UILabel()
    var text             = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupDates()
        setupCalendar()
        setupLabel()
        
    }
    
    func setupDates() {
        let stringDates      = ["11 03 2021", "18 03 2021", "26 03 2021"]
        formatter.dateFormat = "dd MM yyyy"
        for stringDate in stringDates {
            if let date = formatter.date(from: stringDate) {
                dates.append(date)
            }
        }
        
    }
    
    func setupCalendar() {
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: halfScreenHeight))
        
        calendar.dataSource = self
        calendar.delegate = self
        
        view.addSubview(calendar)
        
        self.calendar = calendar
        
        setupCalendarAppearance()
        setupCalendarConstraints()
    }
    
    func setupCalendarAppearance() {
        calendar.firstWeekday                    = 2
        calendar.appearance.borderRadius         = 0.3

        calendar.appearance.titleFont            = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        calendar.appearance.titleDefaultColor    = UIColor.darkGray
        calendar.appearance.titleSelectionColor  = UIColor.black
        calendar.appearance.selectionColor       = UIColor.systemBackground
        calendar.appearance.borderSelectionColor = UIColor.black
        
        calendar.appearance.headerTitleFont      = UIFont.systemFont(ofSize: 27, weight: UIFont.Weight.light)
        calendar.appearance.headerTitleColor     = UIColor.black
        
        calendar.appearance.weekdayFont          = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.light)
        calendar.appearance.weekdayTextColor     = UIColor.black
        calendar.appearance.titleWeekendColor    = UIColor.systemRed

        calendar.appearance.todayColor           = UIColor.darkGray
        calendar.appearance.titleTodayColor      = UIColor.white
        calendar.appearance.todaySelectionColor  = UIColor.systemFill

        calendar.appearance.eventSelectionColor  = UIColor.darkGray
        calendar.appearance.eventDefaultColor    = UIColor.systemRed
        calendar.appearance.eventOffset          = CGPoint(x: 0, y: -8)
        
    }
    func setupCalendarConstraints() {
        calendar.translatesAutoresizingMaskIntoConstraints                                                    = false
        calendar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive                       = true
        calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive     = true
        calendar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive                    = true
        calendar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -halfScreenHeight-20).isActive = true
    }
    
    func setupLabel() {
        view.addSubview(label)
        setupLabelConstraints()
        setupLabelAppearance()
    }
    
    func setupLabelConstraints() {
        label.translatesAutoresizingMaskIntoConstraints                                   = false
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive      = true
        label.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive   = true
    }
    
    func setupLabelAppearance() {
        label.font                      = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        label.text                      = text
        label.textAlignment             = .center
        label.numberOfLines             = 0
        label.adjustsFontSizeToFitWidth = true
    }
    

}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "dd MM yyyy"
        let stringDate = formatter.string(from: date)
        if let dateDate = formatter.date(from: stringDate) {
            dates.append(dateDate)
        }
        text = stringDate
        self.label.text = stringDate
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let stringDate = formatter.string(from: date)
        if let dateDate = formatter.date(from: stringDate) {
            for itemDate in dates {
                if dateDate == itemDate {
                    return 2
                }
            }
        }
        return 0
    }
}
