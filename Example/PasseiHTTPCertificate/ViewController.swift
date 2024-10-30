//
//  ViewController.swift
//  PasseiHTTPCertificate
//
//  Created by Vagner Reis on 10/17/2024.
//  Copyright (c) 2024 Vagner Reis. All rights reserved.
//

import UIKit
import Foundation
import CryptoKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //let inputData = "Sensitive data".data(using: .utf8)!
        // let key = SymmetricKey(size: .bits256)
        //  let encryptedData = try! encryptData(data: inputData, key: key)
        // let decryptedData = try! decryptData(ciphertext: encryptedData, key: key)
        // let decryptedString = String(data: decryptedData, encoding: .utf8)
        // print(decryptedString ?? "") // Output: Sensitive data
        
        let complete = Data(base64Encoded: "JROW1UnmbrpmiOCLwQPQwLRMrAuad2hGXBoD+HMWeRrt5C0rpJ5TjYpsKiAttx6UxQtZ292nTZYTGWYX/TcOxUAIkVoP")!
        
        // Valores fornecidos
        let keyBase64 = "jIU/7F1+ax97/EJ/5qj1v9N1BnYBjuvaHf8CwDUpy4M="
        
        let ivBase64 = complete[0..<12]
        let encryptedBase64 = complete[12..<(complete.count - 16)]
        let tag = complete[(complete.count - 16)...]
        
        print("IVV \(encryptedBase64.base64EncodedString())")

        // 1. Convertendo a chave para Data e criando o SymmetricKey
        guard let keyData = Data(base64Encoded: keyBase64) else {
            fatalError("Erro ao decodificar a chave")
        }
        let symmetricKey = SymmetricKey(data: keyData)

        // 2. Convertendo o IV (nonce) para Data e criando o Nonce
        guard ivBase64.count == 12 else {
            fatalError("Erro ao decodificar ou IV inválido")
        }
        let nonce = try! AES.GCM.Nonce(data: ivBase64)

         
         

        // 4. Criando o SealedBox e tentando a descriptografia
        do {
            let sealedBox = try AES.GCM.SealedBox(nonce: nonce, ciphertext: encryptedBase64, tag: tag)
            let decryptedData = try AES.GCM.open(sealedBox, using: symmetricKey)
            let decryptedMessage = String(data: decryptedData, encoding: .utf8)!
            print("Mensagem descriptografada: \(decryptedMessage)")
        } catch {
            print("Erro na descriptografia: \(error)")
        }
        
        //test()
   
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func test() {
        let keyBase64 = "jIU/7F1+ax97/EJ/5qj1v9N1BnYBjuvaHf8CwDUpy4M="
        let nonce = AES.GCM.Nonce()
        let message = "Texto para criptografar no Swift Vagner test"
        
        // 1. Convertendo a chave para Data e criando o SymmetricKey
        guard let keyData = Data(base64Encoded: keyBase64) else {
            fatalError("Erro ao decodificar a chave")
        }
        
        let symmetricKey = SymmetricKey(data: keyData)

        // 3. Convertendo a mensagem para Data
        guard let messageData = message.data(using: .utf8) else {
            fatalError("Erro ao converter a mensagem para Data")
        }

        // 4. Criptografando a mensagem
        do {
            let sealedBox = try AES.GCM.seal(messageData, using: symmetricKey, nonce: nonce)
            
            // Obter o IV, AuthTag e Ciphertext como base64
            let ciphertext = sealedBox.ciphertext.base64EncodedString()
            let authTag = sealedBox.tag.base64EncodedString()
            let iv = nonce.withUnsafeBytes { Data(Array($0)).base64EncodedString() }
            
            print("IV: \(iv)")
            print("AuthTag: \(authTag)")
            print("Ciphertext: \(ciphertext)")
            
            // Para obter a mensagem combinada
            if let combined = sealedBox.combined {
                print("Encrypted (IV + AuthTag + Ciphertext): \(combined.base64EncodedString())")
            }
            
            let ivData = nonce.withUnsafeBytes { Data(Array($0)) }
            let authTagData = sealedBox.tag
            let ciphertextData = sealedBox.ciphertext
            let manualConcatenation = ivData + ciphertextData + authTagData
            print("Manual concatenation (IV + Ciphertext + AuthTag): \(manualConcatenation.base64EncodedString())")
            
        } catch {
            print("Erro ao criptografar: \(error)")
        }
    }

    
}

func encryptData(data: Data, key: SymmetricKey) throws -> Data {
    let sealedBox = try AES.GCM.seal(data, using: key)
    return sealedBox.combined!
}

func decryptData(ciphertext: Data, key: SymmetricKey) throws -> Data {
    let sealedBox = try AES.GCM.SealedBox(combined: ciphertext)
    return try AES.GCM.open(sealedBox, using: key)
}

func decryptData2(ciphertext: Data) -> Data?  {
    
    do {
        let keyBase64 = "aW1SRLGDOsnjkOnXreYAN0esVQ3snLRHglznbSSI3EY="
        if let keyData = Data(base64Encoded: keyBase64) {
            let symmetricKey = SymmetricKey(data: keyData)
            let nonce = try AES.GCM.Nonce(data: ciphertext[0 ..< 16])
            let message = ciphertext[16 ..< ciphertext.count - 16]
            let tag = ciphertext[ciphertext.count - 16 ..< ciphertext.count]
            
            let sb = try AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
            return  try AES.GCM.open(sb, using: symmetricKey)
            
            
        }
        return nil
    } catch {
        print("Error: \(error)")
        return nil
        
    }
}


