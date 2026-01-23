//
//  LocalFileManager.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 14/01/2026.
//

import SwiftUI
import Foundation


class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    init(){}
    
    func saveImage(image: UIImage, imageName: String, folderName: String){
        createFolderIfNeeded(folderName: folderName)
        
        guard let data = image.pngData(),
                let url = URL(string: "")
                else { return }
        
        do{
           try data.write(to: url)
        } catch let error {
            print("Error in saving Image: \(error.localizedDescription)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getURLFromImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
    
    func createFolderIfNeeded(folderName: String){
        guard let url = getURLFolder(folderName: folderName) else {return}
        if !FileManager.default.fileExists(atPath: url.path) {
            do{
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }catch let error {
                print("Error in creating directory \(error.localizedDescription)")
            }
        }
    }
    
    func getURLFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLFromImage(imageName: String, folderName: String) -> URL?{
        guard let folderURL = getURLFolder(folderName: folderName) else {return nil}
        return folderURL.appendingPathComponent(imageName + ".png")
    }
    
}
