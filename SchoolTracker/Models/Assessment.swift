//
//  Assessment.swift
//  SchoolTracker
//
//  Created by Penric on 4/15/22.
//

import Foundation

class Assessment {
    var id : Int = -1
    var name : String = ""
    var courseId : Int = -1
    var dateDue : Date = Date()
    var dateSubmitted : Date? = nil
    var weight : Float = 0.0
    var isComplete : Bool = false
    var isSubmitted : Bool = false
    var willNotify : Bool = false
    var notificationTime : Int = 0
    var grade : Float = 0.0
    var category : String = ""
    
    //Get course
    var course: Course?{
        get{
            return SchoolDB.shared.getSingleCourse(id: courseId)
        }
    }
    
    
    //Status of the submission
    var status: AssessmentStatus{
        get{
            if self.isSubmitted{
                return .submitted
            }
            else if !self.isSubmitted && self.dateDue < Date(){
                return .late
            }
            else{
                return .notSubmitted
            }
        }
    }
    
    init(){
        
    }
    
    init(name : String, courseId : Int, dateDue: Date, weight: Float, willNotify: Bool, notificationTime: Int, category: String){
        self.name = name
        self.courseId = courseId
        self.dateDue = dateDue
        self.weight = weight
        self.willNotify = willNotify
        self.notificationTime = notificationTime
        self.category = category
    }
    
    init(id: Int, name: String, courseId: Int, dateDue: Date, dateSubmitted: Date?, weight: Float, isComplete: Bool, isSubmitted: Bool, willNotify: Bool, notificationTime: Int, grade: Float, category: String){
        self.id = id
        self.name = name
        self.courseId = courseId
        self.dateDue = dateDue
        self.dateSubmitted = dateSubmitted
        self.weight = weight
        self.isComplete = isComplete
        self.isSubmitted = isSubmitted
        self.willNotify = willNotify
        self.notificationTime = notificationTime
        self.grade = grade
        self.category = category
    }
}


enum AssessmentStatus{
    case late
    case notSubmitted
    case submitted
}
