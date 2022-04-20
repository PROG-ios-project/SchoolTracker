//
//  Class.swift
//  SchoolTracker
//
//  Created by Danylo Andriuschenko on 24.03.2022.
//

import Foundation
class Course{
    var id: Int = -1
    var semId: Int = -1
    var name: String = ""
    var code: String = ""
    var grade: Float = 0.0
    var isComplete: Bool = false
    var credits: Float = 0.0
    
    init(){
        
    }
    
    init(semId : Int, name: String, code: String, credits: Float){
        self.semId = semId
        self.name = name
        self.code = code
        self.credits = credits
    }
    
    init(id : Int, semId : Int, name: String, code: String, credits: Float, grade: Float, isComplete: Bool){
        self.id = id
        self.semId = semId
        self.name = name
        self.code = code
        self.credits = credits
        self.grade = grade
        self.isComplete = isComplete
    }
    
    //Calculate total grade of the course based on assessment results
    func calculateGrade(assessments: [Assessment]) -> Float{
        var total: Float = 0.0
        assessments.forEach({
            total += $0.weight * ($0.grade / 100)
        })
        return total
    }
    
    
}
