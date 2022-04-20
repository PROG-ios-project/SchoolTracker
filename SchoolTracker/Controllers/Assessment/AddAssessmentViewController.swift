//
//  AddAssessmentViewController.swift
//  SchoolTracker
//
//  Created by Lam Bich on 4/18/22.
//
import Foundation
import UIKit

class AddAssessmentViewController: UIViewController {

    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var nameField : UITextField!
    @IBOutlet var WeightField : UISlider!
    @IBOutlet var DateTimeDueField : UIDatePicker!
    @IBOutlet var DateTimeSubmittedField : UIDatePicker!
    @IBOutlet var isCompleteField : UISwitch!
    @IBOutlet var isSubmittedField : UISwitch!
    @IBOutlet var willNotifyField : UISwitch!
    @IBOutlet var NotificationTimeField : UISegmentedControl!
    @IBOutlet var GradeField : UISlider!
    @IBOutlet var CategoryField : UITextField!
    
    var duetime:String?
    var submittedtime:String?
    var notificationtime:Int?
    
    @IBOutlet var lbGradeValue : UILabel!
    @IBOutlet var lbWeightValue : UILabel!
    
    var assessment: Assessment = Assessment()
    
    var delegate: AddAssessmentDelegate?
    
    var isAssessmentEditing: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameField.delegate = self
        self.CategoryField.delegate = self
        
        if isAssessmentEditing{
            self.nameField.text = assessment.name
            self.DateTimeDueField.date = assessment.dateDue
            self.DateTimeSubmittedField.date = assessment.dateSubmitted ?? Date()
            self.WeightField.setValue(assessment.weight, animated: false)
            self.isCompleteField.setOn(assessment.isComplete, animated: false)
            self.isSubmittedField.setOn(assessment.isSubmitted, animated: false)
            self.willNotifyField.setOn(assessment.willNotify, animated: false)
            self.NotificationTimeField.selectedSegmentIndex = convertToSegmentIndex(assessment: assessment)
            self.GradeField.setValue(assessment.grade,animated: false)
            self.CategoryField.text = assessment.category
            
            
            WeightChange(WeightField)
            GradeChange(GradeField)
        }
        else{
            self.DateTimeDueField.date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            
        }
        
        
    }
    
    
    //Convert minutes into segment option
    func convertToSegmentIndex(assessment: Assessment) -> Int{
        switch assessment.notificationTime{
        case 0:
            return 0
        case 60:
            return 1
        case 720:
            return 2
        case 1440:
            return 3
        default:
            return 0
        }
    }
    
    //Convert segment option to minutes
    func convertToMinutes(index: Int) -> Int{
        switch index{
        case 0:
            return 0
        case 1:
            return 60
        case 2:
            return 720
        case 3:
            return 1440
        default:
            return 0
        }
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

    //Round out values
    @IBAction func WeightChange(_ sender: UISlider) {
        let Weight = WeightField.value
        let strWeight = String(format: "%0.0f", Weight) + "%"
        lbWeightValue.text = strWeight
        lbWeightValue.sizeToFit()
    }
    @IBAction func GradeChange(_ sender: UISlider) {
        let Grade = GradeField.value
        let strGrade = String(format: "%0.01f", Grade) + "%"
        lbGradeValue.text = strGrade
        lbGradeValue.sizeToFit()
    }
    
    //Present alert
    func presentAlert(reason: AlertReason){
        var title: String = ""
        
        
        switch(reason){
        case .noDueDate:
            title = "Missing Assessment Date Due"
        case .noName:
            title = "Missing Assessment name"
        default:
            title = "Try again"
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
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "MM-dd-yyyy HH:mm a"
        duetime = dateFormmater.string(from: DateTimeDueField.date)
        self.view.endEditing(true)
        guard let duedate = duetime, !duedate.isEmpty else{
            presentAlert(reason: .noDueDate)
            return
        }
        
        let notificationTimeOption = NotificationTimeField.selectedSegmentIndex
        
        self.assessment.notificationTime = convertToMinutes(index: notificationTimeOption)
        self.assessment.name = name
        self.assessment.dateDue = DateTimeDueField.date
        self.assessment.dateSubmitted = DateTimeSubmittedField.date
        self.assessment.grade = GradeField.value
        self.assessment.category = CategoryField.text!
        self.assessment.isComplete = isCompleteField.isOn
        self.assessment.isSubmitted = isSubmittedField.isOn
        self.assessment.willNotify = willNotifyField.isOn
       
        self.assessment.weight = WeightField.value
        
        
        delegate?.willSaveAssessment(assessment: self.assessment, isEditing: isAssessmentEditing)
        self.dismiss(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate = nil
    }

}
protocol AddAssessmentDelegate{
    func willSaveAssessment(assessment: Assessment, isEditing: Bool)
}

extension AddAssessmentViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}



