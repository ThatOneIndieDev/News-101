//
//  NewsImageService.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 14/01/2026.
//

import Foundation
import Combine
import SwiftUI


@MainActor
class NewsImageService: ObservableObject {

    @Published var image: UIImage? = nil
    private var imageSubscription: AnyCancellable?

    private let imageURL: String?
    private let imageName: String
    private let fileManager = LocalFileManager.instance
    private let folderName = "news_images"

    init(article: Article) {
        self.imageURL = article.urlToImage
        self.imageName = article.url.sanitizedForFilename()
        getNewsImage()
    }

    private func getNewsImage() { // Doing this so images can be locally downloaded and saved. 
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            downloadNewsImage() // getting the Image from the API if it wasn't already there.
        }
    }

    private func downloadNewsImage() {
        guard let urlString = imageURL,
              let url = URL(string: urlString) else { return }

        imageSubscription = NetworkingManager.download(url: URLRequest(url: url))
            .map { UIImage(data: $0) } // takes the raw data and tries to convert it into a UIImage. Result: UIImage?
            .replaceError(with: nil) // if fail then can prevent crash with just returning nil.
            .sink { [weak self] image in // if the closure lives longer than the function always use [weak self]
                guard let self = self, let image else { return }
                self.image = image
                self.fileManager.saveImage(image: image, imageName: self.imageName, folderName: self.folderName)
            }
    }
}


// Crteating a string extention and then adding a folder name such that it does not get too complicated
extension String {
    func sanitizedForFilename() -> String {
        // Create a hash or sanitized version of the URL for use as filename
        let invalid = CharacterSet(charactersIn: ":/\\?%*|\"<>")
        let sanitized = self.components(separatedBy: invalid).joined(separator: "_")
        
        // Limit length to avoid filesystem issues
        if sanitized.count > 200 {
            return String(sanitized.prefix(200))
        }
        return sanitized
    }
}
