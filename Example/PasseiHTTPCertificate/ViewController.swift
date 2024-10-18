//
//  ViewController.swift
//  PasseiHTTPCertificate
//
//  Created by Vagner Reis on 10/17/2024.
//  Copyright (c) 2024 Vagner Reis. All rights reserved.
//

import UIKit
import PasseiHTTPCertificate

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let url = Bundle.main.url(forResource: "certificate", withExtension: "p12") else {
            print("Erro ao carregar o arquivo P12")
            return
        }
        
        let keychain = HCKeychain()
        let identity = keychain.importP12Certificate(url: url)
        
        print("IDENTITY \(identity)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//https://monkfish-app-uwupe.ondigitalocean.app
//https://monkfish-app-uwupe.ondigitalocean.app/auth/test
//http://localhost:8080/auth/test

