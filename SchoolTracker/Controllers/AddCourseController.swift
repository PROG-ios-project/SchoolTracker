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
    @IBAction func onSliderChange(_ sender: UISlider) {
        let sliderValue = Float(Int(sender.value * 2)) / 2.0
        sender.value = sliderValue
        creditsLabel.text = "\(sender.value)"
    }
    
    
    //Save course
    @IBAction func saveAction(_ sender: Any) {
        self.course.name = nameField.text ?? ""
        self.course.code = codeField.text ?? ""
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
