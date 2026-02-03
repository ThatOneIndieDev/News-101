//
//  NetworkingManager.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 13/01/2026.
//


import Foundation
import Combine

class NetworkingManager{
    enum NetworkingError: LocalizedError { // Protocool to give specific errors as to why the error occoured
        case badURLResponse(url: URLRequest)
        case unknown
        
        var errorDescription: String?{
            switch self{
            case .badURLResponse(url: let url): return "Bad Response From URL: \(url)"
            case .unknown: return "Unknown Error Occoured"
            }
        }
    }
    
    // SYNC THROWS IS MUCH MORE EASY TO USE AND UNDERSTAND RATHER THAN COMBINE
    
    static func download(url: URLRequest) async throws -> Data {
        
        var attempts = 0
        var lastError: Error?
        
        while attempts < 3{
            do{
                let (data, response) = try await URLSession.shared.data(for: url)
                print("Success")
                return try NetworkingManager.handleURLResponse(output: (data, response), url: url)
                
            } catch {
                attempts += 1
                var lastError = error
                print(error.localizedDescription)
            }
        }
        throw lastError ?? URLError(.unknown)
    }
    
    static func download(url: URLRequest) -> AnyPublisher<Data, Error> { // Returns with a combine publisher that gives data but can fail with an error
        
        return URLSession.shared.dataTaskPublisher(for: url) // Starts a URL session to get data from the passed URL
            .tryMap ({ try handleURLResponse(output: $0, url: url)
            }) // using tryMap because handleURLResponse throws an Error if failed
            .retry(3) // retry 3 times if the url response fails
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URLRequest) throws -> Data{
        guard let response = output.response as? HTTPURLResponse, // using guard let ensires that there will always be someting to be returned in garuntee
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>){ // Combine publishers can give one of two outputs which are wither to finish the task or to fail at getting the data
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print("Error fetching coins: \(error.localizedDescription)")
        }
    }
    
}

