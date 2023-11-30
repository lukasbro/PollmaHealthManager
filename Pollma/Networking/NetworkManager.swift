//
//  NetworkManager.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import Foundation

// NetworkManager is responsable for making all the API calls
// Generic Type T, can only be created with a generic type that conforms to codable protocol
// can be used for any kind of API calls as long as the object we're calling on conforms to codable protocol
final class NetworkManager<T: Codable> {
    
    // completion handler which is gonna escaping and returning a result which returns a type T oder Error
    static func fetch(for url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        // create URLSession and DataTask, make API Call, return Result in Type
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            // guard statement, only proceed if the error is nil, if not return from here with completion stating that it failed due to an error
            guard error == nil else {
                print("ERROR: \(error!.localizedDescription)")
                completion(.failure(.error(err: error!.localizedDescription)))
                return
            }
            
            // safely unwrap response, if it fails or the response aint 200, return from here with completion with failure
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            // savely unwrap data, if it fails we call the completion block with failure
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            // if we passed through the guard statements that means we have some data
            // decode the data
            do {
                // T meaning Type that conforms to codable protocol, meaning only if the passed in object conforms to the type codable
                let json = try JSONDecoder().decode(T.self, from: data)
                // call succes, supply the json
                completion(.success(json))
                
                //catch error while decoding
            } catch let err {
                debugPrint(err)
                print("ERROR: \(err.localizedDescription)")
                completion(.failure(.decodingError(err: err.localizedDescription)))
            }
            
            
            // initiate network call
        }.resume()
    }
}

//
enum NetworkError: Error {
    case invalidResponse
    case invalidData
    case error(err: String)
    case decodingError(err: String)
}
