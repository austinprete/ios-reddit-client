//
//  SubredditViewController.swift
//  reddit-client
//
//  Created by Austin Prete on 7/14/15.
//  Copyright (c) 2015 Austin Prete. All rights reserved.
//

import UIKit

class SubredditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RedditAPIRequestDelegate {
    @IBOutlet weak var subredditDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subredditURLLabel: UILabel!
    @IBOutlet weak var subredditTitleLabel: UILabel!
    var subredditTitle : String = ""
    var subredditName : String = ""
    var subredditURL : String = ""
    var subredditDescription : String = ""
    var authCode : String = ""
    
    var subredditPosts : [(title: String, author: String, upvotes: Int, downvotes: Int, id: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.subredditTitleLabel.text = subredditTitle
        self.subredditURLLabel.text = subredditURL
        self.subredditDescriptionLabel.text = "\(subredditDescription)"
        self.navigationItem.title = subredditName
        loadSubredditPosts()
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func loadSubredditPosts() {
        var urlString = "https://oauth.reddit.com/r/" + subredditName + "/hot"
        let redditRequest = RedditAPIRequest()
        redditRequest.sendRedditAPIRequest(urlString, authCode: authCode, params: [ : ], delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subredditPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var postCell = self.tableView.dequeueReusableCellWithIdentifier("postCell") as! PostCell
        postCell.postTitleLabel?.text = self.subredditPosts[indexPath.row].title
        let upvotes = self.subredditPosts[indexPath.row].upvotes
        let downvotes = self.subredditPosts[indexPath.row].downvotes
        postCell.postKarmaLabel?.text = "Up: \(upvotes) Down: \(downvotes)"
        postCell.postAuthorLabel?.text = self.subredditPosts[indexPath.row].1
        return postCell
    }
    
    
    func handleRedditData(data: NSData!, urlResponse: NSURLResponse!, error: NSError!, fromRequest: RedditAPIRequest!) {
        if error != nil {
            return
        }
        var err: NSError?
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
//        println(jsonResult)
        if let rootDict = jsonResult["data"] as? NSDictionary {
            if let postsArray = rootDict["children"] as? NSArray {
                for post in postsArray {
                    let post = post as! NSDictionary
                    let data = post["data"] as! NSDictionary
                    let title = data["title"] as! String
                    let upvotes = data["ups"] as! Int
                    let downvotes = data["downs"] as! Int
                    let author = data["author"] as! String
                    let id = data["name"] as! String
                    subredditPosts.append((title: title, author: author, upvotes: upvotes, downvotes: downvotes, id: id))
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    @IBAction func handleShowFullTextTapped(sender: AnyObject) {
        var navBarHeight = self.navigationController!.navigationBar.frame.height
        var overlay : UIScrollView? // This should be a class variable
        
        overlay = UIScrollView(frame: CGRect(origin: CGPoint(x: 0, y: navBarHeight + 10), size: CGSize(width: self.view.frame.width, height: self.view.frame.height - navBarHeight - 10)))
        overlay!.backgroundColor = UIColor.darkGrayColor()
        overlay!.alpha = 0.98
        var overlay_label = UILabel(frame: CGRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: self.view.frame.width - 10, height: 30)))
        overlay_label.numberOfLines = 0
        overlay_label.text = self.subredditDescription
        overlay_label.sizeToFit()
        overlay_label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        overlay!.contentSize = CGSize(width: overlay_label.frame.width, height: overlay_label.frame.height + navBarHeight)
        overlay_label.textColor = UIColor.whiteColor()
        overlay?.addSubview(overlay_label)
        
        self.view.addSubview(overlay!)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPostDetails" {
            if let postVC = segue.destinationViewController as? PostViewController {
                let row = self.tableView!.indexPathForSelectedRow()!.row
                postVC.authCode = self.authCode
                postVC.postID = self.subredditPosts[row].id
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
