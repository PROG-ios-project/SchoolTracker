//
//  SchoolDB.swift
//  SchoolTracker
//
//  Created by Penric on 4/15/22.
//

import UIKit
import SQLite3

class SchoolDB
{
    private var mainDelegate : AppDelegate
    
    init(){
        mainDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func getAllSemesters() -> [Semester]
    {
        var db: OpaquePointer? = nil
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath)")
            
            
            var queryStmt: OpaquePointer? = nil
            var queryStmtString : String = "select * from semester"
            
            // step 7e - setup object that will handle data transfer
            if sqlite3_prepare_v2(db, queryStmtString, -1, &queryStmt, nil) == SQLITE_OK {
                
                // step 7f - loop through row by row to extract dat
                while( sqlite3_step(queryStmt) == SQLITE_ROW ) {
                    
                }
            }
        }
        
        return []
    }
    
    func getOneSemester() -> Semester?
    {
        var sem : Semester = Semester()
        
        return sem
    }
    
    func getAllCourses() -> [Course]
    {
        var courses : [Course] = []
        
        
        return courses
    }
    
    func getCourseList(semester: Semester) -> [Course]
    {
        var courseList : [Course] = []
        
        
        return courseList
    }
    
    func getAssessmentList(course: Course) // -> [Assessment]
    {
        
    }
    
    func addSemester(semester: Semester) -> Bool
    {
        
        
        return false
    }
    
    func addCourse(course: Course) -> Bool
    {
        
        
        return false
    }
    
    func addAssessment(assessment: Assessment) -> Bool
    {
        
        
        return false
    }
    
    func editSemester(oldSem: Semester, newSem: Semester) -> Bool
    {
        
        
        return false
    }
    
    func editCourse(oldCourse: Course, newCourse: Course) -> Bool
    {
        
        
        return false
    }
    
    func editAssessment(oldAssess: Assessment, newAssess: Assessment) -> Bool
    {
        
        
        return false
    }
}
