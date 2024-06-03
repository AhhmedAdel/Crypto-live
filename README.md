# Crypto-Live Price Tracker

## Overview
This app fetches and displays the latest prices, 24-hour changes, and descriptions of various cryptocurrencies using the CoinGecko API. The project was built to enhance my understanding of networking in iOS development, including asynchronous data fetching, error handling, and MVVM architecture.

## Features
- **Real-time Cryptocurrency Prices:** Fetches the latest prices of various cryptocurrencies.
- **24-Hour Price Change:** Displays the percentage change in price over the last 24 hours.
- **Detailed Descriptions:** Provides detailed descriptions of each cryptocurrency.

## What I Learned
1. **Networking Basics:**
   - Setting up projects with API documentation.
   - Fetching data using completion handlers and async/await.
   
2. **Data Handling:**
   - Parsing JSON data from API responses.
   - Error handling and custom error creation.
   
3. **Concurrency:**
   - Threading concepts and Swift concurrency with async/await.
   - Handling tasks and throwing errors in concurrent operations.

4. **MVVM Architecture:**
   - Structuring the app using the Model-View-ViewModel (MVVM) pattern.
   - Implementing a protocol-oriented service class for network operations.

5. **Advanced Concepts:**
   - Refactoring with generic HTTP data downloader.
   - Using URL components for cleaner network requests.
   - Implementing caching to store fetched data locally.

6. **Unit Testing:**
   - Setting up and writing unit tests for the ViewModel.
   - Testing data fetching and parsing logic.

## Installation
1. Clone the repository.
2. Open the project in Xcode.
3. Run the project on your simulator or device.

## Screenshots
<img width="327" alt="image" src="https://github.com/AhhmedAdel/Crypto-live/assets/170970533/2c2e2fc0-d468-43da-887e-9fdf2ba727a9">
<img width="320" alt="image" src="https://github.com/AhhmedAdel/Crypto-live/assets/170970533/992c2ef4-8189-469f-bf42-5948da23cedc">


## Conclusion
This app project allowed me to master essential networking skills in iOS development, from basic data fetching to implementing advanced architectures and testing. The experience gained will be instrumental in developing more complex applications in the future.
