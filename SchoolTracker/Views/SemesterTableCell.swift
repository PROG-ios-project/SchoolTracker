//
//  SemesterTableCell.swift
//  SchoolTracker
//
//  Created by Danylo Andriuschenko on 19.04.2022.
//

import Foundation
import UIKit

class SemesterTableCell: UITableViewCell{
    
    
    var semester: Semester!
    var background = UIView()
    var titleLbl: UILabel = UILabel()
    var gradeLbl: UILabel = UILabel()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.background.removeFromSuperview()
        self.titleLbl.removeFromSuperview()
        gradeLbl.removeFromSuperview()
    }
    
    //returns text for title based on year and term
    func returnText(semester: Semester) -> String{
        var text = ""
        switch semester.term{
        case 0:
            text = "Winter"
        case 1:
            text = "Summer"
        case 2:
            text = "Fall"
        default:
            break
        }
        
        text += " - \(semester.year)"
        return text
    }
    
    
    //Make table view cell look pretty
    func start(semester: Semester){
        self.semester = semester
        
        self.selectionStyle = .none
        self.separatorInset.right = .greatestFiniteMagnitude
        
        
        background = UIView()
        background.backgroundColor = .init(white: 0.95, alpha: 1)
        background.layer.cornerRadius = 20
        background.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(background)
        background.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        background.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        background.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        background.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
        
        titleLbl = UILabel()
        titleLbl.text = returnText(semester: semester)
        titleLbl.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.sizeToFit()
        
        background.addSubview(titleLbl)
        
        titleLbl.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 15).isActive = true
        titleLbl.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        titleLbl.widthAnchor.constraint(equalToConstant: titleLbl.frame.width).isActive = true
        titleLbl.heightAnchor.constraint(equalToConstant: titleLbl.frame.height).isActive = true
        
        
        
        //Set grade label
        gradeLbl = UILabel()
        
        gradeLbl.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        gradeLbl.text = "GPA: " + (!semester.isComplete ? "N/A" : String(format: "%.2f", arguments: [semester.grade]))
        gradeLbl.translatesAutoresizingMaskIntoConstraints = false
        gradeLbl.sizeToFit()
        if !semester.isComplete{
            gradeLbl.textColor = .lightGray
        }
        
        background.addSubview(gradeLbl)
        
        gradeLbl.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        gradeLbl.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -25).isActive = true
        gradeLbl.heightAnchor.constraint(equalToConstant: gradeLbl.frame.height).isActive = true
        gradeLbl.widthAnchor.constraint(equalToConstant: gradeLbl.frame.width).isActive = true
    }
}
