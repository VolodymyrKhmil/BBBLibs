import Foundation

enum CryptoAlgorithm {
    case md5, sha1, sha224, sha256, sha384, sha512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .md5:      result = kCCHmacAlgMD5
        case .sha1:     result = kCCHmacAlgSHA1
        case .sha224:   result = kCCHmacAlgSHA224
        case .sha256:   result = kCCHmacAlgSHA256
        case .sha384:   result = kCCHmacAlgSHA384
        case .sha512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .md5:      result = CC_MD5_DIGEST_LENGTH
        case .sha1:     result = CC_SHA1_DIGEST_LENGTH
        case .sha224:   result = CC_SHA224_DIGEST_LENGTH
        case .sha256:   result = CC_SHA256_DIGEST_LENGTH
        case .sha384:   result = CC_SHA384_DIGEST_LENGTH
        case .sha512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension Dictionary where Key == String {
    func signed(algorithm: CryptoAlgorithm, secret: String) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self), let json = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return json.hmac(algorithm: .sha1, key: secret)
    }
}

extension String {
    
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str         = self.cString(using: String.Encoding.utf8)
        let strLen      = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen   = algorithm.digestLength
        let result      = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr      = key.cString(using: String.Encoding.utf8)
        let keyLen      = Int(key.lengthOfBytes(using: String.Encoding.utf8))
        
        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
        
        let digest = stringFromResult(result: result, length: digestLen)
        
        result.deallocate(capacity: digestLen)
        
        return digest
    }
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
    
}
