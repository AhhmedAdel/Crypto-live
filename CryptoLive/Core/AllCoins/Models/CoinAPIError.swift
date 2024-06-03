//
//  CoinAPIError.swift
//  CryptoLive
//
//  Created by Ahmed Adel on 29/05/2024.
//

import Foundation

enum CoinAPIError: Error {
    case invalidData
    case jsonParsingFailure
    case requestFailed(description: String)
    case invalidStatusCode(statusCode: Int)
    case unkownError(error: Error)
    
    var customDescription: String {
        switch self {
        case .invalidData:
            return "Invalid Data"
        case .jsonParsingFailure:
            return "failed to parse JSON"
        case .requestFailed(let description):
            return "requst failed \(description)"
        case .invalidStatusCode(let statusCode):
            return "invalid status code: \(statusCode)"
        case .unkownError(let error):
            return "an unkonwn error occured \(error.localizedDescription)"
        }
    }
}
