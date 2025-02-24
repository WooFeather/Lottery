//
//  APIError.swift
//  Lottery
//
//  Created by 조우현 on 2/24/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}
