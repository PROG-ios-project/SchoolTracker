//
//  Class.swift
//  SchoolTracker
//
//  Created by Danil Andriuschenko on 24.03.2022.
//

import Foundation
class Course{
    var name: String = ""
    var code: String = ""
    private var grade: Double = 0.0
    private var isComplete: Bool = false
    var credits: Float = 0.0
    
    init(){
        
    }
    
    init(name: String, code: String, credits: Float){
        self.name = name
        self.code = code
      //  self.endDate = endDate
        self.credits = credits
    }
}
