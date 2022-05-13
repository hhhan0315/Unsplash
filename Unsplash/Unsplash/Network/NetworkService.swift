//
//  NetworkService.swift
//  Unsplash
//
//  Created by rae on 2022/05/12.
//

import Foundation

protocol Networkable {
    func request<Request: DataRequestable>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void)
}

class NetworkService: Networkable {
    func request<Request: DataRequestable>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
        
        guard var urlComponent = URLComponents(string: request.url) else {
            let error = NSError(domain: ErrorResponse.invalidEndpoint.rawValue, code: 404)
            return completion(.failure(error))
        }
        
        urlComponent.queryItems = request.queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponent.url else {
            let error = NSError(domain: ErrorResponse.invalidEndpoint.rawValue, code: 404)
            return completion(.failure(error))
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse,
                  200..<300 ~= response.statusCode else {
                return completion(.failure(NSError()))
            }
            
            guard let data = data else {
                return completion(.failure(NSError()))
            }
            
            do {
                try completion(.success(request.decode(data)))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }.resume()
    }
}
