//
//  AddCourseController.swift
//  SchoolTracker
//
//  Created by Danil Andriuschenko on 05.04.2022.
//

import Foundation
import UIKit
class AddCourseController: UIViewController{
    
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet var codeField: UITextField!
    
    @IBOutlet var creditsSlider: UISlider!
    var course: Course = Course()
    
    var delegate: AddCourseDelegate?
    
    @IBOutlet var creditsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameField.delegate = self
        self.codeField.delegate = self
        
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private var oldValue: Float = 0.0
    
    //Round out values to 0.5
    @IBAction func onSliderChange(_ sender: UISlider) {
        let sliderValue = Float(Int(sender.value * 2)) / 2.0
        sender.value = sliderValue
        creditsLabel.text = "\(sender.value)"
    }
    
    //Present alert
    func presentAlert(reason: AlertReason){
        var title: String = ""
        
        
        switch(reason){
        case .noCode:
            title = "Missing Course code"
        case .noName:
            title = "Missing Course name"
        }
        
        let alertController = UIAlertController(title: title, message: "Make sure that you have filled all entries", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        self.present(alertController, animated: true)
    }
    
    //Save course
    @IBAction func saveAction(_ sender: Any) {
        guard let name = nameField.text, !name.isEmpty else{
            presentAlert(reason: .noName)
            
            return
        }
        
        guard let code = codeField.text, !code.isEmpty else{
            presentAlert(reason: .noCode)
            return
        }
        
        
        self.course.name = name
        self.course.code = code
        self.course.credits = creditsSlider.value
        
        delegate?.willSaveCourse(course: self.course)
        self.dismiss(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate = nil
    }
}


protocol AddCourseDelegate{
    func willSaveCourse(course: Course)
}

extension AddCourseController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}


enum AlertReason{
    case noName
    case noCode
}
