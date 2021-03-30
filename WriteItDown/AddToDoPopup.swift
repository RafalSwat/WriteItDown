//
//  addToDoPopup.swift
//  WriteItDown
//
//  Created by Rafał Swat on 25/03/2021.
//

import Foundation
import UIKit
import CoreData

protocol AddToDoDelegate {
    func addItem(item: ToDoItem)
}

class AddToDoPopup: UIView {
    
    let imageView          = UIImageView(image: UIImage(named: "winterImage"))
    var titleLabel         = UILabel()
    var textField          = UITextField()
    var dateLabel          = UILabel()
    var datePicker         = UIDatePicker()
    var prioritySchwitcher = UISegmentedControl(items: ["low", "ordinary", "high"])
    var addButton          = UIButton()
    var warningLabel       = UILabel()
    var warningText        = "bnasjkdnajklsndklasml;kdmasl; asdl;asmdl;as"
    let container          = UIView()
    var date               = Date()
    var addToDoDelegate    : AddToDoDelegate!
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dateLabel, datePicker])
        return stack
    }()
    lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel ,textField, hStack, prioritySchwitcher, addButton])
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        self.frame           = UIScreen.main.bounds
        
        setupGestureRecognizer()
        setupContainer()
        animateIn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: setup objects functions
    
    func setupGestureRecognizer() {
        let gestureRecognizer                  = UITapGestureRecognizer(target: self, action: #selector(self.animateOut))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate             = self
        self.addGestureRecognizer(gestureRecognizer)
    }
    func setupContainer() {
        addSubview(container)
        setupContainerAppearance()
        setupContainerConstraints()
        setupImage()
        setupVStack()
    }
    func setupImage() {
        container.addSubview(imageView)
        container.sendSubviewToBack(imageView)
        setupImageAppearance()
        setupImageConstraints()
    }
    func setupVStack() {
        container.addSubview(vStack)
        vStack.addSubview(hStack)
        setupVStackAppearance()
        setupVStackConstraints()
        setupTitleLabel()
        setupTextField()
        setupHStack()
        setupPrioritySchwitcher()
        setupAddButton()
    }
    func setupTitleLabel() {
        setupTitleLabelAppearance()
        setupTitleLabelConstraints()
    }
    func setupTextField() {
        setupTextFieldConstraints()
        setupTextFieldAppearance()
        setupTextFieldDelegate()
    }
    func setupHStack() {
        setupHStackAppearance()
        setupHStackConstraints()
        setupDateLabel()
        setupDatePicker()
    }
    func setupDateLabel() {
        setupDateLabelAppearance()
        setupDateLabelConstraints()
    }
    func setupDate(date: Date) {
        datePicker.date = date
    }
    func setupDatePicker() {
        setupDatePickerAppearance()
        setupDatePickerConstraints()
    }
    func setupPrioritySchwitcher() {
        setupPrioritySchwitcherAppearance()
        setupPrioritySchwitcherConstraints()
    }
    func setupAddButton() {
        setupAddButtonAppearance()
        setupAddButtonConstraints()
    }
    func setupWarningLabel() {
        setupWarningLabelAppearance()
        setupWarningLabelConstraints()
    }
    
    //MARK: setup appearance functions
    
    func setupContainerAppearance() {
        container.backgroundColor    = UIColor.white
        container.layer.cornerRadius = 25
    }
    func setupImageAppearance() {
        imageView.layer.cornerRadius  = 25
        imageView.contentMode         = .scaleToFill
        imageView.layer.masksToBounds = true
        makeGradient(gradientView: imageView)
    }
    func setupVStackAppearance() {
        vStack.axis         = .vertical
        vStack.distribution = .fillEqually
        vStack.alignment    = .fill
        vStack.spacing      = 30
    }
    func setupTitleLabelAppearance() {
        titleLabel.text          = "Add Note"
        titleLabel.textColor     = UIColor.darkText
        titleLabel.font          = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.light)
        titleLabel.textAlignment = .center
    }
    func setupTextFieldAppearance() {
        textField.placeholder              = "Enter yor note here"
        textField.font                     = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.light)
        textField.borderStyle              = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType       = UITextAutocorrectionType.yes
        textField.keyboardType             = UIKeyboardType.default
        textField.returnKeyType            = UIReturnKeyType.done
        textField.clearButtonMode          = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.addTarget(self, action: #selector(textFieldShouldReturn), for: .editingDidEndOnExit)
    }
    func setupHStackAppearance() {
        hStack.backgroundColor = .clear
        hStack.axis            = .horizontal
        hStack.distribution    = .fillEqually
        hStack.alignment       = .fill
    }
    func setupDateLabelAppearance() {
        dateLabel.text          = " For date:   "
        dateLabel.textAlignment = .left
        dateLabel.textColor     = UIColor.secondaryLabel
        dateLabel.font          = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.light)
    }
    func setupDatePickerAppearance() {
        datePicker.datePickerMode  = UIDatePicker.Mode.date
        datePicker.timeZone        = NSTimeZone.local
        datePicker.tintColor       = UIColor.darkText
    }
    func setupPrioritySchwitcherAppearance() {
        prioritySchwitcher.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)
        prioritySchwitcher.selectedSegmentIndex = 1
    }
    func setupAddButtonAppearance() {
        addButton.setTitle("Add Note", for: .normal)
        addButton.setTitleColor(UIColor.secondaryLabel, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.light)
        addButton.addTarget(self, action: #selector(animateButtonTouchDown), for: .touchDown)
        addButton.addTarget(self, action: #selector(buttonTouchUpOutside), for: .touchUpOutside)
        addButton.addTarget(self, action: #selector(buttonTouchUpOutside), for: .touchUpInside)
        
        addButton.backgroundColor     = UIColor.white
        addButton.layer.shadowColor   = UIColor.darkText.cgColor
        addButton.layer.shadowOffset  = CGSize(width: -5.0, height: 5.0)
        addButton.layer.shadowOpacity = 0.6
        addButton.layer.shadowRadius  = 5
        addButton.layer.masksToBounds = false
        addButton.layer.cornerRadius  = 10
    }
    func setupWarningLabelAppearance() {
        warningLabel.text          = warningText
        warningLabel.textColor     = UIColor.systemRed
        warningLabel.font          = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        warningLabel.textAlignment = .center
    }
    
    //MARK: setup delegates functions
    
    func setupTextFieldDelegate() {
        textField.delegate = self
    }
    
    //MARK: setup constraints functions

    func setupContainerConstraints() {
        container.translatesAutoresizingMaskIntoConstraints                                = false
        container.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                = true
        container.centerXAnchor.constraint(equalTo: centerXAnchor).isActive                = true
        container.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive   = true
        container.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
    }
    func setupImageConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints                         = false
        imageView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive     = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive       = true
        imageView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive   = true
        imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true

    }
    func setupVStackConstraints() {
        vStack.translatesAutoresizingMaskIntoConstraints                                            = false
        vStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15).isActive = true
        vStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15).isActive    = true
        vStack.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.8).isActive   = true
        vStack.widthAnchor.constraint(equalTo: container.widthAnchor, constant: -30).isActive       = true
        vStack.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive                  = true
    }
    func setupTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    func setupTextFieldConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
    }
    func setupHStackConstraints() {
        hStack.translatesAutoresizingMaskIntoConstraints = false
    }
    func setupDateLabelConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    func setupDatePickerConstraints() {
        datePicker.translatesAutoresizingMaskIntoConstraints                    = false
        datePicker.rightAnchor.constraint(equalTo: hStack.rightAnchor).isActive = true
    }
    func setupPrioritySchwitcherConstraints() {
        prioritySchwitcher.translatesAutoresizingMaskIntoConstraints = false
    }
    func setupAddButtonConstraints() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
    }
    func setupWarningLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: auxiliary functions
    
    @objc func animateOut() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.alpha = 0
        } completion: { (complete) in
            self.removeFromSuperview()
        }
    }
    @objc func animateIn() {
        self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        self.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.container.transform = .identity
            self.alpha = 1
        }
    }
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!){
       // print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
    }
    @objc func animateButtonTouchDown(_ buttonToAnimate: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            buttonToAnimate.transform          = CGAffineTransform(scaleX: 0.95, y: 0.95)
            buttonToAnimate.layer.shadowOffset = CGSize(width: 1.0, height: -1.0)
            buttonToAnimate.layer.shadowRadius = 5
        }
    }
    @objc func buttonTouchUpOutside(_ buttonToAnimate: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            buttonToAnimate.transform          = CGAffineTransform(scaleX: 1, y: 1)
            buttonToAnimate.layer.shadowOffset = CGSize(width: -5.0, height: 5.0)
            buttonToAnimate.layer.shadowRadius = 5
            self.addNote()
        }
    }
    func addNote() {
        if let text = textField.text {
            if !text.isEmpty {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let date = datePicker.date
                let isDone = false
                let priority = Int16(prioritySchwitcher.selectedSegmentIndex)
                
                let toDoItem = ToDoItem(context: context)
                toDoItem.note = text
                toDoItem.date = date
                toDoItem.isDone = isDone
                toDoItem.priority = priority + 1
                
                addToDoDelegate.addItem(item: toDoItem)
                animateOut()
            } else {
                showWarning()
            }
        } else {
            showWarning()
        }
    }
    func showWarning() {
        warningText = "You can not add an empty note!"
        vStack.addArrangedSubview(warningLabel)
        setupWarningLabel()
    }
    func makeGradient(gradientView: UIView) {
        let gradient            = CAGradientLayer()
        gradient.startPoint     = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint       = CGPoint(x: 0.0, y: 0.0)
        let whiteColor          = UIColor.white
        gradient.colors         = [whiteColor.withAlphaComponent(0.0).cgColor, whiteColor.withAlphaComponent(0.2).cgColor, whiteColor.withAlphaComponent(0.3).cgColor]
        gradient.locations      = [NSNumber(value: 0.0),NSNumber(value: 0.9),NSNumber(value: 1.0)]
        gradient.frame          = gradientView.bounds
        gradientView.layer.mask = gradient
    }
}

//MARK: AddToDoPopup extensions

extension AddToDoPopup: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self)
    }
}

extension AddToDoPopup: UITextFieldDelegate {
    
    @objc func textFieldShouldReturn(userText: UITextField!) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
}
