//
//  FacebookServiceProtocol.swift
//  jigit
//
//  Created by Orion on 8/13/15.
//  Copyright (c) 2015 dominik. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit

//MARK: help enums
enum FacebookFriendRequestType: String
{
    case FriendsInApp = "friends"
    case TaggableFriends = "taggable_friends"
    case InivitableFriends = "invitable_friends"
    
    var description: String {
        return self.rawValue
    }
}

enum FacebookPermissions: String
{
    enum PermissionType
    {
        case Read
        case Publish
    }
    
    case publish_actions = "publish_actions"
    case user_friends = "user_friends"
    
    var description: String {
        return self.rawValue
    }
}

enum FacebookStatusCodes: Int
{
    case ValidStatus = 0
    case NoPermissionForAction = 1
    case TokenAlreadyExists = 2
    case GetingPermissionsFailed = 4
    case GetingPermissionsCancelled = 8
    case UnknownError = 16
    case TokenNotExists = 32
    
    var description: Int {
        return self.rawValue
    }
    
    var state: FacebookResponceState {
        return (self.rawValue == 0) ? FacebookResponceState.Success(self.description) : FacebookResponceState.Fail(self.description)
    }
}

enum FacebookResponceState: Equatable
{
    case Success(Int)
    case Fail(Int)
}
func ==(a: FacebookResponceState, b: FacebookResponceState) -> Bool {
    switch (a, b) {
    case (.Success(let a),   .Success(let b))   where a == b: return true
    case (.Fail(let a), .Fail(let b)) where a == b: return true
    default: return false
    }
}

struct FacebookPostData {
    var text: String!
    var link: String?
}

protocol FacebookServiceProtocol
{
    func getFriendsForUserWithId(#id: String?, type: FacebookFriendRequestType, _ responce: ([String: AnyObject]?, FacebookResponceState) -> Void)
    func postToUsersBoardWithId(#id: String?, postData: FacebookPostData, _ responce: ((FacebookResponceState) -> Void)?)
    func loginToFacebookWithPermissions(permissions: [FacebookPermissions], type: FacebookPermissions.PermissionType, _ responce: ((FacebookResponceState) -> Void)?)
}