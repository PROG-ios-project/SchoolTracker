//
//  AssessmentInfoViewController.swift
//  SchoolTracker
//
//  Created by Penric on 4/18/22.
//

import UIKit

class AssessmentInfoViewController: UIViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
