//
//  ViewController.swift
//  PasseiHTTPCertificate
//
//  Created by Vagner Reis on 10/17/2024.
//  Copyright (c) 2024 Vagner Reis. All rights reserved.
//

import UIKit
import Foundation
import PasseiSecurity

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let session = Session()
        session.get()
    }
}

class Session: NSObject, URLSessionDelegate {
    
    let certificate: PSURLSessionLoadCertificate
    
    override init() {
        URLCache.shared.removeAllCachedResponses()

        certificate = PSURLSessionLoadCertificate(keychain: PSKeychainCertificateHandler())
        super.init()
    }
    
    var session: URLSession {
        
        let configuration = URLSessionConfiguration.default
        
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        
    }
    
    func get() {
        let baseURL = "https://development.passeioab.grupopassei.com/api/v1/auth/test"
        
        session.dataTask(with: URL(string: baseURL)!) { data, response, error in
            if let error {
                print("ERRO AQUI \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("RESPONDE STATUS CODE \(response.statusCode)")
            }
            
        }.resume()
    }
    
    public func urlSession(_: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print(challenge.protectionSpace.authenticationMethod)
        do {
            try certificate.urlSession(session, didReceive: challenge, completionHandler: completionHandler)
        } catch {
            print("ERRROOO: \(error)")
        }
        
    }
    
}

