//
//  Constants.swift
//  Unsplash
//
//  Created by rae on 2022/05/10.
//

import Foundation

struct Constants {
    
    struct APIKeys {
        static let clientKey = "ZwdzXjUXEW3Yfja3LfGMmPCPbrIvDDtgqXPtoxh7eKg"
    }
    
    struct APIHeaders {
        static let authorizationType = "Authorization"
        static let authroizationValue = "Client-ID \(APIKeys.clientKey)"
        static let contentType = "Content-Type"
        static let contentValue = "application/json"
    }
}
