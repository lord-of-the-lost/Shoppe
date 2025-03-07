//
//  NetworkService.swift
//  Shoppe
//
//  Created by Николай Игнатов on 06.03.2025.
//

import UIKit

// MARK: - NetworkServiceProtocol
protocol NetworkServiceProtocol {
    func fetchAllProducts(completion: @escaping (Result<[ProductModel], NetworkError>) -> Void)
    func fetchProduct(id: Int, completion: @escaping (Result<ProductModel, NetworkError>) -> Void)
    func loadImage(from urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void)
}

// MARK: - NetworkError
enum NetworkError: Error {
    case badURL, requestFailed, badResponse, invalidData, decodeError
}

// MARK: - NetworkService
final class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://fakestoreapi.com/products"
    
    /// Получить все продукты
    func fetchAllProducts(completion: @escaping (Result<[ProductModel], NetworkError>) -> Void) {
        performRequest(urlString: baseURL, completion: completion)
    }
    
    /// Получить продукт по ID
    func fetchProduct(id: Int, completion: @escaping (Result<ProductModel, NetworkError>) -> Void) {
        let urlString = "\(baseURL)/\(id)"
        performRequest(urlString: urlString, completion: completion)
    }
    
    /// Добавить новый продукт
    func addProduct(_ product: ProductModel, completion: @escaping (Result<ProductModel, NetworkError>) -> Void) {
        performRequest(urlString: baseURL, method: "POST", body: product, completion: completion)
    }
    
    /// Обновить продукт
    func updateProduct(_ product: ProductModel, completion: @escaping (Result<ProductModel, NetworkError>) -> Void) {
        let urlString = "\(baseURL)/\(product.id)"
        performRequest(urlString: urlString, method: "PUT", body: product, completion: completion)
    }
    
    /// Удалить продукт
    func deleteProduct(id: Int, completion: @escaping (Result<ProductModel, NetworkError>) -> Void) {
        let urlString = "\(baseURL)/\(id)"
        performRequest(urlString: urlString, method: "DELETE", completion: completion)
    }
    
    /// Загрузка картинки
    func loadImage(from urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
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

// MARK: Private Methods
private extension NetworkService {
    func performRequest<T: Codable>(
        urlString: String,
        method: String = "GET",
        body: Codable? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async { completion(.failure(.badURL)) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                DispatchQueue.main.async { completion(.failure(.requestFailed)) }
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if error != nil {
                DispatchQueue.main.async { completion(.failure(.requestFailed)) }
                return
            }
            
            guard let data else {
                DispatchQueue.main.async { completion(.failure(.invalidData)) }
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { completion(.success(decodedData)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(.decodeError)) }
            }
        }.resume()
    }
}

