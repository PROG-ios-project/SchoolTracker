//
//  CourseInfoViewController.swift
//  SchoolTracker
//
//  Created by Danylo Andriushchenko on 4/18/22.
//  Controller that shows detailed info about the course. Displays assessment list related to the course

import UIKit

class CourseInfoViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    
    var course: Course!
    var assessments: [Assessment] = []
    
    var selectedAssessment: Assessment?
    override func viewDidLoad() {
        super.viewDidLoad()

        assessments = SchoolDB.shared.getAssessmentList(courseId: course.id)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = true
        tableView.separatorStyle = .none
     
        tableView.register(AssessmentTableCell.self, forCellReuseIdentifier: "assessmentCell")
    }
    
    
    //Add assessment action button
    @objc func addAssessment(){
        self.performSegue(withIdentifier: "addAssessment", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        assessments = SchoolDB.shared.getAssessmentList(courseId: course.id)
        tableView.reloadData()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Set delegate for Add assessment controller
        (segue.destination as? AddAssessmentViewController)?.isAssessmentEditing = false
        if segue.identifier == "addAssessment" || segue.identifier == "editAssessment"{
            (segue.destination as? AddAssessmentViewController)?.delegate = self
        }
        
        if segue.identifier == "editAssessment"{
            (segue.destination as? AddAssessmentViewController)?.isAssessmentEditing = true
            (segue.destination as? AddAssessmentViewController)?.assessment = selectedAssessment ?? Assessment()
            selectedAssessment = nil
        }
        else if segue.identifier == "assessmentInfo"{
            (segue.destination as? AssessmentInfoViewController)?.assessment = selectedAssessment
        }
    }
    //Update course and semester if assessment weight or grade was changed
    func updateCourseAndSemester(){
        course.updateGrade()
        let semester = SchoolDB.shared.getOneSemester(id: course.semId)
        semester?.updateGPA()
    }

}


