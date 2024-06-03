//
//  CryptoLiveApp.swift
//  CryptoLive
//
//  Created by Ahmed Adel on 28/05/2024.
//

import SwiftUI

@main
struct CryptoLiveApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(service: CoinDataService())
        }
    }
}
