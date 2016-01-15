//
//  TwitterFrameworkService.swift
//  jigit
//
//  Created by Orion on 8/14/15.
//  Copyright (c) 2015 dominik. All rights reserved.
//

import Accounts

class TwitterSocialFrameworkService: TwitterServiceProtocol
{
    //MARK: private enum constants
    
    private enum Keys: String
    {
        case status = "status"
        case media_ids = "media_ids"
        case media = "media"
        case media_data = "media_data"
        
        var description: String
        {
            return self.rawValue
        }
    }
    
    private enum ResponceKeys: String
    {
        case media_id_string = "media_id_string"
        
        var description: String
        {
            return self.rawValue
        }
    }
    
    private enum UrlConstants: String
    {
        case PostTweetUrl = "https://api.twitter.com/1.1/statuses/update.json"
        case FollowersUrl = "https://api.twitter.com/1.1/followers/list.json"
        case MediaUploadUrl = "https://upload.twitter.com/1.1/media/upload.json"
        
        var description: String
        {
            return self.rawValue
        }
    }
    
    private enum SendType: String
    {
        case user_id = "user_id"
        case screen_name = "screen_name"
        
        var description: String {
            return self.rawValue
        }
    }
    
    func uplodaMedia(account: ACAccount, media: NSData, _ responce: (([String: AnyObject]?, TwitterResponceState) -> Void)?)
    {
        let url: NSURL = NSURL(string: UrlConstants.MediaUploadUrl.description)!
        let parameters: [String: AnyObject] = [Keys.media.description: media.base64EncodedStringWithOptions(nil)]
        
        let mediaRequest: SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: url, parameters: parameters)
        mediaRequest.account = account
        
        mediaRequest.performRequestWithHandler { responceData, urlResponce, error in
            let statusCode = urlResponce.statusCode
            if error != nil
            {
                responce?(nil, TwitterResponceState.Fail(statusCode))
            }
            else
            {
                var jsonEror: NSError?
                let responceDictionary: [String: AnyObject]? = (NSJSONSerialization.JSONObjectWithData(responceData, options: NSJSONReadingOptions.MutableLeaves, error: &jsonEror) as? [String: AnyObject])

                responce?(responceDictionary, (jsonEror != nil || responceDictionary == nil) ? TwitterResponceState.Fail(statusCode) : TwitterResponceState.Success(statusCode))
            }
        }
    }
    
    func postTweetToUserWithScreenName(name: String, account: ACAccount, data: TweetData, _ responce: ((TwitterResponceState) -> Void)?)
    {
        let directedText = "@\(name) " + data.text
        let url: NSURL = NSURL(string: UrlConstants.PostTweetUrl.description)!
        var parameters: [String: AnyObject] = [Keys.status.description: directedText]
        if data.mediaId != nil || !data.mediaId!.isEmpty
        {
            parameters[Keys.media_ids.description] = [data.mediaId!]
        }
        
        let postRequest: SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.POST, URL: url, parameters: parameters)
        postRequest.account = account
        postRequest.performRequestWithHandler { _, urlResponce, error in
            let statusCode = urlResponce.statusCode
            responce?((error != nil) ? TwitterResponceState.Fail(statusCode) : TwitterResponceState.Success(statusCode))
        }
    }
    
    func getTwiterFollowersFocAccountWithId(id: String?, account: ACAccount, _ responce: ([String: AnyObject]?, TwitterResponceState) -> Void)
    {
        _getFollowersWithType(SendType.user_id, identifier: id, account: account, responce)
    }
    
    func getTwiterFollowersFocAccountWithScreenName(name: String?, account: ACAccount, _ responce: ([String : AnyObject]?, TwitterResponceState) -> Void)
    {
        _getFollowersWithType(SendType.screen_name, identifier: name, account: account, responce)
    }
    
    //MARK: private help methods
    
    private func _getFollowersWithType(type: SendType, identifier: String?, account: ACAccount, _ responce: ([String: AnyObject]?, TwitterResponceState) -> Void)
    {
        let url: NSURL = NSURL(string: UrlConstants.FollowersUrl.description)!
        let parameters: [String: AnyObject]? = (identifier != nil) ? [type.description: identifier!] : nil
        
        let followersRequest: SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: parameters)
        followersRequest.account = account
        
        followersRequest.performRequestWithHandler { responceData, urlResponce, error in
            let statusCode = urlResponce.statusCode
            if error != nil || responceData == nil
            {
                responce(nil, TwitterResponceState.Fail(statusCode))
            }
            else
            {
                var jsonEror: NSError?
                let responceDictionary: [String: AnyObject]? = (NSJSONSerialization.JSONObjectWithData(responceData, options: NSJSONReadingOptions.MutableLeaves, error: &jsonEror) as? [String: AnyObject])
                responce(responceDictionary, (jsonEror != nil || responceDictionary == nil) ? TwitterResponceState.Fail(statusCode) : TwitterResponceState.Success(statusCode))
            }
        }
    }
}
