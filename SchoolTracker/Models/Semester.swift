//
//  Semester.swift
//  SchoolTracker
//
//  Created by Penric on 4/15/22.
//

import Foundation

class Semester {
    var id : Int? = nil
    var term : Int = 0
    var year : Int = -1
    var isComplete : Bool = false
    var grade : Float = 0.0
    
    init(){
        
    }
    
    init(term: Int, year: Int){
        self.term = term
        self.year = year
    }
    
    init(id: Int?, term: Int, year: Int, isComplete: Bool, grade: Float){
        self.id = id
        self.term = term
        self.year = year
        self.isComplete = isComplete
        self.grade = grade
    }
}
