//
//  AuthenticateWebViewController.swift
//  reddit-client
//
//  Created by Austin Prete on 7/13/15.
//  Copyright (c) 2015 Austin Prete. All rights reserved.
//

import UIKit

class AuthenticateWebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var authenticateWebView: UIWebView!
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let host = request.URL!.host as String! {
            println(host)
            if host == "austinprete.com" {
                webView.removeFromSuperview()
                var nextView = self.storyboard!.instantiateViewControllerWithIdentifier("ProfileView") as! ProfileViewController
                nextView.request = request
                self.navigationController?.pushViewController(nextView, animated: true)
                return true
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        authenticateWebView.delegate = self
        var request = NSURLRequest(URL: NSURL(string: "https://www.reddit.com/api/v1/authorize.compact?client_id=Et2T7VJP3lwlLw&response_type=token&state=RANDOM_STRING&redirect_uri=http://austinprete.com&duration=temporary&scope=mysubreddits,identity,read")!)
        authenticateWebView.loadRequest(request)
    }
}
