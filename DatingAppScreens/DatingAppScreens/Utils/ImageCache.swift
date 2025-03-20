//
//  ImageCache.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 06/03/25.
//

import SwiftUI

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}

//let cacheExpiryInterval: TimeInterval = 60 * 60 * 24 // 1 day (in seconds)


func saveImageToDisk(image: UIImage, url: URL, cacheExpiryInterval: TimeInterval) {
    if let data = image.jpegData(compressionQuality: 1.0) {
        let fileURL = getFilePath(for: url)
        let metadataURL = getMetadataFilePath(for: url)
        
        try? data.write(to: fileURL)
        
        let expiryDate = Date().addingTimeInterval(cacheExpiryInterval)
        let metadata = ["expiry": expiryDate.timeIntervalSince1970]
        
        if let metadataData = try? JSONSerialization.data(withJSONObject: metadata) {
            try? metadataData.write(to: metadataURL)
        }
    }
}

func loadImageFromDisk(url: URL) -> UIImage? {
    let fileURL = getFilePath(for: url)
    let metadataURL = getMetadataFilePath(for: url)

    guard let metadataData = try? Data(contentsOf: metadataURL),
          let metadata = try? JSONSerialization.jsonObject(with: metadataData) as? [String: TimeInterval],
          let expiryTimestamp = metadata["expiry"],
          Date().timeIntervalSince1970 < expiryTimestamp else {
        deleteImageFromDisk(url: url) // Remove expired file
        return nil
    }

    if let data = try? Data(contentsOf: fileURL) {
        return UIImage(data: data)
    }
    return nil
}

func deleteImageFromDisk(url: URL) {
    let fileURL = getFilePath(for: url)
    let metadataURL = getMetadataFilePath(for: url)
    try? FileManager.default.removeItem(at: fileURL)
    try? FileManager.default.removeItem(at: metadataURL)
}

func getFilePath(for url: URL) -> URL {
    let fileName = url.lastPathComponent
    let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    return directory.appendingPathComponent(fileName)
}

func getMetadataFilePath(for url: URL) -> URL {
    let fileName = url.lastPathComponent + ".meta"
    let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    return directory.appendingPathComponent(fileName)
}

func loadImage(url: URL, storeInDisk: Bool, cacheExpiryInterval: TimeInterval, completion: @escaping (UIImage?) -> Void) {
    if let cachedImage = ImageCache.shared.object(forKey: url.absoluteString as NSString) {
        
        print("Loaded From RAM Cache")
        
        completion(cachedImage)
        return
    }
    
    if storeInDisk {
        
        print("Loaded From Disk")
        
        if let diskImage = loadImageFromDisk(url: url) {
            ImageCache.shared.setObject(diskImage, forKey: url.absoluteString as NSString)
            completion(diskImage)
            return
        }
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
//        if let error = error {
//            print("Failed to load image: \(error.localizedDescription)")
//            DispatchQueue.main.async {
//                completion(nil)
//            }
//            return
//        }

        if let httpResponse = response as? HTTPURLResponse {
         
                if httpResponse.statusCode == 404 {
                    print("Image Not Found (404), using and caching default image")
                    DispatchQueue.main.async {
//                        let config = UIImage.SymbolConfiguration(pointSize: 600, weight: .bold, scale: .large)
//                        if let defaultImage = UIImage(systemName: "person.crop.circle", withConfiguration: config)?.withRenderingMode(.alwaysOriginal) {
                        
                        if let defaultImage = createPaddedPlaceholderImage(size: CGSize(width: 300, height: 300), padding: 50) {
                            
                            // Store the default image in the cache
                            ImageCache.shared.setObject(defaultImage, forKey: url.absoluteString as NSString)
                            
                            // Save to disk if enabled
                            if storeInDisk {
                                saveImageToDisk(image: defaultImage, url: url, cacheExpiryInterval: cacheExpiryInterval)
                            }
                            
                            completion(defaultImage)
                        } else {
                            completion(nil) // Fallback if image generation fails
                        }
                    }
                    return
                    
                } else if !(200...299).contains(httpResponse.statusCode) {
                    print("HTTP Error: \(httpResponse.statusCode)")
                    DispatchQueue.main.async {
                        completion(nil) // Handle other HTTP errors normally
                    }
                    return
                    
                }
            }
        
        
        guard let data = data, let image = UIImage(data: data) else {
            print("Invalid image data")
            DispatchQueue.main.async {
                completion(UIImage(systemName: "person.crop.circle"))
            }
            return
        }
        
        ImageCache.shared.setObject(image, forKey: url.absoluteString as NSString)

        if storeInDisk {
            saveImageToDisk(image: image, url: url, cacheExpiryInterval: cacheExpiryInterval)
        }

        DispatchQueue.main.async {
            completion(image)
        }
    }.resume()
}
