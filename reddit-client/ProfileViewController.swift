//
//  ProfileViewController.swift
//  reddit-client
//
//  Created by Austin Prete on 7/13/15.
//  Copyright (c) 2015 Austin Prete. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, RedditAPIRequestDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var karmaLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var authCode = ""

    
    var request : NSURLRequest?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        subreddits = []
        getProfileInfo()
    }
    
    
    func ProfileViewController() {
        self.request = nil
    }
    
    func getProfileInfo() {
        if let request = request {
            var queryStrings = [String: String]()
            if let query = request.URL?.fragment as String! {
                print (query)
                for qs in query.componentsSeparatedByString("&") {
                    // Get the parameter name
                    let key = qs.componentsSeparatedByString("=")[0]
                    // Get the parameter name
                    var value = qs.componentsSeparatedByString("=")[1]
                    value = value.stringByReplacingOccurrencesOfString("+", withString: " ")
                    value = value.stringByRemovingPercentEncoding!
                    
                    queryStrings[key] = value
                }
            } else {
                return
            }
            if let code = queryStrings["access_token"] {
                self.authCode = code
                let urlString = "https://oauth.reddit.com/api/v1/me"
                let redditRequest = RedditAPIRequest()
                redditRequest.sendRedditAPIRequest(urlString, authCode: code, params: [ : ], delegate: self)
                let subredditsUrlString = "https://oauth.reddit.com/subreddits/mine/subscriber"
                redditRequest.sendRedditAPIRequest(subredditsUrlString, authCode: code, params: [ : ], delegate: self)
            }
        }
    }
    
    var subreddits : [(String, String, String, String)] = []
    
    func handleRedditData(data: NSData!, urlResponse: NSURLResponse!, error: NSError!, fromRequest: RedditAPIRequest!) {
        if error != nil {
            return
        }
        let jsonResult = (try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
        dispatch_async(dispatch_get_main_queue(), {
            
            if let jsonDict = jsonResult as? [String: AnyObject] {
                if let rootDict = jsonDict["data"] as? [String: AnyObject] {
                    let subredditsArray = rootDict["children"] as! NSArray
                    for subreddit in subredditsArray {
                        let subreddit = subreddit as! NSDictionary
                        let data = subreddit["data"] as! NSDictionary
                        let title = data["title"] as! String
                        let name = data["display_name"] as! String
                        let subredditURL = data["url"] as! String
                        let description = data["description"] as! String
                        self.subreddits.append((title, name, subredditURL, description))
                    }
                    self.tableView.reloadData()
                } else {
                    var userDict = jsonDict
                    let username = userDict["name"] as! String
                    let linkKarma = userDict["link_karma"] as! Int
                    let commentKarma = userDict["comment_karma"] as! Int
                    self.userNameLabel.text = username
                    self.karmaLabel.text = "\(linkKarma) | \(commentKarma)"
                }
            }
        })
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subreddits.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:SubredditCell = self.tableView.dequeueReusableCellWithIdentifier("subredditCell") as! SubredditCell
        cell.subredditNameLabel?.text = self.subreddits[indexPath.row].0
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSubredditSegue" {
            if let subredditVC = segue.destinationViewController as? SubredditViewController {
                let row = self.tableView!.indexPathForSelectedRow!.row
                let subredditTitle = subreddits[row].0
                subredditVC.subredditTitle = subredditTitle
                subredditVC.subredditName = subreddits[row].1
                subredditVC.subredditURL = subreddits[row].2
                subredditVC.authCode = self.authCode
                subredditVC.subredditDescription = subreddits[row].3
            }
        }
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
