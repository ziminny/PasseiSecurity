//
//  HCURLSessionLoadCertificate.swift
//  PasseiHTTPCertificate
//
//  Created by vagner reis on 17/10/24.
//

import Foundation

public struct HCURLSessionLoadCertificate {
    
    private let keychain: HCKeychain
    
    public init(keychain: HCKeychain) {
        self.keychain = keychain
    }

    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        
        // Validar o servidor (Server Trust)
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // Autenticar o certificado do servidor (Server Trust)
        let serverCredential = URLCredential(trust: serverTrust)
        
        // Tentar carregar o certificado do cliente a partir do Keychain
        if let identity = keychain.loadClientIdentity() {
            let urlCredential = URLCredential(identity: identity as! SecIdentity, certificates: nil, persistence: .forSession)
            // Use as credenciais do cliente
            completionHandler(.useCredential, urlCredential)
        } else {
            // Use as credenciais do servidor, caso o cliente não tenha um certificado
            completionHandler(.useCredential, serverCredential)
        }
    }
    
}
