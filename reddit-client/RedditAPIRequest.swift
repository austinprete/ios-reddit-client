//
//  RedditAPIRequest.swift
//  reddit-client
//
//  Created by Austin Prete on 7/14/15.
//  Copyright (c) 2015 Austin Prete. All rights reserved.
//

import Foundation

class RedditAPIRequest : NSObject {
    
    func sendRedditAPIRequest (urlString : String, authCode : String, params : [String:String], delegate: RedditAPIRequestDelegate?) {
        var request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "GET"
        request.addValue("bearer " + authCode, forHTTPHeaderField: "Authorization")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {(data : NSData!, response : NSURLResponse!, error: NSError!) in
            if let delegate = delegate {
                delegate.handleRedditData(data, urlResponse: response, error: error, fromRequest: self)
            }
            else {
                return
            }
        })
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), {
            task.resume()
        })
    }
    
}