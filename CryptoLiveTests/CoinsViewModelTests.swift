//
//  CoinsViewModelTests.swift
//  CryptoLiveTests
//
//  Created by Ahmed Adel on 02/06/2024.
//

import XCTest
@testable import CryptoLive


class CoinsViewModelTests: XCTestCase {
    func test_Init() {
        let service = MockCoinService()
        let viewModel = CoinsViewModel(service: service)
        
        
        XCTAssertNotNil(viewModel, "The view model shouldn't be nil")
    }
    
    func test_SuccessCoinsFetch() async {
        let service = MockCoinService()
        let viewModel = CoinsViewModel(service: service)
        
        await viewModel.fetchCoins()
        XCTAssertTrue(viewModel.coins.count > 0) // check that coin array has coins
        XCTAssertEqual(viewModel.coins.count, 20) // check all coins were decoded
        XCTAssertEqual(viewModel.coins, viewModel.coins.sorted(by: {$0.marketCapRank < $1.marketCapRank })) // check sorting order is correct
    }
    
    func test_CoinFetchWithInvalidJSON() async {
        let service = MockCoinService()
        service.mockData = mockCoins_invalidJSON
        service.mockError = CoinAPIError.jsonParsingFailure
        
        let viewModel = CoinsViewModel(service: service)
        
        await viewModel.fetchCoins()
    
        XCTAssertTrue(viewModel.coins.isEmpty) // check if coins array empty after decoding invalidJSON
        XCTAssertNotNil(viewModel.errorMessage) // check if error message generated 
        XCTAssertEqual(viewModel.errorMessage, CoinAPIError.jsonParsingFailure.customDescription) // check if error message is relavent
    }
    
    func test_throwsInvalidDataError() async {
        let service = MockCoinService()
        service.mockError = CoinAPIError.invalidData
        
        let viewModel = CoinsViewModel(service: service)
        
        await viewModel.fetchCoins()
        
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, CoinAPIError.invalidData.customDescription)
    }
    
    func test_throwsInvalidStatusCode() async {
        let service = MockCoinService()
        service.mockError = CoinAPIError.invalidStatusCode(statusCode: 404)
        
        let viewModel = CoinsViewModel(service: service)
        
        await viewModel.fetchCoins()
        
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, CoinAPIError.invalidStatusCode(statusCode: 404).customDescription)
    }
    
    
}
