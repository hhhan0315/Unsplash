//
//  NetworkService.swift
//  Unsplash
//
//  Created by rae on 2022/05/02.
//

import Foundation

enum NetworkError: Error {
    case transportError(Error)
    case serverError(_ statusCode: Int)
    case noData
}

struct NetworkService {
    func request(_ urlRequest: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               !(200..<300).contains(response.statusCode) {
                completion(.failure(.serverError(response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
