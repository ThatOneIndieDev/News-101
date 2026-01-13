//
//  NewsFetchService.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 13/01/2026.
//

import Foundation
import Combine


@MainActor
class NewsFetchService{
    
    func getAPIKey() -> String? {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"), // looking for data on main data stream
           let dict = NSDictionary(contentsOfFile: path){
            return dict["NewsAPIKey"] as? String // as? -> conditional type cast of instance to desired type
        }
        return nil
    }
    
    @Published var newsBlocks: [NewsModel] = []
    var newsSubscribtion: AnyCancellable?
    
    init() {
        getNews()
    }
    
    func getNews(){
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?sources=bbc-news")
            else {return}
        
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "apiKey": getAPIKey() ?? ""
        ]
        
        newsSubscribtion = NetworkingManager.download(url: request)
            .decode(type: [NewsModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue:{
                [weak self] (returnedNewsBlocks) in
                self?.newsBlocks = returnedNewsBlocks
                self?.newsSubscribtion?.cancel()
            })
    }
    
}
