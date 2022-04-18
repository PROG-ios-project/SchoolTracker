//
//  MainMenuViewController.swift
//  SchoolTracker
//
//  Created by Thomas on 4/15/22.
//

import UIKit

class MainMenuViewController: UIViewController {

    
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set up large title for navigation controller
        self.navigationController?.navigationBar.prefersLargeTitles = true
        buttons.forEach({
            $0.backgroundColor = UIColor.lightGray
            $0.setTitleColor(.white, for: .normal)
            $0.tintColor = .white
            $0.layer.cornerRadius = 15
            
        })
    }
    

}
