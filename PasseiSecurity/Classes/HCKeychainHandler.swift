//
//  HCKeychainHandler.swift
//  PasseiHTTPCertificate
//
//  Created by vagner reis on 26/10/24.
//

import Foundation
import Security

public typealias KeychainModel = Decodable & Encodable & Sendable

/// Gerenciador de acesso ao Keychain para armazenamento seguro de dados genéricos.
public struct HCKeychainHandler<T: KeychainModel> {
    
    /// Possíveis erros que podem ocorrer durante as operações do Keychain.
    public enum Error: Swift.Error {
        case errorSaved(Int32)
        case errorUpdate(Int32)
        case errorDelete(Int32)
        case errorGet(Int32)
    }
    
    /// Tag usada para identificar o item no Keychain.
    let tag: Data
    
    /// Inicializador padrão que usa o tipo genérico como tag.
    public init() {
        self.tag = "\(T.self)".data(using: .utf8)!
    }
    
    /// Atualiza o item no Keychain com novos dados.
    private func update(data: Data) throws -> [CFString: Data] {
        let updatedItem = [kSecValueData: data]
        return updatedItem
    }
    
    /// Cria a query para adicionar um item no Keychain.
    private func createQuery(value: Data) -> [String: Any] {
        let addQuery: [String: Any] = [
            String(kSecClass): kSecClassKey,
            String(kSecAttrApplicationTag): tag,
            String(kSecValueData): value
        ]
        return addQuery
    }
    
    /// Cria um novo item no Keychain.
    public func create(value: T) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        let addQuery = self.createQuery(value: data)
        let updatedItem = try self.update(data: data)
        
        // Salvando no Keychain
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            let result: OSStatus = SecItemUpdate(addQuery as CFDictionary, updatedItem as CFDictionary)
            guard result == errSecSuccess else { throw Error.errorSaved(result) }
            return
        }
        
        guard status == errSecSuccess else { throw Error.errorSaved(status) }
    }
    
    /// Obtém um item do Keychain.
    public func get() throws -> T? {
        let getQuery: [String: Any] = [
            String(kSecClass): kSecClassKey,
            String(kSecAttrApplicationTag): tag,
            String(kSecReturnData): true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getQuery as CFDictionary, &item)
        guard status == errSecSuccess else { throw Error.errorGet(status) }
        
        guard let keyData = item as? Data else { return nil }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(T.self, from: keyData)
        return result
    }
    
    public func delete() throws {
        
        let deleteQuery: [String:Any] = [
            String(kSecClass): kSecClassKey,
            String(kSecAttrApplicationTag): tag
        ]
        
        let status = SecItemDelete(deleteQuery as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw Error.errorDelete(status)
        }
        
    }
}



