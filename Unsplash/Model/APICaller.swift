//
//  APICaller.swift
//  Unsplash
//
//  Created by rae on 2022/09/08.
//

import Foundation

enum APICallError: Error {
    case URLError
    case NoData
    case ServerError(_ statusCode: Int)
    case UnknownError
    case DecodeError
}

final class APICaller {
    func request(api: API, completion: @escaping (Result<Data, APICallError>) -> Void) {
        guard var urlComponents = URLComponents(string: api.baseURL + api.path) else {
            completion(.failure(.URLError))
            return
        }
        
        urlComponents.queryItems = api.query.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else {
            completion(.failure(.URLError))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method.rawValue
        urlRequest.allHTTPHeaderFields = api.header
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.UnknownError))
                return
            }
            
            if error != nil {
                completion(.failure(.ServerError(httpResponse.statusCode)))
                return
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.ServerError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.NoData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
