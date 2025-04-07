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
    func loadImage(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

// MARK: - NetworkError
enum NetworkError: Error {
    case badURL, requestFailed, requestBodyFailed, badResponse, invalidData, decodeError
}

// MARK: - HTTPMethods
enum HTTPMethods: String {
    case GET, POST, PUT, DELETE
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
        performRequest(urlString: baseURL, method: .POST, body: product, completion: completion)
    }
    
    /// Обновить продукт
    func updateProduct(_ product: ProductModel, completion: @escaping (Result<ProductModel, NetworkError>) -> Void) {
        let urlString = "\(baseURL)/\(product.id)"
        performRequest(urlString: urlString, method: .PUT, body: product, completion: completion)
    }
    
    /// Удалить продукт
    func deleteProduct(id: Int, completion: @escaping (Result<ProductModel, NetworkError>) -> Void) {
        let urlString = "\(baseURL)/\(id)"
        performRequest(urlString: urlString, method: .DELETE, completion: completion)
    }
    
    /// Загрузка картинки
    func loadImage(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        performDataRequest(urlString: urlString) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Private Methods
private extension NetworkService {
    func performDataRequest(
        urlString: String,
        method: HTTPMethods = .GET,
        body: Codable? = nil,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async { completion(.failure(.badURL)) }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            if let body {
                request.httpBody = try JSONEncoder().encode(body)
            }
        } catch {
            DispatchQueue.main.async { completion(.failure(.requestBodyFailed)) }
            return
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
            
            DispatchQueue.main.async { completion(.success(data)) }
        }.resume()
    }
    
    func performRequest<T: Codable>(
        urlString: String,
        method: HTTPMethods = .GET,
        body: Codable? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        performDataRequest(urlString: urlString, method: method, body: body) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
