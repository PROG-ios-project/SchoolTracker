//
//  SchoolDB.swift
//  SchoolTracker
//
//  Created by Penric on 4/15/22.
//

import UIKit
import SQLite3

class SchoolDB : NSObject
{
    
    
    func getAllSemesters() //-> [Semester]
    {
        
        
        
    }
    
    func getOneSemester() // -> Semester
    {
        
    }
    
    func getAllCourses() -> [Course]
    {
        var courses : [Course] = []
        
        
        return courses
    }
    
    func getCourseList(semester: Any) -> [Course]
    {
        var courseList : [Course] = []
        
        
        return courseList
    }
    
    func getAssessmentList(course: Course) // -> [Assessment]
    {
        
    }
    
    func addSemester(semester: Any) -> Bool
    {
        
        
        return false
    }
    
    func addCourse(course: Course) -> Bool
    {
        
        
        return false
    }
    
    func addAssessment(assessment: Any) -> Bool
    {
        
        
        return false
    }
    
    func editSemester(oldSem: Any, newSem: Any) -> Bool
    {
        
        
        return false
    }
    
    func editCourse(oldCourse: Course, newCourse: Course) -> Bool
    {
        
        
        return false
    }
    
    func editAssessment(oldAssess: Any, newAssess: Any) -> Bool
    {
        
        
        return false
    }
}
