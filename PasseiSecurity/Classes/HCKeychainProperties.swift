//
//  HCKeychainProperties.swift
//  PasseiHTTPCertificate
//
//  Created by vagner reis on 26/10/24.
//

import Foundation

public struct HCKeychainProperties {
    
    nonisolated(unsafe) public static var shared = HCKeychainProperties()
    
    public var keychainLabel: String = ""
    public var p12CertificateURL: URL?
    public var p12Password: String = ""
    
    public var securitySharedPasswordEncryptionMTSLPassword: String?
    
}

