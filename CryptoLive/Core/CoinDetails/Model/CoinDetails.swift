//
//  CoinDetails.swift
//  CryptoLive
//
//  Created by Ahmed Adel on 01/06/2024.
//

import Foundation

struct CoinDetails: Codable {
    let id: String
    let symbol: String
    let name: String
    let description: Description
}

struct Description: Codable {
    let en: String
}
