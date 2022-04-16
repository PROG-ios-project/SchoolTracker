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
    private var dateFormatter = DateFormatter()
    
    
    init(){
        mainDelegate = UIApplication.shared.delegate as! AppDelegate
        dateFormatter.dateFormat = "dd/MM/yy hh:mm"
    }
    
    
    func getAllSemesters() -> [Semester]
    {
        var db: OpaquePointer? = nil
        var semesters : [Semester] = []
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath)")
            
            
            var queryStmt: OpaquePointer? = nil
            var queryStmtString : String = "select * from semester"
            
            // step 7e - setup object that will handle data transfer
            if sqlite3_prepare_v2(db, queryStmtString, -1, &queryStmt, nil) == SQLITE_OK {
                
                // step 7f - loop through row by row to extract dat
                while( sqlite3_step(queryStmt) == SQLITE_ROW ) {
                    
                    let id : Int = Int(sqlite3_column_int(queryStmt,0))
                    let term : Int = Int(sqlite3_column_int(queryStmt,1))
                    let year : Int = Int(sqlite3_column_int(queryStmt,2))
                    let isCompleteInt : Int = Int(sqlite3_column_int(queryStmt,3))
                    let isComplete = (isCompleteInt == 0 ? false : true)
                    let grade : Float = Float(sqlite3_column_double(queryStmt, 4))
                    
                    let semester = Semester(id: id, term: term, year: year, isComplete: isComplete, grade: grade)
                    semesters.append(semester)
                }
                sqlite3_finalize(queryStmt)
            } else{
                print("SELECT statement could not be prepared")
            }
            sqlite3_close(db)
        } else{
            print("Unable to open database.")
        }
        
        return semesters
    }
    
    func getOneSemester(id: Int) -> Semester?
    {
        var sem : Semester? = nil
        var db : OpaquePointer? = nil
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath)")
            
            var queryStmt: OpaquePointer? = nil
            var queryStmtString : String = "select * from semester where id = ?"
            
            if sqlite3_prepare_v2(db, queryStmtString, -1, &queryStmt, nil) == SQLITE_OK {
                
                sqlite3_bind_int(queryStmt, 1, Int32(id))
                
                while( sqlite3_step(queryStmt) == SQLITE_ROW ) {
                    
                    let term : Int = Int(sqlite3_column_int(queryStmt,1))
                    let year : Int = Int(sqlite3_column_int(queryStmt,2))
                    let isCompleteInt : Int = Int(sqlite3_column_int(queryStmt,3))
                    let isComplete = (isCompleteInt == 0 ? false : true)
                    let grade : Float = Float(sqlite3_column_double(queryStmt, 4))
                    
                    sem = Semester(id: id, term: term, year: year, isComplete: isComplete, grade: grade)
                }
                sqlite3_finalize(queryStmt)
            } else{
                print("SELECT statement could not be prepared")
            }
            sqlite3_close(db)
        } else{
            print("Unable to open database.")
        }
        return sem
    }
    
    func getCurrentSemester() -> Semester?
    {
        var sem : Semester? = nil
        var db : OpaquePointer? = nil
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath)")
            
            var queryStmt: OpaquePointer? = nil
            let queryStmtString : String = "select * from semester order by id desc limit 1"
            
            if sqlite3_prepare_v2(db, queryStmtString, -1, &queryStmt, nil) == SQLITE_OK {
                
                while( sqlite3_step(queryStmt) == SQLITE_ROW ) {
                    
                    let id : Int = Int(sqlite3_column_int(queryStmt, 0))
                    let term : Int = Int(sqlite3_column_int(queryStmt,1))
                    let year : Int = Int(sqlite3_column_int(queryStmt,2))
                    let isCompleteInt : Int = Int(sqlite3_column_int(queryStmt,3))
                    let isComplete = (isCompleteInt == 0 ? false : true)
                    let grade : Float = Float(sqlite3_column_double(queryStmt, 4))
                    
                    sem = Semester(id: id, term: term, year: year, isComplete: isComplete, grade: grade)
                }
                sqlite3_finalize(queryStmt)
            } else{
                print("SELECT statement could not be prepared")
            }
            sqlite3_close(db)
        } else{
            print("Unable to open database.")
        }
        return sem
    }
    
    func getAllCourses() -> [Course]
    {
        var courses : [Course] = []
        var db: OpaquePointer? = nil
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath)")
            
            
            var queryStmt: OpaquePointer? = nil
            let queryStmtString : String = "select * from course"
            
            // step 7e - setup object that will handle data transfer
            if sqlite3_prepare_v2(db, queryStmtString, -1, &queryStmt, nil) == SQLITE_OK {
                
                // step 7f - loop through row by row to extract dat
                while( sqlite3_step(queryStmt) == SQLITE_ROW ) {
                    
                    let id : Int = Int(sqlite3_column_int(queryStmt,0))
                    let courseCode = String(cString: sqlite3_column_text(queryStmt,1))
                    let name = String(cString: sqlite3_column_text(queryStmt,2))
                    let isCompleteInt : Int = Int(sqlite3_column_int(queryStmt,3))
                    let isComplete = (isCompleteInt == 0 ? false : true)
                    let grade : Float = Float(sqlite3_column_double(queryStmt, 4))
                    let semId : Int = Int(sqlite3_column_int(queryStmt,5))
                    let credits : Float = Float(sqlite3_column_double(queryStmt, 6))
                    
                    //let semester = Semester(id: id, term: term, year: year, isComplete: isComplete, grade: grade)
                    let course = Course(id: id, semId: semId, name: name, code: courseCode, credits: credits, grade: grade, isComplete: isComplete)
                    courses.append(course)
                }
                sqlite3_finalize(queryStmt)
            } else{
                print("SELECT statement could not be prepared")
            }
            sqlite3_close(db)
        } else{
            print("Unable to open database.")
        }
        
        return courses
    }
    
    func getCourseList(semId: Int) -> [Course]
    {
        var courses : [Course] = []
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath)")
            
            var queryStmt: OpaquePointer? = nil
            var queryStmtString : String = "select * from course where semesterid = ?"
            
            if sqlite3_prepare_v2(db, queryStmtString, -1, &queryStmt, nil) == SQLITE_OK {
                
                sqlite3_bind_int(queryStmt, 1, Int32(semId))
                
                while( sqlite3_step(queryStmt) == SQLITE_ROW ) {
                    
                    let id : Int = Int(sqlite3_column_int(queryStmt,0))
                    let courseCode = String(cString: sqlite3_column_text(queryStmt,1))
                    let name = String(cString: sqlite3_column_text(queryStmt,2))
                    let isCompleteInt : Int = Int(sqlite3_column_int(queryStmt,3))
                    let isComplete = (isCompleteInt == 0 ? false : true)
                    let grade : Float = Float(sqlite3_column_double(queryStmt, 4))
                    let credits : Float = Float(sqlite3_column_double(queryStmt, 6))
                    
                    let course = Course(id: id, semId: semId, name: name, code: courseCode, credits: credits, grade: grade, isComplete: isComplete)
                    courses.append(course)
                    
                }
                sqlite3_finalize(queryStmt)
            } else{
                print("SELECT statement could not be prepared")
            }
            sqlite3_close(db)
        } else{
            print("Unable to open database.")
        }
        
        return courses
    }
    
    func getSingleCourse(id: Int) -> Course?
    {
        var course : Course? = nil
        var db : OpaquePointer? = nil
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath)")
            
            var queryStmt: OpaquePointer? = nil
            var queryStmtString : String = "select * from course where id = ?"
            
            if sqlite3_prepare_v2(db, queryStmtString, -1, &queryStmt, nil) == SQLITE_OK {
                
                sqlite3_bind_int(queryStmt, 1, Int32(id))
                
                while( sqlite3_step(queryStmt) == SQLITE_ROW ) {
                    
                    //let id : Int = Int(sqlite3_column_int(queryStmt,0))
                    let courseCode = String(cString: sqlite3_column_text(queryStmt,1))
                    let name = String(cString: sqlite3_column_text(queryStmt,2))
                    let isCompleteInt : Int = Int(sqlite3_column_int(queryStmt,3))
                    let isComplete : Bool = (isCompleteInt == 0 ? false : true)
                    let grade : Float = Float(sqlite3_column_double(queryStmt, 4))
                    let semId : Int = Int(sqlite3_column_int(queryStmt,5))
                    let credits : Float = Float(sqlite3_column_double(queryStmt, 6))
                    
                    course = Course(id: id, semId: semId, name: name, code: courseCode, credits: credits, grade: grade, isComplete: isComplete)
                    
                }
                sqlite3_finalize(queryStmt)
            } else{
                print("SELECT statement could not be prepared")
            }
            sqlite3_close(db)
        } else{
            print("Unable to open database.")
        }
        
        return course
    }
    
    func getAssessmentList(courseId: Int) -> [Assessment]
    {
        var assessments : [Assessment] = []
        var db : OpaquePointer? = nil
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath)")
            
            var queryStmt: OpaquePointer? = nil
            var queryStmtString : String = "select * from course where courseid = ?"
            
            if sqlite3_prepare_v2(db, queryStmtString, -1, &queryStmt, nil) == SQLITE_OK {
                
                sqlite3_bind_int(queryStmt, 1, Int32(courseId))
                
                while( sqlite3_step(queryStmt) == SQLITE_ROW ) {
                    
                    let id : Int = Int(sqlite3_column_int(queryStmt,0))
                    let name = String(cString: sqlite3_column_text(queryStmt,1))
                    
                    let dateDueString = String(cString: sqlite3_column_text(queryStmt,2))
                    let dateDue : Date = dateFormatter.date(from: dateDueString)!
                    
                    let dateSubmittedString = String(cString: sqlite3_column_text(queryStmt,3))
                    let dateSubmitted : Date = dateFormatter.date(from: dateSubmittedString)!
                    
                    let weight : Float = Float(sqlite3_column_double(queryStmt, 4))
                    
                    let isCompleteInt : Int = Int(sqlite3_column_int(queryStmt,5))
                    let isComplete = (isCompleteInt == 0 ? false : true)
                    
                    let isSubmittedInt : Int = Int(sqlite3_column_int(queryStmt,6))
                    let isSubmitted = (isSubmittedInt == 0 ? false : true)
                    
                    let willNotifyInt : Int = Int(sqlite3_column_int(queryStmt,7))
                    let willNotify = (willNotifyInt == 0 ? false : true)
                    
                    let notificationTime : Int = Int(sqlite3_column_int(queryStmt,8))
                    let grade : Float = Float(sqlite3_column_double(queryStmt, 9))
                    let category = String(cString: sqlite3_column_text(queryStmt,10))
                    let courseId : Int = Int(sqlite3_column_int(queryStmt,11))
                    
                    let assessment = Assessment(id: id, name: name, courseId: courseId, dateDue: dateDue, dateSubmitted: dateSubmitted, weight: weight, isComplete: isComplete, isSubmitted: isSubmitted, willNotify: willNotify, notificationTime: notificationTime, grade: grade, category: category)
                    
                    assessments.append(assessment)
                    
                }
                sqlite3_finalize(queryStmt)
            } else{
                print("SELECT statement could not be prepared")
            }
            sqlite3_close(db)
        } else{
            print("Unable to open database.")
        }
        
        
        return assessments
    }
    
    func getSingleAssessment(id: Int) -> Assessment?
    {
        var assessment : Assessment? = nil
        var db : OpaquePointer? = nil
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath)")
            
            var queryStmt: OpaquePointer? = nil
            let queryStmtString : String = "select * from course where id = ?"
            
            if sqlite3_prepare_v2(db, queryStmtString, -1, &queryStmt, nil) == SQLITE_OK {
                
                sqlite3_bind_int(queryStmt, 1, Int32(id))
                
                while( sqlite3_step(queryStmt) == SQLITE_ROW ) {
                    
                    let id : Int = Int(sqlite3_column_int(queryStmt,0))
                    let name = String(cString: sqlite3_column_text(queryStmt,1))
                    
                    let dateDueString = String(cString: sqlite3_column_text(queryStmt,2))
                    let dateDue : Date = dateFormatter.date(from: dateDueString)!
                    
                    let dateSubmittedString = String(cString: sqlite3_column_text(queryStmt,3))
                    let dateSubmitted : Date = dateFormatter.date(from: dateSubmittedString)!
                    
                    let weight : Float = Float(sqlite3_column_double(queryStmt, 4))
                    
                    let isCompleteInt : Int = Int(sqlite3_column_int(queryStmt,5))
                    let isComplete = (isCompleteInt == 0 ? false : true)
                    
                    let isSubmittedInt : Int = Int(sqlite3_column_int(queryStmt,6))
                    let isSubmitted = (isSubmittedInt == 0 ? false : true)
                    
                    let willNotifyInt : Int = Int(sqlite3_column_int(queryStmt,7))
                    let willNotify = (willNotifyInt == 0 ? false : true)
                    
                    let notificationTime : Int = Int(sqlite3_column_int(queryStmt,8))
                    let grade : Float = Float(sqlite3_column_double(queryStmt, 9))
                    let category = String(cString: sqlite3_column_text(queryStmt,10))
                    let courseId : Int = Int(sqlite3_column_int(queryStmt,11))
                    
                    assessment = Assessment(id: id, name: name, courseId: courseId, dateDue: dateDue, dateSubmitted: dateSubmitted, weight: weight, isComplete: isComplete, isSubmitted: isSubmitted, willNotify: willNotify, notificationTime: notificationTime, grade: grade, category: category)

                }
                sqlite3_finalize(queryStmt)
            } else{
                print("SELECT statement could not be prepared")
            }
            sqlite3_close(db)
        } else{
            print("Unable to open database.")
        }
        
        return assessment
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
