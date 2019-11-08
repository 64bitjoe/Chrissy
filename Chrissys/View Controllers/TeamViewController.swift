//
//  TeamViewController.swift
//  Chrissys
//
//  Copyright © 2019 Chrissys. All rights reserved.
//

import UIKit
import WebKit
class TeamViewController: UIViewController,  WKNavigationDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        activityIndicator.hidesWhenStopped = true
        webView?.navigationDelegate = self
        
        let myURL = URL(string:"http://chrissys.co/contributors/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)

        
    }
    func showActivityIndicator(show: Bool) {
        if show {
            // Start the loading animation
            activityIndicator.startAnimating()
        } else {
            // Stop the loading animation
            activityIndicator.stopAnimating()
        }
    }
    func webView(_ webView: WKWebView, didStart navigation: WKNavigation!)
    {
        showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        showActivityIndicator(show: false)
    }
}
