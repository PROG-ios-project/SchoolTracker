//
//  GPAWebViewController.swift
//  SchoolTracker
//
//  Created by Thomas on 4/20/22.
//  Simple View Controller to set the url for the webview accessed from the about page.

import UIKit
import WebKit

class GPAWebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView : WKWebView! //Outlet to connect to webkit view in view controller

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
            super.viewDidLoad()

            //steps to set the url and delegate for the webkit view
            let urlAddress = URL(string:"https://gpacalculator.net/how-to-calculate-gpa/")
            let url = URLRequest(url: urlAddress!)
            webView.load(url)
            webView.navigationDelegate = self
            
        }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}
