//
//  ImageFileManager.swift
//  LiveCodingDemo
//
//  Created by Sukhrob on 14/03/26.
//

import Foundation

final class ImageFileManager {
    static let shared = ImageFileManager()
    private let folderName: String = "downloaded_images"
    
    private init() {
        createFolderIfNeeded()
    }
    
    private func createFolderIfNeeded() {
        guard let url = getFolderPath() else { return }
        
        if !FileManager.default.fileExists(atPath: url.path()) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getFolderPath() -> URL? {
        return FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
    }
    
    private func getImagePath(key: String) -> URL? {
        guard let folder = getFolderPath() else { return nil }
        
        return folder.appendingPathComponent(key + ".png")
    }
}
