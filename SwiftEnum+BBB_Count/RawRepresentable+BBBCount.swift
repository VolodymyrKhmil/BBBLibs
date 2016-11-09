import Foundation

extension RawRepresentable {
    static func BBB_count() -> Int {
        var count = 1
        while (withUnsafePointer(&count) { UnsafePointer<Type>($0).memory }).hashValue != 0 {
            count += 1
        }
        return count
    }
}
