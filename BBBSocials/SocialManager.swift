//
//  SocialManager.swift
//  jigit
//
//  Created by Orion on 8/21/15.
//  Copyright (c) 2015 dominik. All rights reserved.
//

import Accounts

class SocialManager
{
    //MARK: enum constants
    
    enum TwitterAdditionalValues: String{
        case ScreenName = "screen_name"
        
        var description: String {
            return self.rawValue
        }
    }
    
    //MARK: private veriables
    
    lazy var _facebookService: FacebookServiceProtocol = FacebookSDKService()
    lazy var _twitterService: TwitterServiceProtocol = TwitterSocialFrameworkService()
    
    //MARK: facebook methods
    
    func facebookFriendsForUserWithId(#id: String?, type: FacebookFriendRequestType, _ responce: ([SocialUser]?, FacebookResponceState) -> Void)
    {
        self._facebookService.getFriendsForUserWithId(id: id, type: type) { (responceDictionary, state) -> Void in
            responce(self._facebookResponceToSocailUserArray(responceDictionary), state)
        }
    }
    
    func postToUsersBoardWithId(#id: String?, postData: FacebookPostData, _ responce: ((FacebookResponceState) -> Void)?)
    {
        self._facebookService.postToUsersBoardWithId(id: id, postData: postData) { (state) -> Void in
            responce?(state)
        }
    }
    
    func loginToFacebookWithPermissions(permissions: [FacebookPermissions], type: FacebookPermissions.PermissionType, _ responce: ((FacebookResponceState) -> Void)?)
    {
        self._facebookService.loginToFacebookWithPermissions(permissions, type: type) { (state) -> Void in
            responce?(state)
        }
    }
    
    //MARK: Twitter methods
    
    func getTwiterFollowersFocAccountWithId(id: String?, account: ACAccount, _ responce: ([SocialUser]?, TwitterResponceState) -> Void)
    {
        self._twitterService.getTwiterFollowersFocAccountWithId(id, account: account) { (responceDictionary, state) -> Void in
            responce(self._twitterResponceToSocialUserArray(responceDictionary), state)
        }
    }
    
    func getTwiterFollowersFocAccountWithScreenName(name: String?, account: ACAccount, _ responce: ([SocialUser]?, TwitterResponceState) -> Void)
    {
        self._twitterService.getTwiterFollowersFocAccountWithScreenName(name, account: account) { (responceDictionary, state) -> Void in
            responce(self._twitterResponceToSocialUserArray(responceDictionary), state)
        }
    }
    
    func uplodaMedia(account: ACAccount, media: NSData, _ responce: ((id: String?, TwitterResponceState) -> Void)?)
    {
        self._twitterService.uplodaMedia(account, media: media) { (responceDictionary, state) -> Void in
            let id: String? = responceDictionary?["media_id_string"] as? String
            responce?(id: id, state)
        }
    }
    
    func postTweetToUserWithScreenName(name: String, account: ACAccount, data: TweetData, _ responce: ((TwitterResponceState) -> Void)?)
    {
        self._twitterService.postTweetToUserWithScreenName(name, account: account, data: data) { (state) -> Void in
            responce?(state)
        }
    }
    
    //MARK: private help methods
    
    private func _twitterResponceToSocialUserArray(responce: [String: AnyObject]?) -> [SocialUser]?
    {
        let usersArray: [[String: AnyObject]]? = (responce?["users"] as? [[String:AnyObject]])
        
        if usersArray == nil
        {
            return nil
        }
        
        var socialUsers: [SocialUser] = [SocialUser]()
        for user in usersArray!
        {
            socialUsers.append(_twitterUsertoSocialUser(user))
        }
        return socialUsers
    }
    
    private func _facebookResponceToSocailUserArray(responce: [String: AnyObject]?) -> [SocialUser]?
    {
        let usersArray: [[String:AnyObject]]? = (responce?["data"] as? [[String:AnyObject]])
        if usersArray == nil
        {
            return nil
        }
        
        var socialUsers: [SocialUser] = [SocialUser]()
        for user in usersArray!
        {
            socialUsers.append(_facebookUserToSocialUser(user))
        }
        return socialUsers
    }
    
    private func _facebookUserToSocialUser(user: [String:AnyObject]) -> SocialUser
    {
        return SocialUser(name: user["name"] as? String, id: user["id"] as? String, image: ((user["picture"] as? [String: AnyObject])?["data"] as? [String: AnyObject])?["url"] as? String, additionalInfo: nil)
    }
    
    private func _twitterUsertoSocialUser(user: [String:AnyObject]) -> SocialUser
    {
        return SocialUser(name: user["name"] as? String, id: user["id_str"] as? String, image: user["profile_image_url"] as? String, additionalInfo: [TwitterAdditionalValues.ScreenName.description: user[TwitterAdditionalValues.ScreenName.description] as? String])

    }
}
