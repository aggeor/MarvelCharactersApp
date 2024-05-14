//
//  Services.swift
//  MarvelCharacters
//
//  Created by Aggelos Geo on 13/5/24.
//

import Foundation
import CryptoKit

func getEndpointUrl() -> String{
    return "https://gateway.marvel.com"
}

func getMD5Hash() -> String{
    return getCombinedCredentials().MD5
}

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

extension String {
var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}
