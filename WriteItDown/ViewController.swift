//
//  ViewController.swift
//  WriteItDown
//
//  Created by Rafał Swat on 23/03/2021.
//

import UIKit
import FSCalendar
import CoreData

class ViewController: UIViewController {
    
    fileprivate weak var calendar: FSCalendar!
    fileprivate weak var tableView: UITableView!
    
    var formatter        = DateFormatter()
    let screenWidth      = UIScreen.main.bounds.width
    let halfScreenHeight = UIScreen.main.bounds.height/2
    let imageView        = UIImageView(image: UIImage(named: "snowImage"))
    let cellIdentifier   = "TableViewCell"
    let context          = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var toDoItems        = [ToDoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        setupData()
        setupImage()
        setupCalendar()
        setupTableView()

    }
    
    //MARK: setup objects functions
    
    func setupImage() {
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        setupImageAppearance()
        setupImageConstraints()
    }
    func setupCalendar() {
        let calendar  = FSCalendar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: halfScreenHeight))
        view.addSubview(calendar)
        self.calendar = calendar
        setupCalendarDelegates()
        setupCalendarAppearance()
        setupCalendarConstraints()
    }
    func setupTableView() {
        let tableView  = UITableView(frame: CGRect(x: 0, y: halfScreenHeight+20, width: screenWidth, height: halfScreenHeight-20))
        view.addSubview(tableView)
        self.tableView = tableView
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.rowHeight = 70
        setuptableViewDelegates()
        setupTableViewConstraints()

    }
    
    //MARK: setup appearance functions
    
    func setupImageAppearance() {
        imageView.frame       = CGRect(x: 0, y: 0, width: screenWidth, height: halfScreenHeight)
        imageView.contentMode = .scaleAspectFill
        makeGradient(gradientView: imageView)
    }
    func setupCalendarAppearance() {
        calendar.firstWeekday                    = 2
        calendar.appearance.borderRadius         = 0.4

        calendar.appearance.titleFont            = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        calendar.appearance.titleDefaultColor    = UIColor.darkGray
        calendar.appearance.titleSelectionColor  = UIColor.darkText
        calendar.appearance.selectionColor       = UIColor.systemBackground
        calendar.appearance.borderSelectionColor = UIColor.darkText
        
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
    
    //MARK: setup delegates functions
    
    func setupCalendarDelegates() {
        calendar.dataSource = self
        calendar.delegate   = self
    }
    func setuptableViewDelegates() {
        tableView.delegate   = self
        tableView.dataSource = self
    }
    
    //MARK: setup constraints functions
    
    func setupImageConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints                                                 = false
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive                                  = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive                = true
        imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive                                = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -halfScreenHeight).isActive = true

    }
    func setupCalendarConstraints() {
        calendar.translatesAutoresizingMaskIntoConstraints                                                    = false
        calendar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive                       = true
        calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive     = true
        calendar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive                    = true
        calendar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -halfScreenHeight-20).isActive = true
    }
    func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints                                  = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive     = true
        tableView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive  = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive  = true
    }
    
    //MARK: functions related to Core Data
    
    func setupData() {
        let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        do {
            toDoItems = try context.fetch(request)
            toDoItems = sortArrayByDates(items: toDoItems)
        } catch {
            print("Error during fetching data: \(error.localizedDescription)")
        }
    }
    func saveData() {
        self.tableView.reloadData()
        self.calendar.reloadData()
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    func deleteData(item: ToDoItem) {
        context.delete(item)
    }
    
    //MARK: auxiliary functions
    
    func makeGradient(gradientView: UIView) {
        let gradient            = CAGradientLayer()
        gradient.startPoint     = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint       = CGPoint(x: 0.0, y: 0.0)
        let whiteColor          = UIColor.white
        gradient.colors         = [whiteColor.withAlphaComponent(0.0).cgColor, whiteColor.withAlphaComponent(0.2).cgColor, whiteColor.withAlphaComponent(1.0).cgColor]
        gradient.locations      = [NSNumber(value: 0.0),NSNumber(value: 0.9),NSNumber(value: 1.0)]
        gradient.frame          = gradientView.bounds
        gradientView.layer.mask = gradient
    }
    func sortArrayByDates(items: [ToDoItem]) -> [ToDoItem] {
        return items.sorted(by: { $0.date!.compare($1.date!) == .orderedDescending })
    }
}

//MARK: ViewController extensions

extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let popup = AddToDoPopup()
        popup.setupDate(date: date)
        popup.addToDoDelegate = self
        view.addSubview(popup)
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        formatter.dateFormat = "dd MM yyyy"
        let stringDate = formatter.string(from: date)
        if let dateAsDate = formatter.date(from: stringDate) {
            for item in toDoItems {
                if dateAsDate == item.date {
                    switch item.priority {
                    case 1:
                        return 1
                    case 3:
                        return 3
                    default:
                        return 2
                    }
                }
            }
        }
        return 0
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TableViewCell
        cell.setupCell(item: toDoItems[indexPath.row])
        cell.cellDelegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
            deleteData(item: toDoItems[indexPath.row])
            self.toDoItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            saveData()
      }
    }
    
}

extension ViewController: AddToDoDelegate {
    
    func addItem(item: ToDoItem) {
        toDoItems.append(item)
        toDoItems = sortArrayByDates(items: toDoItems)
        saveData()
    }
}

extension ViewController: CellDelegate {
    
    func updateIsDone(item: ToDoItem) {
        item.isDone.toggle()
        saveData()
    }
}
