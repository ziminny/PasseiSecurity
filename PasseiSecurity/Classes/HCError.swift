//
//  HCError.swift
//  PasseiHTTPCertificate
//
//  Created by vagner reis on 17/10/24.
//

import Foundation
import PasseiLogManager

enum HCError: LocalizedError {
    
    case urlError
    case dataError
    case importError
    case itemNotFound
    case errorLoadIdentity(OSStatus) // Int32
    case errorIdentitySave(OSStatus) // Int32
    
    var errorDescription: String? {
        
        let message: String
        
        defer {
            PLMLogger.logIt(message)
        }
        
        switch self {
        case .urlError:
            message = "Erro na url"
            break
        case .dataError:
            message = "Erro no data"
            break
        case .importError:
            message = "Erro ao importar a keychain"
            break
        case .itemNotFound:
            message = "O item não foi encontrado"
            break
        case .errorLoadIdentity(let oSStatus):
            message = "Erro ao carregar o item \(oSStatus)"
            break
        case .errorIdentitySave(let oSStatus):
            message = "Erro ao salvar a identidade na keychain \(oSStatus)"
            break
        }
        
        return message
        
    }
    
}

