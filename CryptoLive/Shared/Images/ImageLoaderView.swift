//
//  ImageLoaderView.swift
//  CryptoLive
//
//  Created by Ahmed Adel on 03/06/2024.
//

import SwiftUI

struct ImageLoaderView: View {
    @ObservedObject var imageLoader: ImageLoader
    
    init(url: String) {
        imageLoader = ImageLoader(url: url)
    }
    var body: some View {
        if let image = imageLoader.image {
            image
                .resizable()
        }
    }
}

#Preview {
    ImageLoaderView(url: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400")
}
