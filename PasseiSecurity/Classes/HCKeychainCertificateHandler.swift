//
//  HCKeychainCertificateHandler.swift
//  PasseiHTTPCertificate
//
//  Created by vagner reis on 17/10/24.
//

import Foundation
import Security
import CoreFoundation

public struct HCKeychainCertificateHandler: Sendable {
    
    public init() { }
    
    private func importP12Certificate() throws -> SecIdentity {
        
        guard let p12CertificateURL = HCKeychainProperties.shared.p12CertificateURL else {
            throw HCError.urlError
        }
        
       guard let p12Data = try? Data(contentsOf: p12CertificateURL) else {
           throw HCError.dataError
         }
        
        let options: [String: Any] = [
            kSecImportExportPassphrase as String: HCKeychainProperties.shared.p12Password
        ]
        
        var items: CFArray?
        let securityError = SecPKCS12Import(p12Data as NSData, options as NSDictionary, &items)
        
        guard securityError == errSecSuccess else {
            throw HCError.importError
        }
        
        // Recuperar o primeiro item da lista (que deve ser o certificado e chave privada)
        guard let item = (items as? [[String: Any]])?.first else {
            throw HCError.itemNotFound
        }
        
        // Recuperar a identidade (contendo o certificado e a chave privada)
        let identity = item[kSecImportItemIdentity as String] as! SecIdentity
        
        // Opcionalmente, pode recuperar o certificado também
        if let _ /* certificates */ = item[kSecImportItemCertChain as String] as? [SecCertificate] {
            
        }
        
        return identity
    }
    
    @discardableResult
    public func saveIdentityToKeychain() throws -> Bool {
        
        let identity = try importP12Certificate()
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassIdentity,
            kSecAttrLabel as String: HCKeychainProperties.shared.keychainLabel,
            kSecValueRef as String: identity
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Identidade salva com sucesso no Keychain")
            return true
        } else if status == errSecDuplicateItem {
            print("Item já existe no Keychain")
            return true
        }
        
        throw HCError.errorIdentitySave(status)
        
    }
    
    public func renewCertificate() throws {
        if removeIdentityFromKeychain() || !identityExistsInKeychain() {
            try saveIdentityToKeychain()
        }
    }
    
    public func removeIdentityFromKeychain() -> Bool {
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassIdentity,  // Classe de identidade
            kSecAttrLabel as String: HCKeychainProperties.shared.keychainLabel   // Rótulo usado ao salvar o item
        ]
        
        let status = SecItemDelete(deleteQuery as CFDictionary)
        
        if status == errSecSuccess {
            print("Item removido com sucesso.")
            return true
        } else if status == errSecItemNotFound {
            print("Item não encontrado no Keychain.")
            return false
        } else {
            print("Erro ao tentar remover item: \(status)")
            return false
        }
    }
    
    public func loadClientIdentity() throws -> CFTypeRef? {
        
        var identity: CFTypeRef?
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassIdentity,
            kSecAttrLabel as String: HCKeychainProperties.shared.keychainLabel,
            kSecReturnRef as String: true
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, &identity)
        if status == errSecSuccess {
            return identity
        }
        print("STATUS \(status)")
        throw HCError.errorLoadIdentity(status)
        
    }

    public func identityExistsInKeychain() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassIdentity,  // Tipo de item: identidade
            kSecAttrLabel as String: HCKeychainProperties.shared.keychainLabel,          // Rótulo usado ao salvar a identidade
            kSecReturnRef as String: true,           // Retornar uma referência ao item (não os dados)
            kSecMatchLimit as String: kSecMatchLimitOne  // Limitar a busca a um único item
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        return status == errSecSuccess
    }

 
    func load() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassIdentity,
            kSecReturnAttributes as String: true,
            kSecMatchLimit as String: kSecMatchLimitAll
        ]
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        print("Status de listagem: \(status)")
        print("Resultados: \(String(describing: result))")
    }
    
    
}
