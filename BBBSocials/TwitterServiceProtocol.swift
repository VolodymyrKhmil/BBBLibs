//
//  TwiterServiceProtocol.swift
//  jigit
//
//  Created by Orion on 8/14/15.
//  Copyright (c) 2015 dominik. All rights reserved.
//

import Accounts

enum TwitterResponceState
{
    case Success(Int)
    case Fail(Int)
}

struct TweetData {
    var text: String!
    var mediaId: String?
}

protocol TwitterServiceProtocol
{
    func getTwiterFollowersFocAccountWithId(id: String?, account: ACAccount, _ responce: ([String: AnyObject]?, TwitterResponceState) -> Void)
    func getTwiterFollowersFocAccountWithScreenName(name: String?, account: ACAccount, _ responce: ([String: AnyObject]?, TwitterResponceState) -> Void)
    
    func uplodaMedia(account: ACAccount, media: NSData, _ responce: (([String: AnyObject]?, TwitterResponceState) -> Void)?)
    func postTweetToUserWithScreenName(name: String, account: ACAccount, data: TweetData, _ responce: ((TwitterResponceState) -> Void)?)
}
