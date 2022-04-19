//
//  AddAssessmentViewController.swift
//  SchoolTracker
//
//  Created by Penric on 4/18/22.
//
import Foundation
import UIKit

class AddAssessmentViewController: UIViewController {

    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameField.delegate = self
        self.CategoryField.delegate = self
        
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private var oldValue: Float = 0.0
    
    //Round out values to 0.5
    @IBAction func WeightChange(_ sender: UISlider) {
        let Weight = WeightField.value
        let strWeight = String(format: "%0.0f", Weight)
        lbWeightValue.text = strWeight
    }
    @IBAction func GradeChange(_ sender: UISlider) {
        let Grade = GradeField.value
        let strGrade = String(format: "%0.01f", Grade)
        lbGradeValue.text = strGrade
    }
    
    //Present alert
    func presentAlert(reason: AlertReason1){
        var title: String = ""
        
        
        switch(reason){
        case .noDateDue:
            title = "Missing Assessment Date Due"
        case .noName:
            title = "Missing Assessment name"
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
        dateFormmater.dateFormat = "MM-dd-yyyy HH:mm"
        duetime = dateFormmater.string(from: DateTimeDueField.date)
        self.view.endEditing(true)
        guard let duedate = duetime, !duedate.isEmpty else{
            presentAlert(reason: .noDateDue)
            return
        }
        
        let notificationTimeOption = NotificationTimeField.selectedSegmentIndex
        
        if notificationTimeOption == 0
        {
            notificationtime = 1
        }
        else if notificationTimeOption == 1
        {
            notificationtime = 2
        }
        else if notificationTimeOption == 2
        {
            notificationtime = 3
        }
        else if notificationTimeOption == 3
        {
            notificationtime = 4
        }
        else if notificationTimeOption == 4
        {
            notificationtime = 5
        }
        
        self.assessment.name = name
        self.assessment.dateDue = DateTimeDueField.date
        self.assessment.dateSubmitted = DateTimeSubmittedField.date
        self.assessment.grade = GradeField.value
        self.assessment.category = CategoryField.text!
        self.assessment.isComplete = isCompleteField.isOn
        self.assessment.isSubmitted = isSubmittedField.isOn
        self.assessment.willNotify = willNotifyField.isOn
        self.assessment.notificationTime = notificationtime!
        self.assessment.weight = WeightField.value
        
        
        delegate?.willSaveAssessment(assessment: self.assessment)
        self.dismiss(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate = nil
    }

}
protocol AddAssessmentDelegate{
    func willSaveAssessment(assessment: Assessment)
}

extension AddAssessmentViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}


enum AlertReason1{
    case noName
    case noDateDue
}
