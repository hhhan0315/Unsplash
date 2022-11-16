//
//  APIService.swift
//  Unsplash
//
//  Created by rae on 2022/09/08.
//

import Foundation

final class APIService {
    private let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func request<T: Decodable>(api: API,
                               dataType: T.Type,
                               completion: @escaping (Result<T, APIError>) -> Void) {
        guard let urlRequest = makeURLRequest(with: api) else {
            completion(.failure(.invalidURLRequest))
            return
        }
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                completion(.failure(.sessionError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.responseIsNil))
                return
            }
            
            switch httpResponse.statusCode {
            case (200...299):
                guard let data = data else {
                    completion(.failure(.unexpectedData))
                    return
                }
                
                do {
                    let decodeData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodeData))
                } catch {
                    completion(.failure(.decodeError))
                }
            case (400...499):
                completion(.failure(.status_400))
            case (500...599):
                completion(.failure(.status_500))
            default:
                completion(.failure(.unexpectedResponse))
            }
        }
        .resume()
    }
    
    private func makeURLRequest(with api: API) -> URLRequest? {
        guard var urlComponents = URLComponents(string: api.baseURL + api.path) else {
            return nil
        }
        
        urlComponents.queryItems = api.query?.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method.rawValue
        urlRequest.allHTTPHeaderFields = api.header
        
        return urlRequest
    }
}
