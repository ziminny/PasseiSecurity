//
//  PSKeychainProperties.swift
//  PasseiHTTPCertificate
//
//  Created by vagner reis on 26/10/24.
//

import Foundation

public struct PSKeychainProperties {
    
    nonisolated(unsafe) public static var shared = PSKeychainProperties()
    
    public var keychainLabel: String = ""
    public var p12CertificateURL: URL?
    public var p12Password: String = ""
    
    public var securitySharedPasswordEncryptionMTSLPassword: String?
    
}

