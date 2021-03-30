//
//  TableViewCell.swift
//  WriteItDown
//
//  Created by Rafał Swat on 24/03/2021.
//

import UIKit
import CoreData

protocol CellDelegate {
    func updateIsDone(item: ToDoItem)
}

class TableViewCell: UITableViewCell {
    
    let screenWidth  = UIScreen.main.bounds.width
    var formatter    = DateFormatter()
    var titleLabel   = UILabel()
    var dateLabel    = UILabel()
    var isDoneButton = UIButton(type: .system)
    var item         : ToDoItem?
    var cellDelegate : CellDelegate!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleLabel()
        setupDateLabel()
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: setup objects functions
    
    func setupCell(item: ToDoItem) {
        self.item = item
        formatter.dateFormat = "dd MM yyyy"
        let dateString       = formatter.string(from: self.item?.date ?? Date())
        titleLabel.text      = self.item?.note
        dateLabel.text       = dateString
        isDoneButton.setImage(self.item?.isDone ?? false ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square"), for: .normal)
    }
    func setupTitleLabel() {
        addSubview(titleLabel)
        setupTitleLabelAppearance()
        setupTitleLabelConstraints()
    }
    func setupDateLabel() {
        addSubview(dateLabel)
        setupDateLabelAppearance()
        setupDateLabelConstraints()
    }
    func setupButton() {
        self.contentView.addSubview(isDoneButton)
        setupButtonAppearance()
        setupButtonConstraints()
    }
    
    //MARK: setup appearance functions
    
    func setupTitleLabelAppearance() {
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        titleLabel.tintColor = UIColor.darkText
        titleLabel.numberOfLines             = 0
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    func setupDateLabelAppearance() {
        dateLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.light)
        dateLabel.tintColor = UIColor.secondaryLabel
        dateLabel.numberOfLines             = 1
        dateLabel.adjustsFontSizeToFitWidth = true
    }
    func setupButtonAppearance() {
        isDoneButton.tintColor = UIColor.secondaryLabel
        isDoneButton.addTarget(self, action: #selector(toggleIsDone), for: .touchUpInside)
    }
    
    //MARK: setup constraints functions
    
    func setupTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints                               = false
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive         = true
        titleLabel.heightAnchor.constraint(equalToConstant: 25).isActive                   = true
        titleLabel.widthAnchor.constraint(equalToConstant: screenWidth-100).isActive       = true
    }
    func setupDateLabelConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints                                    = false
        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive      = true
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 15).isActive                        = true
        dateLabel.widthAnchor.constraint(equalToConstant: screenWidth-200).isActive            = true
    }
    func setupButtonConstraints() {
        isDoneButton.translatesAutoresizingMaskIntoConstraints                                  = false
        isDoneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        isDoneButton.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive            = true
        isDoneButton.heightAnchor.constraint(equalToConstant: 30).isActive                      = true
        isDoneButton.widthAnchor.constraint(equalToConstant: 30).isActive                       = true
    }
    
    //MARK: auxiliary functions
    
    @objc func toggleIsDone() {
        if let itemToupdate = item {
            isDoneButton.setImage(itemToupdate.isDone ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square"), for: .normal)
            cellDelegate.updateIsDone(item: itemToupdate)
        }
    }
}
