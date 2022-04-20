//
//  Semester.swift
//  SchoolTracker
//
//  Created by Penric on 4/15/22.
//

import Foundation

class Semester {
    var id : Int = -1
    var term : Int = 0
    var year : Int = -1
    var isComplete : Bool = false
    var grade : Float = 0.0
    
    //Get courses for a semester
    var courses: [Course]{
        get{
            return SchoolDB.shared.getCourseList(semId: self.id)
        }
    }
    
    
    init(){
        
    }
    
    //Update gpa based on courses
    func updateGPA(){
        let courses = self.courses
        
        self.isComplete = !courses.contains(where: {!$0.isComplete})
        self.grade = calculateGPA(courses: courses)
        
        SchoolDB.shared.editSemester(newSem: self)
    }
    
    //Calculate GPA
    private func calculateGPA(courses: [Course]) -> Float{
        var totalCredits: Float = 0.0
        var totalCreditValues: Float = 0.0
        
        for course in courses {
            totalCredits += course.credits
            totalCreditValues += course.weightedCreditValue
        }
        
        return totalCreditValues / totalCredits
    }
    
    
    
    
    init(term: Int, year: Int){
        self.term = term
        self.year = year
    }
    
    init(id: Int, term: Int, year: Int, isComplete: Bool, grade: Float){
        self.id = id
        self.term = term
        self.year = year
        self.isComplete = isComplete
        self.grade = grade
    }
}
