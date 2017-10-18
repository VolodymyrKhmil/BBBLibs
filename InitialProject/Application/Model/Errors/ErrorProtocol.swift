import JHTAlertController

import UIKit
import Alamofire

protocol ErrorProtocol: Error {
    var statusCode: Int { get }
    var description: String { get }
    
    func alert(action: UIAlertAction) -> UIAlertController
}

extension ErrorProtocol {
    @discardableResult
    func log(function: String = #function, file: String = #file, line: Int = #line) -> Self {
        return self
    }
}
