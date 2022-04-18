//
//  ViewController.swift
//  SchoolTracker
//
//  Created by Danil Andriuschenko on 24.03.2022.
//

import UIKit

class CourseListController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    //Search view controller
    lazy var searchController: UISearchController = {
       let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.automaticallyShowsCancelButton = true
        controller.hidesNavigationBarDuringPresentation = false
        return controller
    }()
    
    private var searchText: String = ""
    
    var courses: [Course] = []
    
    //Pass semester id for course list
    var currentSemesterID: Int = 0
    
    //Retruns courses to be displayed in list
    var displayedCourses: [Course]{
        get{
            return searchText.isEmpty ? courses.filter({$0.name.contains(searchText)}) : courses
        }
    }
    
    var editingCourse: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = .white
        
        //Set up large title for navigation controller
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "School Tracking"
        
        self.navigationItem.searchController = searchController
        
        
        self.courses = SchoolDB.shared.getAllCourses()
        
        //Setting up table view
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(ClassTableCell.self, forCellReuseIdentifier: "ClassTableCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
            
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCourse" || segue.identifier == "editCourse"{
            (segue.destination as? AddCourseController)?.delegate = self
        }
        
        if segue.identifier == "editCourse"{
            guard let addCourseController = segue.destination as? AddCourseController, let editingCourse = self.editingCourse else{
                return
            }
            
            addCourseController.course = editingCourse
            self.editingCourse = nil
            addCourseController.isCourseEditing = true
        }
    }
    

}

//Table view management
extension CourseListController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return courses.count
    }
 
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClassTableCell", for: indexPath) as? ClassTableCell else{
            return UITableViewCell()
        }
        cell.start(course: courses[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let course = (tableView.cellForRow(at: indexPath) as? ClassTableCell)?.course
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: { _,_,_ in
            
            self.editingCourse = course
            self.performSegue(withIdentifier: "editCourse", sender: nil)
            
        })
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { _, _, _ in
            
            
        })
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [editAction, deleteAction])
        return swipeConfiguration
    }
    
    


}

extension CourseListController: AddCourseDelegate{
    func willSaveCourse(course: Course, isEditing: Bool) {
        
        if isEditing{
            _ = SchoolDB.shared.editCourse(newCourse: course)
        }
        else{
            _ = SchoolDB.shared.addCourse(course: course)
            self.courses.append(course)
        }
        
        

        tableView.reloadData()
    }
    
    
}

extension CourseListController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text ?? ""
    }
}
