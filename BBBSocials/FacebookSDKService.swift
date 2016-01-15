//
//  FacebookService.swift
//  jigit
//
//  Created by Orion on 8/14/15.
//  Copyright (c) 2015 dominik. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit

class FacebookSDKService: FacebookServiceProtocol
{
    //MARK: private help enums
    
    private enum Keys: String
    {
        case me = "me"
        case feed = "feed"
        case message = "message"
        case link = "link"
        
        var description: String {
            return self.rawValue
        }
    }
    
    private enum Methods: String
    {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        
        var description: String {
            return self.rawValue
        }
    }
    
    //MARK: FacebookServiceProtocol methods
    
    func loginToFacebookWithPermissions(permissions: [FacebookPermissions], type: FacebookPermissions.PermissionType, _ responce: ((FacebookResponceState) -> Void)?)
    {
        if FBSDKAccessToken.currentAccessToken() != nil
        {
            responce?(FacebookResponceState.Fail(FacebookStatusCodes.TokenAlreadyExists.description))
            return
        }
        _loginWithPermissions(permissions, type: type, responce)
    }
    
    func postToUsersBoardWithId(#id: String?, postData: FacebookPostData, _ responce: ((FacebookResponceState) -> Void)?)
    {
        _loginWithPermissions([FacebookPermissions.publish_actions], type: FacebookPermissions.PermissionType.Publish) { (state) -> Void in
            if state != FacebookStatusCodes.ValidStatus.state
            {
                responce?(state)
            }
            else if FBSDKAccessToken.currentAccessToken().hasGranted(FacebookPermissions.publish_actions.description)
            {
                let stringId = (id != nil) ? id : Keys.me.description
                var parameters: [String: AnyObject] = [Keys.message.description: postData.text]
                if postData.link != nil
                {
                    parameters[Keys.link.description] = postData.link!
                }
                
                FBSDKGraphRequest(graphPath: "\(stringId!)/\(Keys.feed.description)", parameters: parameters, HTTPMethod: Methods.POST.description).startWithCompletionHandler() { requestConnection, _, error in
                    let statusCode = requestConnection.URLResponse.statusCode
                    responce?((error != nil) ? FacebookResponceState.Fail(error.code) : FacebookStatusCodes.ValidStatus.state)
                }
            }
            else
            {
                responce?(FacebookResponceState.Fail(FacebookStatusCodes.NoPermissionForAction.description))
            }
        }
    }
    
    func getFriendsForUserWithId(#id: String?, type: FacebookFriendRequestType, _ responce: ([String : AnyObject]?, FacebookResponceState) -> Void)
    {
        _loginWithPermissions([FacebookPermissions.user_friends], type: FacebookPermissions.PermissionType.Read) { (state) -> Void in
            if state != FacebookStatusCodes.ValidStatus.state
            {
                responce(nil, state)
            }
            else if FBSDKAccessToken.currentAccessToken().hasGranted(FacebookPermissions.user_friends.description)
            {
                let stringId = (id != nil) ? id : Keys.me.description
                FBSDKGraphRequest(graphPath: "/\(stringId!)/\(type.description)", parameters: nil, HTTPMethod: Methods.GET.description).startWithCompletionHandler() { requestConnection, resoult, error in
                    let statusCode = requestConnection.URLResponse.statusCode
                    if error != nil || resoult == nil
                    {
                        responce(nil, FacebookResponceState.Fail(error.code))
                    }
                    else
                    {
                        let resoultDictionary: [String: AnyObject]? = resoult as? [String: AnyObject]
                        responce(resoultDictionary, (resoultDictionary == nil) ? FacebookResponceState.Fail(statusCode) : FacebookStatusCodes.ValidStatus.state)
                    }
                }
            }
            else
            {
                responce(nil, FacebookResponceState.Fail(FacebookStatusCodes.NoPermissionForAction.description))
            }
        }
    }
    
    //MARK: private help methods
    
    private func _facebookPermissionsToStrings(permissions: [FacebookPermissions]) -> [String]
    {
        return permissions.map { (object: FacebookPermissions) -> String in
            return object.description
        }
    }
    
    private func _requestPermissionHandler(result: FBSDKLoginManagerLoginResult!, error: NSError!, requestedPermissions: [String]) -> FacebookResponceState
    {
        if error != nil
        {
            return FacebookResponceState.Fail(FacebookStatusCodes.GetingPermissionsFailed.description)
        }
        else if result.isCancelled
        {
            return FacebookResponceState.Fail(FacebookStatusCodes.GetingPermissionsCancelled.description)
        }
        else
        {
            var allPermsGranted = true
            
            let grantedPermissions = Array(result.grantedPermissions).map( {"\($0)"} )
            for permission in requestedPermissions {
                if !contains(grantedPermissions, permission) {
                    return FacebookResponceState.Fail(FacebookStatusCodes.GetingPermissionsFailed.description)
                }
            }
        }
        return FacebookStatusCodes.ValidStatus.state
    }
    
    private func _loginWithPermissions(permissions: [FacebookPermissions], type: FacebookPermissions.PermissionType, _ responce: ((FacebookResponceState) -> Void)?)
    {
        let stringPermissions = _facebookPermissionsToStrings(permissions)
        
        var responceState = FacebookResponceState.Fail(FacebookStatusCodes.UnknownError.description)
        var permissionResoult: FBSDKLoginManagerLoginResult?
        
        if type == FacebookPermissions.PermissionType.Read
        {
            FBSDKLoginManager().logInWithReadPermissions(stringPermissions, handler: { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
                responceState = self._requestPermissionHandler(result, error: error, requestedPermissions: stringPermissions)
                responce?(responceState)
            })
        }
        else if type == FacebookPermissions.PermissionType.Publish
        {
            FBSDKLoginManager().logInWithPublishPermissions(stringPermissions, handler: { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
                responceState = self._requestPermissionHandler(result, error: error, requestedPermissions: stringPermissions)
                responce?(responceState)
            })
        }
    }
}
