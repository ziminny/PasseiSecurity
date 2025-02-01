
# 🔐 PasseiSecurity

[![CI Status](https://img.shields.io/travis/Vagner%20Reis/PasseiSecurity.svg?style=flat)](https://travis-ci.org/Vagner%20Reis/PasseiSecurity)
[![Version](https://img.shields.io/cocoapods/v/PasseiSecurity.svg?style=flat)](https://cocoapods.org/pods/PasseiSecurity)
[![License](https://img.shields.io/cocoapods/l/PasseiSecurity.svg?style=flat)](https://cocoapods.org/pods/PasseiSecurity)
[![Platform](https://img.shields.io/cocoapods/p/PasseiSecurity.svg?style=flat)](https://cocoapods.org/pods/PasseiSecurity)

O **PasseiSecurity** é uma biblioteca em Swift projetada para gerenciar e injetar certificados de segurança, integrando-se ao projeto `PasseiNetworking` para fornecer conexão segura via TLS/SSL.

---

## **Descrição**

Esta biblioteca é responsável por:

- Gerenciar a inserção de certificados digitais em requisições HTTP.
- Suportar múltiplos certificados.
- Validar conexões seguras utilizando `Certificate Pinning`.

---

## **Requisitos**

- **Swift**: 6.0 ou superior
- **PasseiNetworking**: Dependência necessária para integração de requisições.

---

## **Instalação**

### **Usando CocoaPods**

Adicione a seguinte linha ao seu arquivo `Podfile`:

```ruby
pod 'PasseiSecurity'
```

Em seguida, execute o comando:

```bash
pod install
```

---

## **Configuração Inicial**

1. **Configure os certificados**:

   ```swift
   import PasseiSecurity

   let certificateHandler = PSKeychainCertificateHandler()
   certificateHandler.loadCertificates(["certificate1", "certificate2"])
   ```

2. **Integre com `PasseiNetworking`**:

   ```swift
   apiService.security(certificateHandler)
   ```

3. **Gerenciamento via Keychain**:

   Utilize o `PSKeychainHandler` para armazenar ou recuperar certificados diretamente.

---

## **Uso Básico**

### **1. Injetando Certificados em Requisições**

```swift
let certificateHandler = PSKeychainCertificateHandler()
certificateHandler.loadCertificates(["myCert.pem"])

let apiService = NSAPIService()
apiService.security(certificateHandler)
```

### **2. Validando Conexões Seguras**

```swift
let isValid = certificateHandler.validateCertificate("myCert.pem")
print("Certificado válido:", isValid)
```

---

## **Funcionalidades Avançadas**

### **1. Integração com Keychain**

Armazene certificados no Keychain para maior segurança:

```swift
let keychainHandler = PSKeychainHandler()
keychainHandler.saveCertificate("myCert.pem", forKey: "secureCert")
```

### **2. Certificado Expirado**

A biblioteca pode notificar o usuário sobre certificados expirados:

```swift
if certificateHandler.isCertificateExpired("myCert.pem") {
    print("Certificado expirado.")
}
```

### **3. Requisições Seguras**

Ao usar o `PasseiNetworking`, as conexões serão validadas automaticamente contra os certificados carregados.

---

## **Exemplo Completo**

```swift
class SecureService {
    
    let apiService: NSAPIService
    let certificateHandler: PSKeychainCertificateHandler

    init() {
        apiService = NSAPIService()
        certificateHandler = PSKeychainCertificateHandler()
        certificateHandler.loadCertificates(["cert1", "cert2"])
        apiService.security(certificateHandler)
    }

    func performSecureRequest() async throws {
        let nsParameters = NSParameters(method: .GET, path: .secureData)
        let response = try await apiService.fetchAsync(SecureResponse.self, nsParameters: nsParameters)
        print("Dados recebidos:", response)
    }
}
```

---

## **Contribuição**

Contribuições são bem-vindas! Siga os passos abaixo para colaborar:

1. Faça um fork do projeto.
2. Crie uma branch para suas alterações (`git checkout -b minha-feature`).
3. Faça commit das alterações (`git commit -m 'Minha nova feature'`).
4. Envie as alterações para o seu fork (`git push origin minha-feature`).
5. Abra um Pull Request para revisão.

---

## **Licença**

PasseiSecurity está disponível sob a licença **MIT**. Consulte o arquivo `LICENSE` para mais informações.

---

## **Autores**

- **Vagner Oliveira**  
  E-mail: ziminny@gmail.com

---

## **Recursos úteis**

- [Swift.org](https://swift.org)
- [Documentação CocoaPods](https://guides.cocoapods.org/)
