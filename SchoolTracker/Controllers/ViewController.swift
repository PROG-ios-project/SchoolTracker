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
    
    var courses: [Course] = []
    
    var displayedCourses: [Course] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        //Set up large title for navigation controller
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "School Tracking"
        
        self.navigationItem.searchController = searchController
        
        for i in 0...5{
            var newCourse = Course()
            newCourse.name = "Example \(i)"
            courses.append(newCourse)
        }
        
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

    

}


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


extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}
