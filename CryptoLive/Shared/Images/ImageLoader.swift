//
//  ImageLoader.swift
//  CryptoLive
//
//  Created by Ahmed Adel on 03/06/2024.
//

import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: Image?
    
    private let urlString: String
    
    init(url: String) {
        self.urlString = url
        Task { await loadImage() }
    }
    
    @MainActor
    private func loadImage() async {
        guard let url = URL(string: urlString) else { return }

        if let cached = ImageCache.shared.get(forKey: urlString) {
            self.image = Image(uiImage: cached)
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let uiImage = UIImage(data: data) else { return }
            ImageCache.shared.set(uiImage, forkey: urlString)
            self.image = Image(uiImage: uiImage)

            
        } catch {
            print("DEBUG: Failed to fetch image with error \(error)")
        }
    }
}
