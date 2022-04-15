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
    var endDateLbl: UILabel = UILabel()
    
    
    var course: Course!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        
        nameLbl.removeFromSuperview()
        codeLbl.removeFromSuperview()
        endDateLbl.removeFromSuperview()
    }
    
    func start(course: Course){
        self.course = course
        
        self.contentView.backgroundColor = .init(white: 0.95, alpha: 1)
        self.layer.cornerRadius = 20
        
        self.contentView.layer.cornerRadius = 20
     
        self.clipsToBounds = true
        
        //Create name label
        nameLbl = UILabel()
        nameLbl.font = UIFont.systemFont(ofSize: 23, weight: .heavy)
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
        
        endDateLbl = UILabel()
        endDateLbl.font = UIFont.systemFont(ofSize: 18, weight: .light)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy"
        
        //endDateLbl.text = "Ends \(dateFormatter.string(from: course.endDate))"
        endDateLbl.translatesAutoresizingMaskIntoConstraints = false
        endDateLbl.sizeToFit()
        
        self.contentView.addSubview(endDateLbl)
        
        endDateLbl.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20).isActive = true
        endDateLbl.heightAnchor.constraint(equalToConstant: endDateLbl.frame.height).isActive = true
        endDateLbl.leadingAnchor.constraint(equalTo: self.nameLbl.leadingAnchor).isActive = true
    }
    
}
