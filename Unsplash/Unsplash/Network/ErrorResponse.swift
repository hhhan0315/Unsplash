//
//  ErrorResponse.swift
//  Unsplash
//
//  Created by rae on 2022/05/12.
//

import Foundation

enum ErrorResponse: String {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    public var description: String {
        switch self {
        case .apiError:
            return "API_Error"
        case .invalidEndpoint:
            return "INVALID_ENDPOINT_ERROR"
        case .invalidResponse:
            return "INVALID_RESPONSE_ERROR"
        case .noData:
            return "NO_DATA_ERROR"
        case .serializationError:
            return "SERIALIZATION_ERROR"
        }
    }
}
