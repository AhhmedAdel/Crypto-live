//
//  CoinDataService.swift
//  CryptoLive
//
//  Created by Ahmed Adel on 28/05/2024.
//

import Foundation

protocol CoinServiceProtocol {
    func fetchCoins() async throws -> [Coin]
    func fetchCoinDetails(id: String) async throws -> CoinDetails?
}

protocol HTTPDataDownloader {
    func fetchData<T: Decodable>(as type: T.Type, endPoint: String) async throws -> T
}

extension HTTPDataDownloader {
    func fetchData<T: Decodable>(as type: T.Type, endPoint: String) async throws -> T {
        guard let url = URL(string: endPoint) else {
            throw CoinAPIError.requestFailed(description: "Invalid URL")
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw CoinAPIError.requestFailed(description: "Request Failed")
        }
        
        guard httpResponse.statusCode == 200 else {
            throw CoinAPIError.invalidStatusCode(statusCode: httpResponse.statusCode)
        }
        do {
            return try JSONDecoder().decode(type, from: data)
            
        } catch {
            print("DEBUG: Error \(error)")
            throw error as? CoinAPIError ?? .unkownError(error: error)
        }
    }
}

class CoinDataService: CoinServiceProtocol, HTTPDataDownloader {
    
    private var page = 0
    private let fetchLimit = 20
    
    
    private var allCoinsURLString: String {
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "vs_currency", value: "usd"),
            URLQueryItem(name: "order", value: "market_cap_desc"),
            URLQueryItem(name: "per_page", value: "\(fetchLimit)"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "price_change_percentage", value: "24h"),
            URLQueryItem(name: "locale", value: "en"),
        ]
        
        components.queryItems = queryItems
        
        return components.url?.absoluteString ?? url.absoluteString
    }
    
    
    func fetchCoins() async throws -> [Coin] {
        
        page += 1
        
        return try await fetchData(as: [Coin].self, endPoint: allCoinsURLString)
    }
    
    
    func fetchCoinDetails(id: String) async throws -> CoinDetails? {
        
        let coinDetailsStringURL = "https://api.coingecko.com/api/v3/coins/\(id)?localization=false"
        
        // Getting data from the cache if exist
        if let cached = CoinDetailsCache.shared.get(forKey: id) { return cached }
        
        // Setting the Cache
        let details = try await fetchData(as: CoinDetails.self, endPoint: coinDetailsStringURL)
        CoinDetailsCache.shared.set(details, forKey: id)
        
        return details
    }
    
    
    
}

// Mark : - Completion Handler method

extension CoinDataService {
    func fetchCoinsWithCompletionHandler(completion: @escaping(Result<[Coin], CoinAPIError>) -> Void)  {
        
        guard let url = URL(string: allCoinsURLString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.unkownError(error: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "Request Failed")))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidStatusCode(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let coins = try decoder.decode([Coin].self, from: data)
                completion(.success(coins))
            } catch {
                print("DEBUG: Failed to decode with error \(error)")
                completion(.failure(.jsonParsingFailure))
            }
            guard let coins = try? decoder.decode([Coin].self, from: data) else {
                print("DEBUG: failed to decode coins")
                return
            }
            
            completion(.success(coins))
        }.resume()
    }
    func fetchPrice(coin: String, completion: @escaping(Double) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                return
            }
            
            guard let data = data else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            guard let value = jsonObject[coin] as? [String: Double] else {
                print("Failed to parse value")
                return
            }
            guard let price = value["usd"] else { return }
            completion(price)
        }.resume()
    }
}
