//
//  CoinDetailsView.swift
//  CryptoLive
//
//  Created by Ahmed Adel on 01/06/2024.
//

import SwiftUI

struct CoinDetailsView: View {
    let coin: Coin
    @ObservedObject var viewModel: CoinDetailsViewModel
    
    init(coin: Coin, service: CoinServiceProtocol) {
        self.coin = coin
        self.viewModel = CoinDetailsViewModel(coinId: coin.id, service: service)
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let details = viewModel.coinDetails {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(details.name)
                                .font(.title)
                                .fontWeight(.semibold)
                            Text(details.symbol.uppercased())
                                .font(.footnote)
                        }
                        Spacer()
                        
                        ImageLoaderView(url: coin.imageURL)
                            .frame(width: 64, height: 64)
                    }
                    
                    Text(details.description.en)
                        .padding(.vertical)
                }
            }
            .padding()
            .task {
                await viewModel.fetchCoinDetails()
            }
        }
        
    }
}

//#Preview {
//    CoinDetailsView()
//}
