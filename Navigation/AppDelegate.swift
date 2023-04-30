//
//  AppDelegate.swift
//  Navigation
//
//  Created by Евгений Дроздов on 06.07.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        func getKey() -> Data {
            // зададим уникальное имя для связки ключей
            let keychainIdentifier = "io.Realm.EncryptionExampleKey"
            let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            // есть ли ключ уже в связке ключей
            var query: [NSString: AnyObject] = [
                kSecClass: kSecClassKey,
                kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
                kSecAttrKeySizeInBits: 512 as AnyObject,
                kSecReturnData: true as AnyObject
            ]
            
            var dataTypeRef: AnyObject?
            var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
            if status == errSecSuccess {
                return dataTypeRef as! Data
            }
            
            var key = Data(count: 64)
            key.withUnsafeMutableBytes({ (pointer: UnsafeMutableRawBufferPointer) in
                let result = SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
                assert(result == 0, "Failed to get random bytes")
            })
            
            // сохраним ключ в связку ключей
            query = [
                kSecClass: kSecClassKey,
                kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
                kSecAttrKeySizeInBits: 512 as AnyObject,
                kSecValueData: key as AnyObject
            ]
            
            status = SecItemAdd(query as CFDictionary, nil)
            assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
            
            return key
        }
        
        var config = Realm.Configuration(encryptionKey: getKey())
        
        // Realm обновление версии
        // если изменяем какие-то данные в таблице, то тут надо цифру +1 сделать
        config.schemaVersion = 1
        Realm.Configuration.defaultConfiguration = config
        
        // тут сразу проверим доступность с этим ключом, если нет, то кинем приложение
        do {
            let realm = try Realm(configuration: config)
        } catch let error as NSError {
            fatalError("Error opening realm: \(error)")
        }
        
        // путь папки на устройстве -
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

