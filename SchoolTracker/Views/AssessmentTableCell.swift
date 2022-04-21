//
//  AssessmentTableCell.swift
//  SchoolTracker
//
//  Created by Danyl Andriuschenko on 18.04.2022.
//
/*
Custom table view cell class for assessment object. Dsiplays name, due date or grade, weight and submission status
 */
import Foundation
import UIKit
class AssessmentTableCell: UITableViewCell{
    
    
    var assessment: Assessment!
    
    var background: UIView = UIView()
    var nameLbl = UILabel()
    var dueDateOrGradeLbl = UILabel()
    var weightLbl = UILabel()
    
    var statusImageView = UIImageView()
    var statusLbl = UILabel()
    
    //Return image for displaying status
    private var statusImage: UIImage?{
        get{
            switch assessment.status{
            case .submitted:
                return UIImage(systemName: "checkmark.circle.fill")
            case .late:
                return UIImage(systemName: "xmark.circle.fill")
            case .notSubmitted:
                return UIImage(systemName: "exclamationmark.circle.fill")
            }
        }
    }
    
    //Retrun text for displaying status
    private var statusText: String{
        get{
            switch assessment.status{
            case .submitted:
                return "Submitted"
            case .late:
                return "Late"
            case .notSubmitted:
                return "Not submitted"
            }
        }
    }
    
    private var color: UIColor{
        switch assessment.status{
        case .submitted:
            return .init(red: 0, green: 0.8, blue: 122/255, alpha: 1)
        case .late:
            return .red
        case .notSubmitted:
            return .blue
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.background.removeFromSuperview()
        self.nameLbl.removeFromSuperview()
        self.dueDateOrGradeLbl.removeFromSuperview()
        self.statusImageView.removeFromSuperview()
        self.statusLbl.removeFromSuperview()
    }
    
    
    
    
    func start(assessment: Assessment){
        self.assessment = assessment
        

        
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
        
        //Create name label
        nameLbl = UILabel()
        nameLbl.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        nameLbl.text = assessment.name
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        nameLbl.sizeToFit()
        background.addSubview(nameLbl)
        
        //Set constraints

        nameLbl.heightAnchor.constraint(equalToConstant: nameLbl.frame.height).isActive = true
        nameLbl.widthAnchor.constraint(equalToConstant: nameLbl.frame.width).isActive = true
        nameLbl.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 15).isActive = true
        
        //Create due date label
        dueDateOrGradeLbl = UILabel()
      
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy hh:mm a"
        
        dueDateOrGradeLbl.text = assessment.status == .submitted ? "Grade: \(Int(assessment.grade))%" : "Due date: \(dateFormatter.string(from: assessment.dateDue))"
        dueDateOrGradeLbl.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        dueDateOrGradeLbl.textColor = .darkGray
        
        dueDateOrGradeLbl.translatesAutoresizingMaskIntoConstraints = false
        dueDateOrGradeLbl.sizeToFit()
        background.addSubview(dueDateOrGradeLbl)
        
        dueDateOrGradeLbl.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        dueDateOrGradeLbl.widthAnchor.constraint(equalToConstant: dueDateOrGradeLbl.frame.size.width).isActive = true
        dueDateOrGradeLbl.heightAnchor.constraint(equalToConstant: dueDateOrGradeLbl.frame.size.height).isActive = true
        dueDateOrGradeLbl.leadingAnchor.constraint(equalTo: nameLbl.leadingAnchor).isActive = true
        nameLbl.bottomAnchor.constraint(equalTo: dueDateOrGradeLbl.topAnchor, constant: -5).isActive = true
        
        //Create weight label
        weightLbl = UILabel()
        
        weightLbl.text = "Weight: \(Int(assessment.weight))%"
        weightLbl.font = UIFont.systemFont(ofSize: 12, weight: .light)
        weightLbl.translatesAutoresizingMaskIntoConstraints = false
        weightLbl.sizeToFit()
        weightLbl.textColor = .darkGray
        background.addSubview(weightLbl)
        
        weightLbl.topAnchor.constraint(equalTo: dueDateOrGradeLbl.bottomAnchor, constant: 5).isActive = true
        weightLbl.leadingAnchor.constraint(equalTo: nameLbl.leadingAnchor).isActive = true
        weightLbl.widthAnchor.constraint(equalToConstant: weightLbl.frame.size.width).isActive = true
        weightLbl.heightAnchor.constraint(equalToConstant: weightLbl.frame.size.height).isActive = true
        
        //Status label
        statusLbl = UILabel()
        statusLbl.text = statusText
        statusLbl.translatesAutoresizingMaskIntoConstraints = false
        statusLbl.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        statusLbl.font = UIFont.systemFont(ofSize: 18)
        statusLbl.textColor = color
        statusLbl.sizeToFit()
        
        background.addSubview(statusLbl)
        
        statusLbl.centerYAnchor.constraint(equalTo: background.centerYAnchor).isActive = true
        statusLbl.heightAnchor.constraint(equalToConstant: statusLbl.frame.height).isActive = true
        statusLbl.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -15).isActive = true
        
        statusImageView = UIImageView()
        statusImageView.image = statusImage
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        statusImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        statusImageView.contentMode = .scaleAspectFill
        statusImageView.tintColor = color
        background.addSubview(statusImageView)
        
        statusImageView.centerYAnchor.constraint(equalTo: statusLbl.centerYAnchor).isActive = true
        statusImageView.trailingAnchor.constraint(equalTo: statusLbl.leadingAnchor, constant: -5).isActive = true
    }
}
