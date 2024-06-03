//
//  MockCoinService.swift
//  CryptoLive
//
//  Created by Ahmed Adel on 02/06/2024.
//

import Foundation

class MockCoinService: CoinServiceProtocol {
    var mockData: Data?
    var mockError: CoinAPIError?
    
    func fetchCoins() async throws -> [Coin] {
        if let mockError { throw mockError }
        do {
            let coins = try JSONDecoder().decode([Coin].self, from: mockData ?? mockCoindData_marketCapDesc)
            return coins
        } catch {
            throw error as? CoinAPIError ?? .unkownError(error: error)
        }
    }
    
    func fetchCoinDetails(id: String) async throws -> CoinDetails? {
        return CoinDetails(id: "bitcoin", symbol: "BTC", name: "Bitcoin", description: Description(en: "Description"))
    }
}
