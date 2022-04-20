//
//  AddSemesterController.swift
//  SchoolTracker
//
//  Created by Danil Andriuschenko on 19.04.2022.
//

import Foundation
import UIKit

class AddSemesterController: UIViewController{
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var yearField: UITextField!
    @IBOutlet var termPicker: UIPickerView!
    
    let terms = ["Winter", "Summer", "Fall"]
    
    var semester: Semester = Semester()
    
    var delegate: SemesterAddDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        yearField.delegate = self
        termPicker.dataSource = self
        termPicker.delegate = self
    }
    
    
    //Present alert
    func presentAlert(reason: AlertReason){
        var title: String = ""
        
        
        switch(reason){
        case .noYear:
            title = "Wrong year"
        default:
            title = "Try again"
        }
        
        let alertController = UIAlertController(title: title, message: "Make sure that you have filled all entries", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        self.present(alertController, animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard let text = yearField.text, let year = Int(text) else{
            presentAlert(reason: .noYear)
            
            return
        }
        semester.year = year
        semester.term = termPicker.selectedRow(inComponent: 0)
        
        self.delegate?.willSaveSemester(semester: semester)
        self.dismiss(animated: true)
    }
}

extension AddSemesterController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}


extension AddSemesterController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return terms.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return terms[row]
    }
    
    
}


protocol SemesterAddDelegate{
    func willSaveSemester(semester: Semester)
}
