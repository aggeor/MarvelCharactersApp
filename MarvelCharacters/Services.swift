//
//  Services.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 13/5/24.
//

import Foundation
import CryptoKit

/// Get the endpoint url used to fetch the data
func getEndpointUrl() -> String{
    return "https://gateway.marvel.com"
}

/// Get the MD5 hash of the combined credentials used on the endpoint requests
func getMD5Hash() -> String{
    return getCombinedCredentials().MD5
}

/// Get the combined credentials for the endpoint requests and return them as a single `String`.
///
/// The credentials should be appended in the order: timestamp->privateKey->publicKey
///
/// timestamp: the current timestamp that the endpoint fetches any data
///
/// privateKey: the private key provided by Marvel API
///
/// public: the public key provided by Marvel API
///

func getCombinedCredentials() -> String{
    return getTimestamp()+getPrivateKey()+getPublicKey()
}

func getPrivateKey() -> String{
    return "167ca74a669e78571c5eb70e077421815f2f8cbe"
}

func getPublicKey() -> String{
    return "a5756515edff54cf6538f93b5c3844dc"
}

func getTimestamp() -> String{
    return String(Int(Date().timeIntervalSince1970))
}

/// String extension to generate an MD5 hash from a `String`
///
/// Snippet used: [MD5](https://powermanuscript.medium.com/swift-5-2-macos-md5-hash-for-some-simple-use-cases-66be9e274182)
extension String {
var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}
