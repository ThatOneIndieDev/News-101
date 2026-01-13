//
//  NewsModel.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 13/01/2026.
//

// This file will be used to return the details of a news that will then be put on the main screen

import Foundation
import Combine

// MARK: - NewsModel
struct NewsModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}

