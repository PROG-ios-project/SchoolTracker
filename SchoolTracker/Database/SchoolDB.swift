//
//  SchoolDB.swift
//  SchoolTracker
//
//  Created by Thomas Forber on 4/15/22.
//

import UIKit
import SQLite3

class SchoolDB
{
    static let shared = SchoolDB()
    
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
        print(courses.count)
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
            var queryStmtString : String = "select * from assessment where courseid = ?"
            
            if sqlite3_prepare_v2(db, queryStmtString, -1, &queryStmt, nil) == SQLITE_OK {
                
                sqlite3_bind_int(queryStmt, 1, Int32(courseId))
                
                while( sqlite3_step(queryStmt) == SQLITE_ROW ) {
                    
                    let id : Int = Int(sqlite3_column_int(queryStmt,0))
                    let name = String(cString: sqlite3_column_text(queryStmt,1))
                    
                    let dateDueString = String(cString: sqlite3_column_text(queryStmt,2))
                    let dateDue : Date = dateFormatter.date(from: dateDueString)!
                    
                    var dateSubmitted : Date? = nil
                    if sqlite3_column_type(queryStmt, 3) != SQLITE_NULL {
                        let dateSubmittedString = String(cString: sqlite3_column_text(queryStmt,3))
                        dateSubmitted = dateFormatter.date(from: dateSubmittedString)!
                    }
                    
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
                    
                    var dateSubmitted : Date? = nil
                    if sqlite3_column_type(queryStmt, 3) != SQLITE_NULL {
                        let dateSubmittedString = String(cString: sqlite3_column_text(queryStmt,3))
                        dateSubmitted = dateFormatter.date(from: dateSubmittedString)!
                    }
                    
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
        var db : OpaquePointer? = nil
        var returnCode : Bool = false
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath)")
            
            // step 16d - setup query - entries is the table name you created in step 0
            var insertStmt: OpaquePointer? = nil
            var insertStmtString : String = "insert into semester values(NULL, ?, ?, ?, ?)"
            
            // step 16e - setup object that will handle data transfer
            if sqlite3_prepare_v2(db, insertStmtString, -1, &insertStmt, nil) == SQLITE_OK {
                sqlite3_bind_int(insertStmt, 1, Int32(semester.term))
                sqlite3_bind_int(insertStmt, 2, Int32(semester.year))
                let boolInt : Int32 = semester.isComplete ? 1 : 0
                sqlite3_bind_int(insertStmt, 3, boolInt)
                sqlite3_bind_double(insertStmt, 4, Double(semester.grade))
                
                if sqlite3_step(insertStmt) == SQLITE_DONE {
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted record into row \(rowId)")
                    returnCode = true
                } else {
                    print("Could not insert record.")
                }
                sqlite3_finalize(insertStmt)
            } else {
                print("INSERT statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database.")
        }
        
        return returnCode
    }
    
    func addCourse(course: Course) -> Bool
    {
        var db : OpaquePointer? = nil
        var returnCode : Bool = false
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath)")
            
            // step 16d - setup query - entries is the table name you created in step 0
            var insertStmt: OpaquePointer? = nil
            var insertStmtString : String = "insert into course values(NULL, ?, ?, ?, ?, ?, ?)"
            
            // step 16e - setup object that will handle data transfer
            if sqlite3_prepare_v2(db, insertStmtString, -1, &insertStmt, nil) == SQLITE_OK {
                
                let codeStr = course.code as NSString
                sqlite3_bind_text(insertStmt, 1, codeStr.utf8String, -1, nil)
                
                let nameStr = course.name as NSString
                sqlite3_bind_text(insertStmt, 2, nameStr.utf8String, -1, nil)
                
                let boolInt : Int32 = course.isComplete ? 1 : 0
                sqlite3_bind_int(insertStmt, 3, boolInt)
                
                sqlite3_bind_double(insertStmt, 4, Double(course.grade))
                sqlite3_bind_int(insertStmt, 5, Int32(course.semId))
                sqlite3_bind_double(insertStmt, 6, Double(course.credits))
                
                if sqlite3_step(insertStmt) == SQLITE_DONE {
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted record into row \(rowId)")
                    returnCode = true
                } else {
                    print("Could not insert record.")
                }
                sqlite3_finalize(insertStmt)
            } else {
                print("INSERT statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database.")
        }
        
