//
//  InstagramKitService.swift
//  jigit
//
//  Created by Orion on 8/19/15.
//  Copyright (c) 2015 dominik. All rights reserved.
//

import InstagramKit

class InstagramKitService: InstagramServiceProtocol
{
    //MARK: private enum constants
    
    private enum Keys: String
    {
        case me = "self"
        
        var description: String {
            return self.rawValue
        }
    }
    
    //MARK: private veriables
    
    private lazy var _instagramEngine = InstagramEngine.sharedEngine()
    
    //MARK: InstagramServiceProtocol methods
    
    func tokenGranted() -> Bool
    {
        return !self._instagramEngine.accessToken.isEmpty
    }
    
    func setAccessTokenFromUrl(url: NSURL!, error: NSErrorPointer) -> Bool
    {
        return self._instagramEngine.extractValidAccessTokenFromURL(url, error: error)
    }
    
    func getOAuthUrl(scope: InstagramKitLoginScope, _ responce: (url: NSURL, InstagramResponceState) -> Void)
    {
        responce(url: self._instagramEngine.authorizarionURLForScope(scope), InstagramStatusCodes.ValidStatus.state)
    }
    
    func getFollowers(id: String?, responce: ([InstagramUser]?, InstagramResponceState) -> Void)
    {
        self._instagramEngine.getFollowersOfUser((id != nil) ? id : Keys.me.description, withSuccess: { (objects, _) -> Void in
            let changedObjects = objects as? [InstagramUser]
            responce(changedObjects, (changedObjects != nil) ? InstagramStatusCodes.ValidStatus.state : InstagramResponceState.Fail(InstagramStatusCodes.ConvertionFailed.description))
        }) { (_, erroreCode) -> Void in
            responce(nil, InstagramResponceState.Fail(erroreCode))
        }
    }
    
    func getFollowedBy(id: String?, responce: ([InstagramUser]?, InstagramResponceState) -> Void)
    {
        self._instagramEngine.getUsersFollowedByUser((id != nil) ? id : Keys.me.description, withSuccess: { (objects, _) -> Void in
            let changedObjects = objects as? [InstagramUser]
            responce(changedObjects, (changedObjects != nil) ? InstagramStatusCodes.ValidStatus.state : InstagramResponceState.Fail(InstagramStatusCodes.ConvertionFailed.description))
            }) { (_, erroreCode) -> Void in
                responce(nil, InstagramResponceState.Fail(erroreCode))
        }

    }
    
    func postToInstagram(data: InstagramData, _ responce: ((InstagramResponceState) -> Void)?)
    {
        
    }
}
