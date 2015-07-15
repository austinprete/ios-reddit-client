//
//  RedditAPIRequestDelegate.swift
//  reddit-client
//
//  Created by Austin Prete on 7/14/15.
//  Copyright (c) 2015 Austin Prete. All rights reserved.
//

import Foundation

protocol RedditAPIRequestDelegate {
    func handleRedditData (data: NSData!, urlResponse: NSURLResponse!, error: NSError!, fromRequest: RedditAPIRequest!)
}