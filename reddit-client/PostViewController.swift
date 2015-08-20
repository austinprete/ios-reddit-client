//
//  PostViewController.swift
//  reddit-client
//
//  Created by Austin Prete on 7/14/15.
//  Copyright (c) 2015 Austin Prete. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, RedditAPIRequestDelegate {
    @IBOutlet weak var selfTextView: UITextView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postAuthorLabel: UILabel!
    @IBOutlet weak var postKarmaLabel: UILabel!
    var postID = ""
    var authCode = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadPostDetails()
    }
    
    func loadPostDetails() {
        var urlString = "https://oauth.reddit.com/by_id/" + postID
        let redditRequest = RedditAPIRequest()
        redditRequest.sendRedditAPIRequest(urlString, authCode: authCode, params: [ : ], delegate: self)
        
    }
    
    func handleRedditData(data: NSData!, urlResponse: NSURLResponse!, error: NSError!, fromRequest: RedditAPIRequest!) {
        if error != nil {
            return
        }
        var err: NSError?
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
        if let rootDict = jsonResult["data"] as? NSDictionary {
            if let postsArray = rootDict["children"] as? NSArray {
                for post in postsArray {
                    let post = post as! NSDictionary
                    let data = post["data"] as! NSDictionary
                    dispatch_async(dispatch_get_main_queue(), {
                        self.postTitleLabel.text! = data["title"] as! String
                        self.postAuthorLabel.text! = data["author"] as! String
                        var upvotes = data["ups"] as! Int
                        var downvotes = data["downs"] as! Int
                        self.postKarmaLabel.text! = "Up: \(upvotes) | Down: \(downvotes)"
                        self.selfTextView.text = data["selftext"] as! String
                        self.selfTextView.editable = false

                    })
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
