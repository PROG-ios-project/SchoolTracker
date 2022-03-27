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
    
    
    var course: Course!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        
        nameLbl.removeFromSuperview()
    }
    
    func start(course: Course){
        self.course = course
        
        self.contentView.backgroundColor = .white
        self.layer.cornerRadius = 20
        
        self.contentView.layer.cornerRadius = 20
     
        self.clipsToBounds = true
        
        
        nameLbl = UILabel()
        nameLbl.font = UIFont.systemFont(ofSize: 23, weight: .heavy)
        nameLbl.text = course.name
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        nameLbl.sizeToFit()
        self.contentView.addSubview(nameLbl)
        
        nameLbl.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).isActive = true
        nameLbl.heightAnchor.constraint(equalToConstant: nameLbl.frame.height).isActive = true
        nameLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
    }
    
}
