//
//  ViewController.swift
//  reddit-client
//
//  Created by Austin Prete on 7/11/15.
//  Copyright (c) 2015 Austin Prete. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var authenticateWebView: UIWebView!
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if let request = webView.request {
            let host = request.URL?.host as String!
            if host.isEmpty {
                return
            }
            println(host)
            if host == "austinprete.com" {
            webView.removeFromSuperview()
            }
            else {
                return
            }

            var queryStrings = [String: String]()
            if let query = request.URL?.query as String! {
                for qs in query.componentsSeparatedByString("&") {
                    // Get the parameter name
                    let key = qs.componentsSeparatedByString("=")[0]
                    // Get the parameter name
                    var value = qs.componentsSeparatedByString("=")[1]
                    value = value.stringByReplacingOccurrencesOfString("+", withString: " ")
                    value = value.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                    
                    queryStrings[key] = value
                }
            } else {
                return
            }
            if let code = queryStrings["code"] {
                println(code)
                let url_string = "https://www.reddit.com/api/v1/access_token"
                var params = ["grant_type": "authorization_code", "code": code, "redirect_uri": "http://austinprete.com"]
                
                var request = NSMutableURLRequest(URL: NSURL(string: url_string)!)
                request.HTTPMethod = "POST"
                var err: NSError?
                request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                let userpass = "Et2T7VJP3lwlLw:"
                let utf8str = userpass.dataUsingEncoding(NSUTF8StringEncoding)
                let base64str = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(0))
                request.addValue("Basic " + base64str!, forHTTPHeaderField: "Authorization")
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
                    var err: NSError?
                    var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
                    println(jsonResult)
                })
                task.resume()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        authenticateWebView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleAuthenticateButtonPressed(sender: AnyObject) {
        var request = NSURLRequest(URL: NSURL(string: "https://www.reddit.com/api/v1/authorize.compact?client_id=Et2T7VJP3lwlLw&response_type=code&state=RANDOM_STRING&redirect_uri=http://austinprete.com&duration=temporary&scope=mysubreddits")!)
        authenticateWebView.loadRequest(request)
    }

}

