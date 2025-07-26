//
//  NetworkManager.swift
//  SnapNote
//
//  Created by chaitanya on 26/05/25.
//

import Foundation


enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func fetchProducts(completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        guard let url = URL(string: "https://api.restful-api.dev/objects") else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else {
                completion(.failure(.noData))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            //  to print the raw JSON response:
            print("Raw JSON response:")
            
            //print(String(data: data, encoding: .utf8) ?? "Invalid JSON")

            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                completion(.success(products))
            } catch {
                print("Decoding error: \(error)")
                // to find out more specific error
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
