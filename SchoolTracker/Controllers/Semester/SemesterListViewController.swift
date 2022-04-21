//
//  SemesterListViewController.swift
//  SchoolTracker
//
//  Created by Danylo Andriushchenko on 4/12/22.
//  Controller that shows semester list

import UIKit

class SemesterListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var semesters: [Semester] = []
    var selectedSemester: Semester?
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        tableView.delegate = self
        tableView.dataSource = self
        
        semesters = SchoolDB.shared.getAllSemesters()
        
        tableView.register(SemesterTableCell.self, forCellReuseIdentifier: "semesterCell")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        semesters = SchoolDB.shared.getAllSemesters()
        tableView.reloadData()
    }
 
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "courseList"{
            (segue.destination as? CourseListController)?.currentSemesterID = selectedSemester!.id
        }
        if segue.identifier == "addSemester"{
            (segue.destination as? AddSemesterController)?.delegate = self
        }
    }

}
extension SemesterListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "semesterCell", for: indexPath) as! SemesterTableCell
        cell.start(semester: semesters[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return semesters.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSemester = semesters[indexPath.row]
        self.performSegue(withIdentifier: "courseList", sender: nil)
    }
}

//Will save semester to the list
extension SemesterListViewController: SemesterAddDelegate
{
    func willSaveSemester(semester: Semester) {
        SchoolDB.shared.addSemester(semester: semester)
        
        semesters = SchoolDB.shared.getAllSemesters()
        self.tableView.reloadData()
    }
    
    
}
