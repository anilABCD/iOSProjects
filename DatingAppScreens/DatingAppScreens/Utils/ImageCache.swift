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

func saveImageToDisk(image: UIImage, url: URL) {
    if let data = image.jpegData(compressionQuality: 1.0) {
        let fileURL = getFilePath(for: url)
        try? data.write(to: fileURL)
    }
}

func getFilePath(for url: URL) -> URL {
    let fileName = url.lastPathComponent // Use the last path component as the filename
    let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    return directory.appendingPathComponent(fileName)
}

func loadImageFromDisk(url: URL) -> UIImage? {
    let fileURL = getFilePath(for: url)
    if let data = try? Data(contentsOf: fileURL) {
        return UIImage(data: data)
    }
    return nil
}



func loadImage(url: URL , storeInDisk : Bool, completion: @escaping (UIImage?) -> Void) {
    
    // First, check NSCache (in-memory)
    if let cachedImage = ImageCache.shared.object(forKey: url.absoluteString as NSString) {
        completion(cachedImage)
        return
    }
    
    if( storeInDisk ) {
        // Second, check disk storage
        if let diskImage = loadImageFromDisk(url: url) {
            ImageCache.shared.setObject(diskImage, forKey: url.absoluteString as NSString) // Store in memory
            completion(diskImage)
            return
        }
    }
    
    // Finally, download from network
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Failed to load image: \(error.localizedDescription)")
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
//         Check for HTTP response and status code
         
        if let httpResponse = response as? HTTPURLResponse {
            if !(200...299).contains(httpResponse.statusCode) { // Not a successful response
                print("HTTP Error: \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    completion(nil) // Return nil for bad response codes
                }
                return
            }
        }
        
        guard let data = data, let image = UIImage(data: data) else {
            print("Invalid image data")
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        // Save to NSCache
        ImageCache.shared.setObject(image, forKey: url.absoluteString as NSString)
        
        
        if ( storeInDisk ){
            // Save to Disk
            saveImageToDisk(image: image, url: url)
        }
        
        DispatchQueue.main.async {
            completion(image)
        }
    }.resume()
}

//
//func loadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
//    
//    print(url)
//    
//    if let cachedImage = ImageCache.shared.object(forKey: url.absoluteString as NSString) {
//        completion(cachedImage)
//        return
//    }
//    
//    URLSession.shared.dataTask(with: url) { data, response, error in
//        
//        if let error = error {
//            print("Failed to load image: \(error.localizedDescription)")
//            DispatchQueue.main.async {
//                completion(nil) // Return nil in case of failure
//            }
//            return
//        }
//        
//        
//           // Check for HTTP response and status code
//           if let httpResponse = response as? HTTPURLResponse {
//               if !(200...299).contains(httpResponse.statusCode) { // Not a successful response
//                   print("HTTP Error: \(httpResponse.statusCode)")
//                   DispatchQueue.main.async {
//                       completion(nil) // Return nil for bad response codes
//                   }
//                   return
//               }
//           }
//
//        
//        if let data = data, let image = UIImage(data: data) {
//            ImageCache.shared.setObject(image, forKey: url.absoluteString as NSString)
//            DispatchQueue.main.async {
//                completion(image)
//            }
//        }
//    }.resume()
//}
