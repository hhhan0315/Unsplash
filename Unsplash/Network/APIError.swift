//
//  APIError.swift
//  Unsplash
//
//  Created by rae on 2022/09/21.
//

import Foundation

enum APIError: Error {
    case invalidURLError
    case invalidDataError
    case serverError(statusCode: Int)
    case unknownError
    case decodeError
    
    var errorDescription: String {
        switch self {
        case .invalidURLError:
            return "URL이 유효하지 않습니다."
        case .invalidDataError:
            return "Data가 유효하지 않습니다."
        case .serverError(let statusCode):
            return "\(statusCode) 서버 에러가 발생했습니다."
        case .unknownError:
            return "Unknown Error"
        case .decodeError:
            return "Decode Error"
        }
    }
}
