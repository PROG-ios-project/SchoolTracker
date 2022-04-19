//
//  SemesterTableCell.swift
//  SchoolTracker
//
//  Created by Penric on 4/19/22.
//

import Foundation
import UIKit

class SemesterTableCell: UITableViewCell {
    
    var termLbl : UILabel = UILabel()
    var yearLbl : UILabel = UILabel()
    var completionLbl : UILabel = UILabel()
    var gradeLbl : UILabel = UILabel()

    var semester : Semester!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        termLbl.removeFromSuperview()
        yearLbl.removeFromSuperview()
        completionLbl.removeFromSuperview()
        gradeLbl.removeFromSuperview()
    }
    
    func start(semester: Semester) {
        self.semester = semester
        var termString : String = ""
        if semester.term == 3 {
            termString = "Fall"
        } else if semester.term == 2 {
            termString = "Spring/Summer"
        } else {
            termString = "Winter"
        }
    }

}
