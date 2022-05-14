//
//  NetworkService.swift
//  Unsplash
//
//  Created by rae on 2022/05/12.
//

import Foundation

enum NetworkError: Error {
    case invalidURLError
    case serverError(_ statusCode: Int)
    case noData
    case decodeError
    case unknownError
}

protocol Networkable {
    func request<Request: DataRequestable>(_ request: Request, completion: @escaping (Result<Request.Response, NetworkError>) -> Void)
}

class NetworkService: Networkable {
    func request<Request: DataRequestable>(_ request: Request, completion: @escaping (Result<Request.Response, NetworkError>) -> Void) {
        
        guard var urlComponent = URLComponents(string: request.url) else {
            completion(.failure(.invalidURLError))
            return
        }
        
        urlComponent.queryItems = request.queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponent.url else {
            completion(.failure(.invalidURLError))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknownError))
                return
            }
            
            if error != nil {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                try completion(.success(request.decode(data)))
            } catch {
                completion(.failure(.decodeError))
            }
        }.resume()
    }
}