extension CourseInfoViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : assessments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "assessmentCell") as? AssessmentTableCell else{
            return UITableViewCell()
        }
        cell.start(assessment: assessments[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 200 : 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedAssessment = assessments[indexPath.row]
        
        self.performSegue(withIdentifier: "assessmentInfo", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let assessment = (tableView.cellForRow(at: indexPath) as? AssessmentTableCell)?.assessment
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.assessments.remove(at: indexPath.row)
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }) { _ in
                self.updateCourseAndSemester()
            }
            
            SchoolDB.shared.deleteAssessment(id: assessment?.id ?? 0)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            self.selectedAssessment = assessment
            self.performSegue(withIdentifier: "editAssessment", sender: nil)
        }
        editAction.backgroundColor = .init(red: 0, green: 122/255, blue: 1, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let mainView = UIView()
        mainView.backgroundColor = .white
        if section == 0{
            //Rounded view
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .init(white: 0.95, alpha: 1)
            mainView.addSubview(view)
            
            view.layer.cornerRadius = 25
            view.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0).isActive = true
            view.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 10).isActive = true
            view.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10).isActive = true
            view.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10).isActive = true
            
            
            
            let attributesForPartOne: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 18, weight: .medium)]
            let attributesForPartTwo: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 20, weight: .light), .foregroundColor: UIColor.darkGray]
            
            //Name label of course
            let nameLbl = UILabel()
            nameLbl.numberOfLines = 0
            
            
            let nameAttributedString1 = NSMutableAttributedString(string: "Name:\n", attributes: attributesForPartOne)
            let nameAttributedString2 = NSMutableAttributedString(string: "\(course.name)", attributes: attributesForPartTwo)
            nameAttributedString1.append(nameAttributedString2)
            nameLbl.attributedText = nameAttributedString1
            

            nameLbl.translatesAutoresizingMaskIntoConstraints = false
            nameLbl.sizeToFit()
            view.addSubview(nameLbl)
            
            
            nameLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            nameLbl.widthAnchor.constraint(equalToConstant: nameLbl.frame.width).isActive = true
            nameLbl.heightAnchor.constraint(equalToConstant: nameLbl.frame.height).isActive = true
            
            //Code label
            let codeLbl = UILabel()
            codeLbl.numberOfLines = 0
            
            let codeAttributedString1 = NSMutableAttributedString(string: "Code:\n", attributes: attributesForPartOne)
            let codeAttributedString2 = NSMutableAttributedString(string: "\(course.code)", attributes: attributesForPartTwo)
            codeAttributedString1.append(codeAttributedString2)
            codeLbl.attributedText = codeAttributedString1
            
            
            codeLbl.translatesAutoresizingMaskIntoConstraints = false
            codeLbl.sizeToFit()
            view.addSubview(codeLbl)
            
            codeLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            codeLbl.leadingAnchor.constraint(equalTo: nameLbl.leadingAnchor).isActive = true
            codeLbl.widthAnchor.constraint(equalToConstant: codeLbl.frame.width).isActive = true
            codeLbl.heightAnchor.constraint(equalToConstant: codeLbl.frame.height).isActive = true
            nameLbl.bottomAnchor.constraint(equalTo: codeLbl.topAnchor, constant: -15).isActive = true
            
            
            //Credits label
            let creditLbl = UILabel()
            creditLbl.numberOfLines = 0
            
            let creditAttributedString1 = NSMutableAttributedString(string: "Number of credits:\n", attributes: attributesForPartOne)
            let creditAttributedString2 = NSMutableAttributedString(string: "\(course.credits)", attributes: attributesForPartTwo)
            creditAttributedString1.append(creditAttributedString2)
            
            creditLbl.attributedText = creditAttributedString1
            
            creditLbl.translatesAutoresizingMaskIntoConstraints = false
            creditLbl.sizeToFit()
            view.addSubview(creditLbl)
            
            creditLbl.topAnchor.constraint(equalTo: codeLbl.bottomAnchor, constant: 15).isActive = true
            creditLbl.leadingAnchor.constraint(equalTo: nameLbl.leadingAnchor).isActive = true
            creditLbl.widthAnchor.constraint(equalToConstant: creditLbl.frame.width).isActive = true
            creditLbl.heightAnchor.constraint(equalToConstant: creditLbl.frame.height).isActive = true
            
            //Set a grade view
            let gradeView = UIView()
            gradeView.frame.size = CGSize(width: 200, height: 200)
            gradeView.backgroundColor = .clear
            gradeView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(gradeView)
            
            gradeView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            gradeView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            gradeView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            gradeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            
            //Set a grade background circle
            let gradeBackgroundLayer = CAShapeLayer()
            
            let beizerPath = UIBezierPath(arcCenter: CGPoint(x: 100, y: 130), radius: 30, startAngle: 0, endAngle: .pi * 2, clockwise: true)
     
            gradeBackgroundLayer.path = beizerPath.cgPath
            gradeBackgroundLayer.lineWidth = 12
            gradeBackgroundLayer.fillColor = UIColor.clear.cgColor
            gradeBackgroundLayer.strokeColor = UIColor.init(white: 0.9, alpha: 1).cgColor
            gradeView.layer.addSublayer(gradeBackgroundLayer)
            
            
            //Set a grade filled circle
            
            let gradeAngle: CGFloat = .pi * 2 * CGFloat(course.grade / 100.0)
            let startAngle: CGFloat = .pi / -2.0
            
            let gradeFilledLayer = CAShapeLayer()
            let filledBeizerPath = UIBezierPath(arcCenter: CGPoint(x: 100, y: 130), radius: 30, startAngle: startAngle, endAngle: gradeAngle + startAngle, clockwise: true)
            gradeFilledLayer.path = filledBeizerPath.cgPath
            gradeFilledLayer.lineWidth = 12
            gradeFilledLayer.fillColor = UIColor.clear.cgColor
            gradeFilledLayer.strokeColor = UIColor.init(red: 0, green: 122/255, blue: 1, alpha: 1).cgColor
            gradeView.layer.addSublayer(gradeFilledLayer)
            
            
            
            //Set a grade label
            let gradeLabel = UILabel()
            gradeLabel.numberOfLines = 0
            
            let gradeAttributedString1 = NSMutableAttributedString(string: "Grade:\n", attributes: attributesForPartOne)
            let gradeAttributedString2 = NSMutableAttributedString(string:  "\(String(format: "%.2f", arguments: [course.grade]))%", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .bold), .foregroundColor: UIColor.darkGray])
            gradeAttributedString1.append(gradeAttributedString2)
            gradeLabel.attributedText = gradeAttributedString1
            gradeLabel.textAlignment = .center
            
            gradeLabel.translatesAutoresizingMaskIntoConstraints = false
            gradeLabel.sizeToFit()
            
            gradeView.addSubview(gradeLabel)
            gradeLabel.topAnchor.constraint(equalTo: gradeView.topAnchor, constant: 25).isActive = true
            gradeLabel.centerXAnchor.constraint(equalTo: gradeView.centerXAnchor).isActive = true
            gradeLabel.widthAnchor.constraint(equalToConstant: gradeLabel.frame.width).isActive = true
            gradeLabel.heightAnchor.constraint(equalToConstant: gradeLabel.frame.height).isActive = true
            
        }
        else{
            //Set title for a list
            let titleLabel = UILabel()
            titleLabel.text = "Assessments in this course:"
            titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.sizeToFit()
            mainView.addSubview(titleLabel)
            
            titleLabel.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: titleLabel.frame.width).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20).isActive = true
            
            //Add button
            let addButton = UIButton(type: .contactAdd)
            addButton.translatesAutoresizingMaskIntoConstraints = false
            addButton.sizeToFit()
            
            mainView.addSubview(addButton)
            
            addButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
            addButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
            addButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
            addButton.heightAnchor.constraint(equalToConstant: addButton.frame.height).isActive = true
            
            addButton.addTarget(self, action: #selector(addAssessment), for: .touchUpInside)
        }
        
        return mainView
    }
    
    
}

//Will save assessment: save to database and reload table view
extension CourseInfoViewController: AddAssessmentDelegate{
    func willSaveAssessment(assessment: Assessment, isEditing: Bool) {
        assessment.courseId = course.id
        
        if !isEditing{
            self.assessments.append(assessment)
            _ = SchoolDB.shared.addAssessment(assessment: assessment)
        }
        else{
            _ = SchoolDB.shared.editAssessment(newAssess: assessment)
        }
        
        
     
        self.updateCourseAndSemester()
        self.tableView.reloadData()
        
    }
}
