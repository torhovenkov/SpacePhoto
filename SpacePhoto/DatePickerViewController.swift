//
//  DatePickerViewController.swift
//  SpacePhoto
//
//  Created by Vladyslav Torhovenkov on 05.07.2023.
//

import UIKit

protocol DatePickerViewControllerDelegate {
    func dateSelected(date: Date)
}

class DatePickerViewController: UIViewController {
    
    var delegate: DatePickerViewControllerDelegate?

    @IBOutlet var datePicker: UIDatePicker!
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        delegate?.dateSelected(date: self.datePicker.date)
        dismiss(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        self.sheetPresentationController?.detents = [.medium()]
        // Do any additional setup after loading the view.
    }
    
    init?(coder: NSCoder, delegate: DatePickerViewControllerDelegate) {
        self.delegate = delegate
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDatePicker() {
        let today = Date()
        let oneDayBefore = Calendar.current.date(byAdding: .day, value: -1, to: today)
        
        datePicker.maximumDate = oneDayBefore
        
    }
}


