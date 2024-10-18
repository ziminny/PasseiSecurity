//
//  HCKeychain.swift
//  PasseiHTTPCertificate
//
//  Created by vagner reis on 17/10/24.
//

import Foundation
import Security

public class HCKeychain {
    
    private(set) var keychainLabel: String
    private let p12CertificateURL: URL
    
    public init(keychainLabel: String, p12CertificateURL: URL) {
        self.keychainLabel = keychainLabel
        self.p12CertificateURL = p12CertificateURL
    }

    public func importP12Certificate() -> SecIdentity? {
        
        // Caso ja exista nem tenta salvar novamente
        // Comentei pois pode dar problema quando expirar
        //guard loadClientIdentity() == nil else {
          //  return nil
        //}
         
        guard let p12Data = try? Data(contentsOf: p12CertificateURL) else {
            print("Erro ao converter para data")
            return nil
        }

        let options: [String: Any] = [
            kSecImportExportPassphrase as String: "1234"
        ]

        var items: CFArray?
        let securityError = SecPKCS12Import(p12Data as NSData, options as NSDictionary, &items)
        
        guard securityError == errSecSuccess else {
            print("Erro ao importar o arquivo P12: \(securityError)")
            return nil
        }

        // Recuperar o primeiro item da lista (que deve ser o certificado e chave privada)
        guard let item = (items as? [[String: Any]])?.first else {
            print("Nenhum item encontrado no arquivo P12")
            return nil
        }

        // Recuperar a identidade (contendo o certificado e a chave privada)
        let identity = item[kSecImportItemIdentity as String] as! SecIdentity

        // Opcionalmente, você pode recuperar o certificado também
        if let cert = item[kSecImportItemCertChain as String] as? [SecCertificate] {
            print("Certificado: \(cert)")
        }

        return identity
    }
    
    public func saveIdentityToKeychain(identity: SecIdentity) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassIdentity,
            kSecAttrLabel as String: keychainLabel, // Um rótulo para identificar a chave no Keychain
            kSecValueRef as String: identity
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Identidade salva com sucesso no Keychain")
            return true
        } else if status == errSecDuplicateItem {
            print("Item já existe no Keychain")
            return true
        } else {
            print("Erro ao salvar identidade no Keychain: \(status)")
            return false
        }
    }
    
    public func loadClientIdentity() -> CFTypeRef? {
        var identity: CFTypeRef?
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassIdentity,
            kSecAttrLabel as String: keychainLabel, // O rótulo que você usou ao salvar
            kSecReturnRef as String: true
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, &identity)
        if status == errSecSuccess {
            return identity
        } else {
            print("Erro ao carregar a identidade do cliente: \(status)")
            return nil
        }
    }

}
