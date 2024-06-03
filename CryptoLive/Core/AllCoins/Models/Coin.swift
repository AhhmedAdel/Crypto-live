//
//  Coin.swift
//  CryptoLive
//
//  Created by Ahmed Adel on 28/05/2024.
//

import Foundation

struct Coin: Codable, Identifiable, Hashable {
    let id: String
    let symbol: String
    let name: String
    let currentPrice: Double
    let marketCapRank: Int
    let imageURL: String
    var priceChangePercentage24HInCurrency: Double
    
    
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
        case imageURL = "image"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
    }
    
    var formattedCurrentPrice: String {
        if currentPrice >= 1 {
            // Show only one decimal place for prices >= 1
            return String(format: "%.1f", currentPrice)
        }
        else {
            return(String(format: "%.7f", currentPrice))
        }
    }
}
