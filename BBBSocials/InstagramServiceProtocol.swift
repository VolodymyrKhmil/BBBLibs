//
//  InstagramServiceProtocol.swift
//  jigit
//
//  Created by Orion on 8/19/15.
//  Copyright (c) 2015 dominik. All rights reserved.
//

import InstagramKit

enum InstagramResponceState: Equatable
{
    case Success(Int)
    case Fail(Int)
}
func ==(a: InstagramResponceState, b: InstagramResponceState) -> Bool {
    switch (a, b) {
    case (.Success(let a),   .Success(let b))   where a == b: return true
    case (.Fail(let a), .Fail(let b)) where a == b: return true
    default: return false
    }
}

enum InstagramStatusCodes: Int
{
    case ValidStatus = 0
    case ConvertionFailed = 1
    
    var description: Int {
        return self.rawValue
    }
    
    var state: InstagramResponceState {
        return (self.rawValue == 0) ? InstagramResponceState.Success(self.description) : InstagramResponceState.Fail(self.description)
    }
}

struct InstagramData
{
    var comment: String
}

protocol InstagramServiceProtocol
{
    func tokenGranted() -> Bool
    func setAccessTokenFromUrl(url: NSURL!, error: NSErrorPointer) -> Bool
    func getOAuthUrl(scope: InstagramKitLoginScope, _ responce: (url: NSURL, InstagramResponceState) -> Void)
    func getFollowers(id: String?, responce: ([InstagramUser]?, InstagramResponceState) -> Void)
    func getFollowedBy(id: String?, responce: ([InstagramUser]?, InstagramResponceState) -> Void)
    func postToInstagram(data: InstagramData, _ responce: ((InstagramResponceState) -> Void)?)
}
