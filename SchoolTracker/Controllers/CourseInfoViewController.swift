//
//  CourseInfoViewController.swift
//  SchoolTracker
//
//  Created by Penric on 4/18/22.
//

import UIKit

class CourseInfoViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    
    var course: Course!
    var assessments: [Assessment] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        assessments = SchoolDB.shared.getAssessmentList(courseId: course.id)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "assessmentCell")
    }
    


}


extension CourseInfoViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : assessments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "assessmentCell") else{
            return UITableViewCell()
        }
        cell.contentView.subviews.forEach({$0.removeFromSuperview()})
        cell.separatorInset.right = 5000
        if indexPath.row == 0{
            let addButton = UIButton(type: .contactAdd)
            addButton.translatesAutoresizingMaskIntoConstraints = false
            addButton.sizeToFit()
            
            cell.contentView.addSubview(addButton)
            
            addButton.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor).isActive = true
            addButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
            addButton.widthAnchor.constraint(equalToConstant: cell.frame.width).isActive = true
            addButton.heightAnchor.constraint(equalToConstant: cell.frame.height).isActive = true
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 50
        }
        return 200
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 200 : 20
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let mainView = UIView()
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
            let gradeAttributedString2 = NSMutableAttributedString(string: course.isComplete ? "\(course.grade)%" : "Not completed", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .bold), .foregroundColor: UIColor.darkGray])
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
            
            titleLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
            titleLabel.widthAnchor.constraint(equalToConstant: titleLabel.frame.width).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20).isActive = true
        }
        
        return mainView
    }
    
    
}
