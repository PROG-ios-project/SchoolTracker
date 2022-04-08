//
//  ViewController.swift
//  SchoolTracker
//
//  Created by Danil Andriuschenko on 24.03.2022.
//

import UIKit

class ViewController: UIViewController {

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
    
    //Retruns courses to be displayed in list
    var displayedCourses: [Course]{
        get{
            return searchText.isEmpty ? courses.filter({$0.name.contains(searchText)}) : courses
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = .white
        
        //Set up large title for navigation controller
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "School Tracking"
        
        self.navigationItem.searchController = searchController
        
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
            
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCourse"{
            (segue.destination as? AddCourseController)?.delegate = self
        }
    }
    

}

//Table view management
extension ViewController: UITableViewDelegate, UITableViewDataSource{
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
    
    


}

extension ViewController: AddCourseDelegate{
    func willSaveCourse(course: Course) {
        self.courses.append(course)
        tableView.reloadData()
    }
    
    
}

extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text ?? ""
    }
}
