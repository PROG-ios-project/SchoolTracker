//
//  AssessmentInfoViewController.swift
//  SchoolTracker
//
//  Created by Thomas Forber on 4/18/22.
// Controller that shows detailed information about the selected assessment

import UIKit

class AssessmentInfoViewController: UIViewController {
    
    //Outlet variables for all the labels in the view
    @IBOutlet var nameLbl : UILabel?
    @IBOutlet var categoryLbl : UILabel?
    @IBOutlet var dateDueLbl : UILabel?
    @IBOutlet var dateSubmittedLbl : UILabel?
    @IBOutlet var gradeLbl : UILabel?
    @IBOutlet var isCompleteLbl : UILabel?
    @IBOutlet var isSubmittedLbl : UILabel?
    @IBOutlet var notifTimeLbl : UILabel?
    @IBOutlet var weightLbl : UILabel?
    @IBOutlet var willNotifyLbl : UILabel?
    
    //date format variable for outputting the date from dateDue and dateSubmitted fields
    var dateFormatter = DateFormatter()
    
    //variable for the passed assessment
    var assessment: Assessment!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set the proper date format
        dateFormatter.dateFormat = "dd/MM/yy hh:mm a"
        
        //assigning all the values to the labels
        nameLbl!.text = nameLbl!.text! + assessment.name
        categoryLbl!.text = categoryLbl!.text! + assessment.category
        dateDueLbl!.text = dateDueLbl!.text! + dateFormatter.string(from: assessment.dateDue)
        dateSubmittedLbl!.text = dateSubmittedLbl!.text! + (assessment.dateSubmitted == nil ? "N/A" : dateFormatter.string(from: assessment.dateSubmitted!))
        gradeLbl!.text = gradeLbl!.text! + String(format: "%.2f", arguments: [assessment.grade]) + " \(letterGrade(grade: assessment.grade))"
        isCompleteLbl!.text = isCompleteLbl!.text! + (assessment.isComplete ? "Complete" : "Incomplete")
        isSubmittedLbl!.text = isSubmittedLbl!.text! + (assessment.isSubmitted ? "Submitted" : "Not Submitted")
        notifTimeLbl!.text = notifTimeLbl!.text! + (assessment.willNotify ? String(format: "%d minutes before", assessment.notificationTime) : "N/A" )
        weightLbl!.text = weightLbl!.text! + String(format: "%0.2f %", assessment.weight)
        willNotifyLbl!.text = willNotifyLbl!.text! + (assessment.willNotify ? "Yes" : "No")
        
        self.view.subviews.forEach({($0 as? UILabel)?.sizeToFit()})
    }
    
    //function to convert percentage grade to letter grade
    func letterGrade(grade: Float) -> String {
        if grade >= 95.0 { return "A+" }
        else if grade >= 87.0 { return "A" }
        else if grade >= 80.0 { return "A-" }
        else if grade >= 77.0 { return "B+" }
        else if grade >= 73.0 { return "B" }
        else if grade >= 70.0 { return "B-" }
        else if grade >= 67.0 { return "C+" }
        else if grade >= 63.0 { return "C" }
        else if grade >= 60.0 { return "C-" }
        else if grade >= 57.0 { return "D+" }
        else if grade >= 53.0 { return "D" }
        else if grade >= 50.0 { return "D-" }
        else  { return "F" }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
