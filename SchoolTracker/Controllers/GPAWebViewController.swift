//
//  GPAWebViewController.swift
//  SchoolTracker
//
//  Created by Penric on 4/20/22.
//

import UIKit
import WebKit

class GPAWebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView : WKWebView!

        override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
            
            let urlAddress = URL(string:"https://gpacalculator.net/how-to-calculate-gpa/")
            let url = URLRequest(url: urlAddress!)
            webView.load(url)
            webView.navigationDelegate = self
            
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
