//
//  NetworkService.swift
//  Unsplash
//
//  Created by rae on 2022/09/08.
//

import Foundation

enum NetworkError: String, Error {
    case invalidURLRequest = "URLRequest가 유효하지 않습니다."
    case sessionError = "네트워크 통신에 문제가 있습니다."
    case responseIsNil = "서버 응답이 오지 않았습니다."
    case unexpectedData = "예상치 못한 데이터를 수신했습니다."
    case unexpectedResponse = "예상치 못한 서버응답이 왔습니다."
    case decodeError = "디코딩에 문제가 있습니다."
    case status_200 = "예상한 응답이 왔습니다."
    case status_400 = "잘못된 요청입니다."
    case status_500 = "서버 오류입니다."
}

final class NetworkService {
    private let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func request<T: Decodable>(api: TargetType,
                               dataType: T.Type,
                               completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let urlRequest = makeURLRequest(with: api) else {
//            throw NetworkError.invalidURLRequest
            completion(.failure(.invalidURLRequest))
            return
        }
        
//        let (data, response) = try await urlSession.data(for: urlRequest)
//
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw NetworkError.responseIsNil
////            completion(.failure(.responseIsNil))
////            return
//        }
//
//        switch httpResponse.statusCode {
//        case (200...299):
//            do {
//                let decodeData = try JSONDecoder().decode(T.self, from: data)
//                return decodeData
//            } catch {
//                throw NetworkError.decodeError
//            }
//        case (400...499):
//            throw NetworkError.status_400
//        case (500...599):
//            throw NetworkError.status_500
//        default:
//            throw NetworkError.unexpectedResponse
//        }
        
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
    
    private func makeURLRequest(with api: TargetType) -> URLRequest? {
        guard var urlComponents = URLComponents(string: api.baseURL + api.path) else {
            return nil
        }
        
        urlComponents.queryItems = api.query?.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method.rawValue
        urlRequest.allHTTPHeaderFields = api.headers
        
        return urlRequest
    }
}
