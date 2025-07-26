//
//  APIManager.swift
//  SnapNote
//
//  Created by chaitanya on 26/05/25.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private init() {}

    func deleteProduct(withID id: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://api.restful-api.dev/objects/\(id)") else {
            print("Invalid URL")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error during API DELETE: \(error.localizedDescription)")
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("DELETE status code: \(httpResponse.statusCode)")
                completion(httpResponse.statusCode == 200)
            } else {
                completion(false)
            }
        }

        task.resume()
    }
}
