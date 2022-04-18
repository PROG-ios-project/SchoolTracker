//
//  ClassTableCell.swift
//  SchoolTracker
//
//  Created by Danil Andriuschenko on 24.03.2022.
//

import Foundation
import UIKit

class ClassTableCell: UITableViewCell{
    
    
    
    var nameLbl: UILabel = UILabel()
    var codeLbl: UILabel = UILabel()
    var creditLbl: UILabel = UILabel()
    var gradeLbl: UILabel = UILabel()
    
    var course: Course!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        
        nameLbl.removeFromSuperview()
        codeLbl.removeFromSuperview()
        creditLbl.removeFromSuperview()
        gradeLbl.removeFromSuperview()
    }
    
    //Add content to course table row with a course as a model
    func start(course: Course){
        self.course = course
        
        self.contentView.backgroundColor = .init(white: 0.95, alpha: 1)
        self.layer.cornerRadius = 20
        
        self.contentView.layer.cornerRadius = 20
     
        self.clipsToBounds = true
        
        //Create name label
        nameLbl = UILabel()
        nameLbl.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        nameLbl.text = course.name
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        nameLbl.sizeToFit()
        self.contentView.addSubview(nameLbl)
        
        //Set constraints
        nameLbl.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).isActive = true
        nameLbl.heightAnchor.constraint(equalToConstant: nameLbl.frame.height).isActive = true
        nameLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        //Create code label
        codeLbl = UILabel()
        codeLbl.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        codeLbl.text = course.code
        codeLbl.translatesAutoresizingMaskIntoConstraints = false
        codeLbl.sizeToFit()
        
        self.contentView.addSubview(codeLbl)
        
        //Set constraint
        codeLbl.topAnchor.constraint(equalTo: self.nameLbl.bottomAnchor, constant: 10).isActive = true
        codeLbl.leadingAnchor.constraint(equalTo: self.nameLbl.leadingAnchor).isActive = true
        codeLbl.heightAnchor.constraint(equalToConstant: codeLbl.frame.height).isActive = true
        
        //Set credit label
        creditLbl = UILabel()
        creditLbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
        creditLbl.text = "Credits: \(course.credits)"
        creditLbl.translatesAutoresizingMaskIntoConstraints = false
        creditLbl.sizeToFit()
        
        self.contentView.addSubview(creditLbl)
        
        creditLbl.topAnchor.constraint(equalTo: self.codeLbl.bottomAnchor, constant: 10).isActive = true
        creditLbl.leadingAnchor.constraint(equalTo: self.nameLbl.leadingAnchor).isActive = true
        creditLbl.heightAnchor.constraint(equalToConstant: creditLbl.frame.height).isActive = true
        
        //Set grade label
        gradeLbl = UILabel()
        
        gradeLbl.font = UIFont.systemFont(ofSize: course.isComplete ? 32 : 16, weight: .medium)
        gradeLbl.text = course.isComplete ? "\(Int(course.grade))%" : "Not completed"
        gradeLbl.translatesAutoresizingMaskIntoConstraints = false
        gradeLbl.sizeToFit()
        if !course.isComplete{
            gradeLbl.textColor = .lightGray
        }
        
        self.contentView.addSubview(gradeLbl)
        
        gradeLbl.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        gradeLbl.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
        gradeLbl.heightAnchor.constraint(equalToConstant: gradeLbl.frame.height).isActive = true
        gradeLbl.widthAnchor.constraint(equalToConstant: gradeLbl.frame.width).isActive = true
    }
    
}
