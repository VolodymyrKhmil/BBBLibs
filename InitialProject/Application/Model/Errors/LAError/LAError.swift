//
//  GoodCardsErrors.swift
//  GoodCards
//
//  Created by volodymyrkhmil on 11/1/16.
//  Copyright © 2016 GoodCards. All rights reserved.
//
import Crashlytics
import JHTAlertController

//TODO: Lowerise text errors with patters errors.
enum LAError: ErrorProtocol {
    
    case custom(error: Error, statusCode: Int?)
    case error(description: String, statusCode: Int)
    case texted(text: String)
    case internetConnection
    case versionUncheckable
    case somethingWentWrong
    
    //MARK: BDKError
    
    var statusCode: Int {
        switch self {
        case .custom(_, let statusCode):
            return statusCode ?? 0
        case .error(_, let statusCode):
            return statusCode
        case .internetConnection:
            return 1
        case .somethingWentWrong:
            return 2
        default:
            return -1
        }
    }
    
    var description: String {
        switch self {
        case .custom(let error, _):
            return error.localizedDescription
        case .internetConnection:
            return "There was an error connecting to userfeel.com. Please check your Internet connection or try again later."
        case .somethingWentWrong:
            return "Something went wrong. Please try again later."
        case .versionUncheckable:
            return "Can't check version of application. Please try again later."
        case .texted(let text):
            return text
        case .error(let description, _):
            return description
        }
    }
    
//    func alert(action: ((JHTAlertAction) -> Void)? = nil) -> JHTAlertController {
//        let alertController = JHTAlertController(title: "Error",
//                                                 message: self.description,
//                                                 preferredStyle: .alert,
//                                                 iconImage: nil)
//        let okAction = JHTAlertAction(title: "OK", style: .cancel,  handler: action)
//        alertController.addAction(okAction)
//        
//        return alertController
//    }
}
