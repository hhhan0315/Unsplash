//
//  APICaller.swift
//  Unsplash
//
//  Created by rae on 2022/09/08.
//

import Foundation

final class APICaller {
    var urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func request<T: Decodable>(api: API,
                               dataType: T.Type,
                               completion: @escaping (Result<T, APIError>) -> Void) {
        guard var urlComponents = URLComponents(string: api.baseURL + api.path) else {
            completion(.failure(.invalidURLError))
            return
        }
        
        urlComponents.queryItems = api.query.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURLError))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method.rawValue
        urlRequest.allHTTPHeaderFields = api.header
        
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknownError))
                return
            }
            
            if error != nil {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidDataError))
                return
            }
            
            do {
                let decodeData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodeData))
            } catch {
                completion(.failure(.decodeError))
            }
        }
        
        task.resume()
    }
}
