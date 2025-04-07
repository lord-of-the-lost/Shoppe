//
//  UserDefaultsService.swift
//  Shoppe
//
//  Created by Николай Игнатов on 04.03.2025.
//

import Foundation

final class UserDefaultsService {
    
    static let shared = UserDefaultsService()
    private init() {}
    
    enum Keys: String {
       case userModel
    }
    
    // MARK: - Generic Methods
    func set<T>(value: T, forKey key: Keys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func get<T>(forKey key: Keys) -> T? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? T
    }
    
    func removeValue(forKey key: Keys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    //MARK: - Codable Objects
    func saveCustomObject<T: Codable>(_ object: T, forKey key: Keys) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            set(value: encoded, forKey: key)
        }
    }
    
    func getCustomObject<T: Codable>(forKey key: Keys) -> T? {
        guard let data: Data = get(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}
