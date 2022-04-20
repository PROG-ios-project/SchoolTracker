//
//  SchoolDB.swift
//  SchoolTracker
//
//  Created by Thomas Forber on 4/15/22.
//
/*
 Custom class specifically for all SQLite3 database interactions since they would clutter up the AppDelegate if they were all put in there.
 */

import UIKit
import SQLite3

class SchoolDB
{
    static let shared = SchoolDB() //allows class to be a singleton so it doesn't need to be instantiated each time
    
    private var mainDelegate : AppDelegate // variable declaration for AppDelegate request object
    private var dateFormatter = DateFormatter() //DateFormatter variable used to format from Date object to text format stored in SQLite
    
    //initializer
    init(){
        mainDelegate = UIApplication.shared.delegate as! AppDelegate //instantiating the AppDelegate request object
        dateFormatter.dateFormat = "dd/MM/yy hh:mm a" //Setting the specific date format used in the database
    }
    
    //function to get list of all semesters from the database and return them in an array
    func getAllSemesters() -> [Semester]
    {
        var db: OpaquePointer? = nil //variable for the database
        var semesters : [Semester] = [] //storage array for each semesters, initialized as empty
        
        //If statements as learned in class to open database connection, create and send query, and handle the results
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            //statement pointer and query string variables
            var queryStmt: OpaquePointer? = nil
            let queryStmtString : String = "select * from semester"
            
            if sqlite3_prepare_v2(db, queryStmtString, -1, &queryStmt, nil) == SQLITE_OK {
                
                while( sqlite3_step(queryStmt) == SQLITE_ROW ) {
                    
                    //declaration block to turn the results from the query into proper data types and formats for a semester object, include converting from integer to boolean
                    let id : Int = Int(sqlite3_column_int(queryStmt,0))
                    let term : Int = Int(sqlite3_column_int(queryStmt,1))
                    let year : Int = Int(sqlite3_column_int(queryStmt,2))
                    let isCompleteInt : Int = Int(sqlite3_column_int(queryStmt,3))
                    let isComplete = (isCompleteInt == 0 ? false : true)
                    let grade : Float = Float(sqlite3_column_double(queryStmt, 4))
                    
                    //creates new semester object from query row results and adds it to the array
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
    
    //Function to get a single semester if it's ever needed
    func getOneSemester(id: Int) -> Semester?
    {
        //similar to AllSemesters, but single semester object instead of array
        var sem : Semester? = nil
        var db : OpaquePointer? = nil
        
        //database if statements
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            //query pointer and string that includes a parameter to be added
            var queryStmt: OpaquePointer? = nil
            let queryStmtString : String = "select * from semester where id = ?"
            
            if sqlite3_prepare_v2(db, queryStmtString, -1, &queryStmt, nil) == SQLITE_OK {
                
                //binding variable to parameter in query statement string
                sqlite3_bind_int(queryStmt, 1, Int32(id))
                
                while( sqlite3_step(queryStmt) == SQLITE_ROW ) {
                    
                    //declaration block to convert results into proper data types and formats for semester object
                    let term : Int = Int(sqlite3_column_int(queryStmt,1))
                    let year : Int = Int(sqlite3_column_int(queryStmt,2))
                    let isCompleteInt : Int = Int(sqlite3_column_int(queryStmt,3))
                    let isComplete = (isCompleteInt == 0 ? false : true)
                    let grade : Float = Float(sqlite3_column_double(queryStmt, 4))
                    
                    //assigning the returned values to semester object
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
    
    //Function to get most recent semester if it's ever needed. Same layout as single semester, just with no query parameterization or id passed in
    func getCurrentSemester() -> Semester?
    {
        
        var sem : Semester? = nil
        var db : OpaquePointer? = nil
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            //query string gets all semesters, ordered by descending ID and limiting it to 1 so it only gets the most recently added
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
    
    //Function to get all courses, similar to getAllSemesters, just returns Course array, selects from course table, and converts the results into the proper format and data types for course object
    func getAllCourses() -> [Course]
    {
        var courses : [Course] = []
        var db: OpaquePointer? = nil
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            
            var queryStmt: OpaquePointer? = nil
            let queryStmtString : String = "select * from course"
            
            
            if sqlite3_prepare_v2(db, queryStmtString, -1, &queryStmt, nil) == SQLITE_OK {
                
                
                while( sqlite3_step(queryStmt) == SQLITE_ROW ) {
                    
                    //declaration block to convert results into proper data types and formats for course object
                    let id : Int = Int(sqlite3_column_int(queryStmt,0))
                    let courseCode = String(cString: sqlite3_column_text(queryStmt,1))
                    let name = String(cString: sqlite3_column_text(queryStmt,2))
                    let isCompleteInt : Int = Int(sqlite3_column_int(queryStmt,3))
                    let isComplete = (isCompleteInt == 0 ? false : true)
                    let grade : Float = Float(sqlite3_column_double(queryStmt, 4))
                    let semId : Int = Int(sqlite3_column_int(queryStmt,5))
                    let credits : Float = Float(sqlite3_column_double(queryStmt, 6))
                    
                    //creates course object from results and adds to array
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
    
    //Function to get the course list of a single semester. Similar to getAllCourses, but query has parameter for the semester id which is a foreign key to semester table in the course table
    func getCourseList(semId: Int) -> [Course]
    {
        var courses : [Course] = []
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            //query string parameterized for foreign key semesterid, taken from semId passed through
            var queryStmt: OpaquePointer? = nil
            let queryStmtString : String = "select * from course where semesterid = ?"
            
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
    
    //Function to get a single course. Similar to getting single semester, just uses course object, table, and data types and format.
    func getSingleCourse(id: Int) -> Course?
    {
        var course : Course? = nil
        var db : OpaquePointer? = nil
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            var queryStmt: OpaquePointer? = nil
            let queryStmtString : String = "select * from course where id = ?"
            
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
    
    //Function to get list of assessments for a specific course. Similar to getCourseList, but uses Assessment object, table, and data types and format
    func getAssessmentList(courseId: Int) -> [Assessment]
    {
        
        var assessments : [Assessment] = []
        var db : OpaquePointer? = nil
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            //query string parameterized for courseid, which is a foreign key in assessment table that connects to id in course table.
            var queryStmt: OpaquePointer? = nil
            let queryStmtString : String = "select * from assessment where courseid = ?"
            
            if sqlite3_prepare_v2(db, queryStmtString, -1, &queryStmt, nil) == SQLITE_OK {
                
                //binding parameter in query string
                sqlite3_bind_int(queryStmt, 1, Int32(courseId))
                
                while( sqlite3_step(queryStmt) == SQLITE_ROW ) {
                    
                    
                    //declaration block for coverting results to proper data types and formats for assessment object
                    let id : Int = Int(sqlite3_column_int(queryStmt,0))
                    let name = String(cString: sqlite3_column_text(queryStmt,1))
                    
                    let dateDueString = String(cString: sqlite3_column_text(queryStmt,2))
                    let dateDue : Date = dateFormatter.date(from: dateDueString)!
                    
                    //dateSubmitted column can be null, so if it is, keep variable as nil, otherwise convert the date
                    var dateSubmitted : Date? = nil
                    if sqlite3_column_type(queryStmt, 3) != SQLITE_NULL {
                        let dateSubmittedString = String(cString: sqlite3_column_text(queryStmt,3))
                        dateSubmitted = dateFormatter.date(from: dateSubmittedString)
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
                    
                    //creating assessment object from results and adding it to array
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
    
    //Function to get a single assessment in case it is needed. Similar to getAssessmentList but passes in an assessment id, not course id, and only returns 1 object, not an array
    func getSingleAssessment(id: Int) -> Assessment?
    {
        var assessment : Assessment? = nil
        var db : OpaquePointer? = nil
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
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
    
    //Function to insert a semester into the database
    func addSemester(semester: Semester)
    {
        var db : OpaquePointer? = nil
        
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            //insert pointer and string with parameters for semester values
            var insertStmt: OpaquePointer? = nil
            let insertStmtString : String = "insert into semester values(NULL, ?, ?, ?, ?)"
            
            
            if sqlite3_prepare_v2(db, insertStmtString, -1, &insertStmt, nil) == SQLITE_OK {
                
                //binding variables to parameters in the insert statement before running command
                sqlite3_bind_int(insertStmt, 1, Int32(semester.term))
                sqlite3_bind_int(insertStmt, 2, Int32(semester.year))
                let boolInt : Int32 = semester.isComplete ? 1 : 0
                sqlite3_bind_int(insertStmt, 3, boolInt)
                sqlite3_bind_double(insertStmt, 4, Double(semester.grade))
                
                //runs insert statement, gets whether it was successful or not and returns rowid to console if it was
                if sqlite3_step(insertStmt) == SQLITE_DONE {
                    
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted record into row \(rowId)")
                    
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
        
        
    }
    
    //Function to insert a course into the database. Similar to addSemester but it uses course object, table, and data types
    func addCourse(course: Course)
    {
        var db : OpaquePointer? = nil
        
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            //insert statement and string with parameters for course
            var insertStmt: OpaquePointer? = nil
            let insertStmtString : String = "insert into course values(NULL, ?, ?, ?, ?, ?, ?)"
            
            // step 16e - setup object that will handle data transfer
            if sqlite3_prepare_v2(db, insertStmtString, -1, &insertStmt, nil) == SQLITE_OK {
                
                //data type conversion and binding of variables to parameters
                let codeStr = course.code as NSString
                sqlite3_bind_text(insertStmt, 1, codeStr.utf8String, -1, nil)
                
                let nameStr = course.name as NSString
                sqlite3_bind_text(insertStmt, 2, nameStr.utf8String, -1, nil)
                
                let boolInt : Int32 = course.isComplete ? 1 : 0
                sqlite3_bind_int(insertStmt, 3, boolInt)
                
                sqlite3_bind_double(insertStmt, 4, Double(course.grade))
                sqlite3_bind_int(insertStmt, 5, Int32(course.semId))
                sqlite3_bind_double(insertStmt, 6, Double(course.credits))
                
                //runs insert statement and gets result and rowid, if successful
                if sqlite3_step(insertStmt) == SQLITE_DONE {
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted record into row \(rowId)")
                    
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
    }
    
    //Function to insert an assessment into the table. Similar to other add functions, just with assessment object, table, and data types
    func addAssessment(assessment: Assessment)
    {
        var db : OpaquePointer? = nil
        
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            //insert statement and string with parameters for assessment table
            var insertStmt: OpaquePointer? = nil
            let insertStmtString : String = "insert into assessment values(NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
            
            
            if sqlite3_prepare_v2(db, insertStmtString, -1, &insertStmt, nil) == SQLITE_OK {
                
                //data type conversion and binding variables to parameters
                let nameStr = assessment.name as NSString
                sqlite3_bind_text(insertStmt, 1, nameStr.utf8String, -1, nil)
                
                let dateDueStr = dateFormatter.string(from: assessment.dateDue) as NSString
                sqlite3_bind_text(insertStmt, 2, dateDueStr.utf8String, -1, nil)
                
                //nil values need to be bound differently so this if statement is to check if dateSubmitted is nil and bind according to the result
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
                
                //runs the statement and gets the result
                if sqlite3_step(insertStmt) == SQLITE_DONE {
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("Successfully inserted record into row \(rowId)")
                    
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
        
        
    }
    
    //Function to update semester records when edited
    func editSemester(newSem: Semester)
    {
        var db : OpaquePointer? = nil
        
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            //update statement and string with parameters for all editable fields and id
            var updateStmt: OpaquePointer? = nil
            let updateStmtString : String = "update semester set term = ?, year = ?, iscomplete = ?, grade = ? where id = ?"
            
            
            if sqlite3_prepare_v2(db, updateStmtString, -1, &updateStmt, nil) == SQLITE_OK {
                
                //binding variables to parameters
                sqlite3_bind_int(updateStmt, 1, Int32(newSem.term))
                sqlite3_bind_int(updateStmt, 2, Int32(newSem.year))
                let boolInt : Int32 = newSem.isComplete ? 1 : 0
                sqlite3_bind_int(updateStmt, 3, boolInt)
                sqlite3_bind_double(updateStmt, 4, Double(newSem.grade))
                sqlite3_bind_int(updateStmt, 5, Int32(newSem.id))
                
                //runs statement and gets result
                if sqlite3_step(updateStmt) == SQLITE_DONE {
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("Successfully updated record in row \(rowId)")
                    
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
        
        
    }
    
    //Function to update a course record. Similar to editSemester, but for course object, table, and data types
    func editCourse(newCourse: Course)
    {
        var db : OpaquePointer? = nil
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            //update statement and string with parameters for all editable fields in course, and id
            var updateStmt: OpaquePointer? = nil
            let updateStmtString : String = "update course set coursecode = ?, name = ?, iscomplete = ?, grade = ?, credits = ? where id = ?"
            
            
            if sqlite3_prepare_v2(db, updateStmtString, -1, &updateStmt, nil) == SQLITE_OK {
                
                //data type conversions and binding to parameters
                let codeStr = newCourse.code as NSString
                sqlite3_bind_text(updateStmt, 1, codeStr.utf8String, -1, nil)
                
                let nameStr = newCourse.name as NSString
                sqlite3_bind_text(updateStmt, 2, nameStr.utf8String, -1, nil)
                
                let boolInt : Int32 = newCourse.isComplete ? 1 : 0
                sqlite3_bind_int(updateStmt, 3, boolInt)
                
                sqlite3_bind_double(updateStmt, 4, Double(newCourse.grade))
                sqlite3_bind_double(updateStmt, 5, Double(newCourse.credits))
                sqlite3_bind_int(updateStmt, 6, Int32(newCourse.id))
                
                //runs statement and gets result
                if sqlite3_step(updateStmt) == SQLITE_DONE {
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("Successfully updated record in row \(rowId)")
                    
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
        
      
    }
    
    //Function to update assessment record in database. Similar to other edit functions, but using assessment object, table, and data types
    func editAssessment(newAssess: Assessment)
    {
        var db : OpaquePointer? = nil
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            //update statement and string with parameters for all editable fields in assessment, and id
            var updateStmt: OpaquePointer? = nil
            let updateStmtString : String = "update assessment set name = ?, datedue = ?, datesubmitted = ?, weight = ?, iscomplete = ?, issubmitted =?, willnotify = ?, notificationtime = ?, grade = ?, category = ? where id = ?"
            
            
            if sqlite3_prepare_v2(db, updateStmtString, -1, &updateStmt, nil) == SQLITE_OK {
                
                //data type conversion and binding for parameters
                let nameStr = newAssess.name as NSString
                sqlite3_bind_text(updateStmt, 1, nameStr.utf8String, -1, nil)
                
                let dateDueStr = dateFormatter.string(from: newAssess.dateDue) as NSString
                sqlite3_bind_text(updateStmt, 2, dateDueStr.utf8String, -1, nil)
                
                //checking whether dateSubmitted is nil and using the proper binding
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
                
                //runs the statement and returns the result
                if sqlite3_step(updateStmt) == SQLITE_DONE {
                    let rowId = sqlite3_last_insert_rowid(db)
                    print("Successfully updated record in row \(rowId)")
                    
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
        
        
    }
    
    //Function to delete a semester from a table. Has built in foreign key constraints where it will find all courses associated with the semester, delete all assessments associated with each course, then delete those courses before deleting the semester itself
    func deleteSemester(id: Int)
    {
        var db : OpaquePointer? = nil
        
        //course list of the semester to be deleted
        var courses : [Course] = []
        courses = getCourseList(semId: id)
        if courses.count > 0{
            //for loop to go through each course associated with the semester and delete it
            for course in courses{
                deleteCourse(id: course.id)
            }
        }
        
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            //delete statement and string with parameter for id of semester to be deleted
            var deleteStmt: OpaquePointer? = nil
            let deleteStmtString : String = "delete from semester where id = ?"
            
            
            if sqlite3_prepare_v2(db, deleteStmtString, -1, &deleteStmt, nil) == SQLITE_OK {
                
                //binding id to parameter
                sqlite3_bind_int(deleteStmt, 1, Int32(id))
                
                //runs the statement and returns the result
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
    
    //Function to delete a course from the course table in the database. Has built in foreign key constraint where it deletes all associated assessments before deleting the course
    func deleteCourse(id: Int)
    {
        var db : OpaquePointer? = nil
        //deletes associated assessments to maintain foreign key constraints
        deleteAssessmentsForCourse(courseId: id)
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            //delete statement and string with parameter for id of course to be deleted
            var deleteStmt: OpaquePointer? = nil
            let deleteStmtString : String = "delete from course where id = ?"
            
            
            if sqlite3_prepare_v2(db, deleteStmtString, -1, &deleteStmt, nil) == SQLITE_OK {
                
                //binding id to parameter
                sqlite3_bind_int(deleteStmt, 1, Int32(id))
                
                //runs statement and returns result
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
    
    //Function to delete a single assessment from assessment table in database
    func deleteAssessment(id: Int)
    {
        var db : OpaquePointer? = nil
        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            //delete statement and string with parameter for id of assessment to delete
            var deleteStmt: OpaquePointer? = nil
            let deleteStmtString : String = "delete from assessment where id = ?"
            
            
            if sqlite3_prepare_v2(db, deleteStmtString, -1, &deleteStmt, nil) == SQLITE_OK {
                
                //bind id to parameter
                sqlite3_bind_int(deleteStmt, 1, Int32(id))
                
                //runs statement and returns result
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
    
    //Function to delete all assessments associated with a specific course
    func deleteAssessmentsForCourse(courseId: Int)
    {
        var db : OpaquePointer? = nil

        
        if sqlite3_open(mainDelegate.databasePath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(mainDelegate.databasePath!)")
            
            //delete statement and string with parameter for foreign key courseid of all the assessments to be deleted
            var deleteStmt: OpaquePointer? = nil
            let deleteStmtString : String = "delete from assessment where courseid = ?"
            
            
            if sqlite3_prepare_v2(db, deleteStmtString, -1, &deleteStmt, nil) == SQLITE_OK {
                
                //binding courseId to parameter
                sqlite3_bind_int(deleteStmt, 1, Int32(courseId))
                
                //runs statement and returns result
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
