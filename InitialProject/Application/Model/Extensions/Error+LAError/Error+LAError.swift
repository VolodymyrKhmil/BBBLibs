import Foundation

extension Error {
    var laError: LAError {
        return LAError.custom(error: self, statusCode: nil).log()
    }
}
