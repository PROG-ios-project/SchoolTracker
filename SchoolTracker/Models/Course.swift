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
    
    //Get assessments
    var assessments: [Assessment]{
        get{
            return SchoolDB.shared.getAssessmentList(courseId: self.id)
        }
    }
    
    //Get semester
    var semester: Semester?{
        get{
            return SchoolDB.shared.getOneSemester(id: semId)
        }
    }
    
    //Convert grade into grade points
    private var points: Float{
        get{
            switch(grade){
            case 90...Float.greatestFiniteMagnitude:
                return 4.0
            case 85..<90:
                return 3.8
            case 80..<85:
                return 3.6
            case 75..<80:
                return 3.3
            case 70..<75:
                return 3.0
            case 65..<70:
                return 2.5
            case 60..<65:
                return 2.0
            case 55..<60:
                return 1.5
            case 50..<55:
                return 1.0
            case 0..<50:
                return 0.0
            default:
                return 0.0
            }
        }
    }
    
    //Calculated credit value
    var weightedCreditValue: Float{
        get{
            return points * credits
        }
    }
    
    
    
    //Update grade
    func updateGrade(){
        let assessments = self.assessments
        self.isComplete = !assessments.contains(where: {!$0.isComplete})
        self.grade = calculateGrade(assessments: assessments)
        
        SchoolDB.shared.editCourse(newCourse: self)
    }
    
    init(){
        
    }
    
    //Calculate total grade of the course based on assessment results
    private func calculateGrade(assessments: [Assessment]) -> Float{
        var total: Float = 0.0
        assessments.forEach({
            total += $0.weight * ($0.grade / 100)
        })
        return total
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
    
    
    
}
