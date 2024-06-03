//
//  ContentView.swift
//  CryptoLive
//
//  Created by Ahmed Adel on 28/05/2024.
//

import SwiftUI

struct ContentView: View {
    private let service: CoinServiceProtocol
    @StateObject var viewModel = CoinsViewModel(service: CoinDataService())
    
    init(service: CoinServiceProtocol) {
        self.service = service
        self._viewModel = StateObject(wrappedValue: CoinsViewModel(service: service))
    }
    var body: some View {
        NavigationStack {
            List {
                HStack(spacing: 20) {
                    Text("Market cap")
                        .font(.caption)
                    
                    Spacer()
                    
                    Text("Current price / 24hr change")
                        .font(.caption)
                    
                }
                .foregroundStyle(.secondary)
                ForEach(viewModel.coins) { coin in
                    NavigationLink(value: coin) {
                        HStack(spacing: 14) {
                            Text("\(coin.marketCapRank)")
                                .font(.caption)
                            
                            ImageLoaderView(url: coin.imageURL)
                                .frame(width: 32, height: 32)
                            
                            
                            VStack(alignment: .leading) {
                                Text(coin.name)
                                    .font(.headline)
                                Text(coin.symbol.uppercased())
                                    .foregroundStyle(.secondary)
                            }
                            
                            
                            Spacer()
                            HStack(spacing: 4) {
                                if coin.priceChangePercentage24HInCurrency > 0 {
                                    Image(systemName: "arrow.up")
                                        .foregroundStyle(.secondary)
                                    Text("$\(coin.formattedCurrentPrice)")
                                        .foregroundStyle(.green)
                                } else {
                                    Image(systemName: "arrow.down")
                                        .foregroundStyle(.secondary)
                                    Text("$\(coin.formattedCurrentPrice)")
                                        .foregroundStyle(.red)
                                }
                            }
                            .fontWeight(.semibold)

                            
                        }
                    }
                    .font(.footnote)
                    
                    // Pagination - fetching 20 coins at a time
                    .onAppear {
                        if coin == viewModel.coins.last {
                            Task { await viewModel.fetchCoins() }
                        }
                    }
                }
            }
            .padding(.top)
            .navigationDestination(for: Coin.self, destination: { coin in
                CoinDetailsView(coin: coin, service: service)
            })
            .overlay {
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                }
            }
            .navigationTitle("Crypto Live")
        }
        .task {
            await viewModel.fetchCoins()
        }
    }
}

#Preview {
    ContentView(service: CoinDataService())
}