        return returnCode
        
    }
    
    func addAssessment(assessment: Assessment) -> Bool
    {
        var db : OpaquePointer? = nil
        var returnCode : Bool = false
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath)")
            
            // step 16d - setup query - entries is the table name you created in step 0
            var insertStmt: OpaquePointer? = nil
            var insertStmtString : String = "insert into assessment values(NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
            
            // step 16e - setup object that will handle data transfer
            if sqlite3_prepare_v2(db, insertStmtString, -1, &insertStmt, nil) == SQLITE_OK {
                
                
                let nameStr = assessment.name as NSString
                sqlite3_bind_text(insertStmt, 1, nameStr.utf8String, -1, nil)
                
                let dateDueStr = dateFormatter.string(from: assessment.dateDue) as NSString
                sqlite3_bind_text(insertStmt, 2, dateDueStr.utf8String, -1, nil)
                
                
                if assessment.dateSubmitted == nil {
                    sqlite3_bind_null(insertStmt, 3)
                } else {
                    let dateSubmittedStr = dateFormatter.string(from: assessment.dateSubmitted!) as NSString
                    sqlite3_bind_text(insertStmt, 3, dateSubmittedStr.utf8String, -1, nil)
                }
                
                sqlite3_bind_double(insertStmt, 4, Double(assessment.weight))
                
                let completeInt : Int32 = assessment.isComplete ? 1 : 0
                sqlite3_bind_int(insertStmt, 5, completeInt)
                
                let submitInt : Int32 = assessment.isSubmitted ? 1 : 0
                sqlite3_bind_int(insertStmt, 6, submitInt)
                
                let willNotifyInt : Int32 = assessment.willNotify ? 1 : 0
                sqlite3_bind_int(insertStmt, 7, willNotifyInt)
                
                sqlite3_bind_int(insertStmt, 8, Int32(assessment.notificationTime))
                sqlite3_bind_double(insertStmt, 9, Double(assessment.grade))
                
                let categoryStr = assessment.category as NSString
                sqlite3_bind_text(insertStmt, 10, categoryStr.utf8String, -1, nil)
                
                sqlite3_bind_int(insertStmt, 11, Int32(assessment.courseId))
                
                if sqlite3_step(insertStmt) == SQLITE_DONE {
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted record into row \(rowId)")
                    returnCode = true
                } else {
                    print("Could not insert record.")
                }
                sqlite3_finalize(insertStmt)
            } else {
                print("INSERT statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database.")
        }
        
        return returnCode
    }
    
    func editSemester(newSem: Semester) -> Bool
    {
        var db : OpaquePointer? = nil
        var returnCode : Bool = false
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            // step 16d - setup query - entries is the table name you created in step 0
            var updateStmt: OpaquePointer? = nil
            let updateStmtString : String = "update semester set term = ?, year = ?, iscomplete = ?, grade = ? where id = ?"
            
            // step 16e - setup object that will handle data transfer
            if sqlite3_prepare_v2(db, updateStmtString, -1, &updateStmt, nil) == SQLITE_OK {
                
                sqlite3_bind_int(updateStmt, 1, Int32(newSem.term))
                sqlite3_bind_int(updateStmt, 2, Int32(newSem.year))
                let boolInt : Int32 = newSem.isComplete ? 1 : 0
                sqlite3_bind_int(updateStmt, 3, boolInt)
                sqlite3_bind_double(updateStmt, 4, Double(newSem.grade))
                sqlite3_bind_int(updateStmt, 5, Int32(newSem.id))
                
                if sqlite3_step(updateStmt) == SQLITE_DONE {
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("Successfully updated record in row \(rowId)")
                    returnCode = true
                } else {
                    print("Could not update record.")
                }
                sqlite3_finalize(updateStmt)
            } else {
                print("UPDATE statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database.")
        }
        
        return returnCode
    }
    
    func editCourse(newCourse: Course) -> Bool
    {
        var db : OpaquePointer? = nil
        var returnCode : Bool = false
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            // step 16d - setup query - entries is the table name you created in step 0
            var updateStmt: OpaquePointer? = nil
            let updateStmtString : String = "update course set coursecode = ?, name = ?, iscomplete = ?, grade = ?, credits = ? where id = ?"
            
            // step 16e - setup object that will handle data transfer
            if sqlite3_prepare_v2(db, updateStmtString, -1, &updateStmt, nil) == SQLITE_OK {
                
                let codeStr = newCourse.code as NSString
                sqlite3_bind_text(updateStmt, 1, codeStr.utf8String, -1, nil)
                
                let nameStr = newCourse.name as NSString
                sqlite3_bind_text(updateStmt, 2, nameStr.utf8String, -1, nil)
                
                let boolInt : Int32 = newCourse.isComplete ? 1 : 0
                sqlite3_bind_int(updateStmt, 3, boolInt)
                
                sqlite3_bind_double(updateStmt, 4, Double(newCourse.grade))
                sqlite3_bind_double(updateStmt, 5, Double(newCourse.credits))
                sqlite3_bind_int(updateStmt, 6, Int32(newCourse.id))
                
                if sqlite3_step(updateStmt) == SQLITE_DONE {
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("Successfully updated record in row \(rowId)")
                    returnCode = true
                } else {
                    print("Could not update record.")
                }
                sqlite3_finalize(updateStmt)
            } else {
                print("UPDATE statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database.")
        }
        
        return returnCode
    }
    
    func editAssessment(newAssess: Assessment) -> Bool
    {
        var db : OpaquePointer? = nil
        var returnCode : Bool = false
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            // step 16d - setup query - entries is the table name you created in step 0
            var updateStmt: OpaquePointer? = nil
            let updateStmtString : String = "update assessment set name = ?, datedue = ?, datesubmitted = ?, weight = ?, iscomplete = ?, issubmitted =?, willnotify = ?, notificationtime = ?, grade = ?, category = ? where id = ?"
            
            // step 16e - setup object that will handle data transfer
            if sqlite3_prepare_v2(db, updateStmtString, -1, &updateStmt, nil) == SQLITE_OK {
                
                let nameStr = newAssess.name as NSString
                sqlite3_bind_text(updateStmt, 1, nameStr.utf8String, -1, nil)
                
                let dateDueStr = dateFormatter.string(from: newAssess.dateDue) as NSString
                sqlite3_bind_text(updateStmt, 2, dateDueStr.utf8String, -1, nil)
                
                if newAssess.dateSubmitted == nil {
                    sqlite3_bind_null(updateStmt, 3)
                } else {
                    let dateSubmittedStr = dateFormatter.string(from: newAssess.dateSubmitted!) as NSString
                    sqlite3_bind_text(updateStmt, 3, dateSubmittedStr.utf8String, -1, nil)
                }
                
                sqlite3_bind_double(updateStmt, 4, Double(newAssess.weight))
                
                let completeInt : Int32 = newAssess.isComplete ? 1 : 0
                sqlite3_bind_int(updateStmt, 5, completeInt)
                
                let submitInt : Int32 = newAssess.isSubmitted ? 1 : 0
                sqlite3_bind_int(updateStmt, 6, submitInt)
                
                let willNotifyInt : Int32 = newAssess.willNotify ? 1 : 0
                sqlite3_bind_int(updateStmt, 7, willNotifyInt)
                
                sqlite3_bind_int(updateStmt, 8, Int32(newAssess.notificationTime))
                sqlite3_bind_double(updateStmt, 9, Double(newAssess.grade))
                
                let categoryStr = newAssess.category as NSString
                sqlite3_bind_text(updateStmt, 10, categoryStr.utf8String, -1, nil)
                
                sqlite3_bind_int(updateStmt, 11, Int32(newAssess.id))
                
                if sqlite3_step(updateStmt) == SQLITE_DONE {
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("Successfully updated record in row \(rowId)")
                    returnCode = true
                } else {
                    print("Could not update record.")
                }
                sqlite3_finalize(updateStmt)
            } else {
                print("UPDATE statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database.")
        }
        
        return returnCode
    }
    
    func deleteSemester(id: Int)
    {
        var db : OpaquePointer? = nil
        
        var courses : [Course] = []
        
        courses = getCourseList(semId: id)
        if courses.count > 0{
            for course in courses{
                deleteAssessmentsForCourse(courseId: course.id)
            }
        }
        
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            // step 16d - setup query - entries is the table name you created in step 0
            var deleteStmt: OpaquePointer? = nil
            let deleteStmtString : String = "delete from semester where id = ?"
            
            // step 16e - setup object that will handle data transfer
            if sqlite3_prepare_v2(db, deleteStmtString, -1, &deleteStmt, nil) == SQLITE_OK {
                
                sqlite3_bind_int(deleteStmt, 1, Int32(id))
                
                if sqlite3_step(deleteStmt) == SQLITE_DONE {
                    
                    print("Successfully deleted record.")
                    
                } else {
                    print("Could not delete record.")
                }
                sqlite3_finalize(deleteStmt)
            } else {
                print("DELETE statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database.")
        }
        
        
    }
    
    func deleteCourse(id: Int)
    {
        var db : OpaquePointer? = nil
        deleteAssessmentsForCourse(courseId: id)
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            
            
            // step 16d - setup query - entries is the table name you created in step 0
            var deleteStmt: OpaquePointer? = nil
            let deleteStmtString : String = "delete from course where id = ?"
            
            // step 16e - setup object that will handle data transfer
            if sqlite3_prepare_v2(db, deleteStmtString, -1, &deleteStmt, nil) == SQLITE_OK {
                
                sqlite3_bind_int(deleteStmt, 1, Int32(id))
                
                if sqlite3_step(deleteStmt) == SQLITE_DONE {
                    
                    print("Successfully deleted record.")
                    
                } else {
                    print("Could not delete record.")
                }
                sqlite3_finalize(deleteStmt)
            } else {
                print("DELETE statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database.")
        }
        
        
    }
    
    func deleteAssessment(id: Int)
    {
        var db : OpaquePointer? = nil
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            // step 16d - setup query - entries is the table name you created in step 0
            var deleteStmt: OpaquePointer? = nil
            let deleteStmtString : String = "delete from assessment where id = ?"
            
            // step 16e - setup object that will handle data transfer
            if sqlite3_prepare_v2(db, deleteStmtString, -1, &deleteStmt, nil) == SQLITE_OK {
                
                sqlite3_bind_int(deleteStmt, 1, Int32(id))
                
                if sqlite3_step(deleteStmt) == SQLITE_DONE {
                    
                    print("Successfully deleted record.")
                } else {
                    print("Could not delete record.")
                }
                sqlite3_finalize(deleteStmt)
            } else {
                print("DELETE statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database.")
        }
        
        
    }
    
    func deleteAssessmentsForCourse(courseId: Int)
    {
        var db : OpaquePointer? = nil

        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            // step 16d - setup query - entries is the table name you created in step 0
            var deleteStmt: OpaquePointer? = nil
            let deleteStmtString : String = "delete from assessment where courseid = ?"
            
            // step 16e - setup object that will handle data transfer
            if sqlite3_prepare_v2(db, deleteStmtString, -1, &deleteStmt, nil) == SQLITE_OK {
                
                sqlite3_bind_int(deleteStmt, 1, Int32(courseId))
                
                if sqlite3_step(deleteStmt) == SQLITE_DONE {
                    
                    print("Successfully deleted record(s).")
                    
                } else {
                    print("Could not delete record(s).")
                }
                sqlite3_finalize(deleteStmt)
            } else {
                print("DELETE statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database.")
        }
    }
    
}
