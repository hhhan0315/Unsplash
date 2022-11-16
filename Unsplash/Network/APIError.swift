//
//  APIError.swift
//  Unsplash
//
//  Created by rae on 2022/09/21.
//

import Foundation

enum APIError: String, Error {
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
