//
//  NetworkService.swift
//  Shoppe
//
//  Created by Николай Игнатов on 06.03.2025.
//

import UIKit

// MARK: - NetworkServiceProtocol
protocol NetworkServiceProtocol {
    func loadImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

// MARK: - NetworkError
enum NetworkError: Error {
    case badURL, badResponse, invalidData, decodeError
}

// MARK: - NetworkService
final class NetworkService: NetworkServiceProtocol {
    func loadImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let _ = error {
                completion(.failure(NetworkError.badResponse))
                return
            }
            
            guard let data, let image = UIImage(data: data) else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            completion(.success(image))
        }.resume()
    }
}
