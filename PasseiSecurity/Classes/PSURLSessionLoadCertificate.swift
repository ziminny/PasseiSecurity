//
//  PSURLSessionLoadCertificate.swift
//  PasseiHTTPCertificate
//
//  Created by vagner reis on 17/10/24.
//

import Foundation

public struct PSURLSessionLoadCertificate: Sendable {
    
    private let keychain: PSKeychainCertificateHandler
    
    public init() {
        self.keychain = PSKeychainCertificateHandler()
    }
    
    public func urlSession(_: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) throws {
        
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate
        else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        guard let identity = try keychain.loadClientIdentity() else {
            print("Certificado não encontrado")
            throw PSError.itemNotFound
        }
        
        let credential = URLCredential(identity: identity as! SecIdentity, certificates: nil, persistence: .none)
        
        challenge.sender?.use(credential, for: challenge)
        print("Certificado Enviado")
        completionHandler(.useCredential, credential)
            
    }
}
