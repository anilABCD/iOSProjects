import Foundation
import UIKit

class PersistentCacheManager {
    static let shared = PersistentCacheManager()
    
    private init() {}
    
    private func getFilePath(forKey key: String) -> URL {
        let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent(key)
    }

    // MARK: - JSON Caching
    func saveJSON<T: Encodable>(_ object: T, forKey key: String) {
        let filePath = getFilePath(forKey: key)
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: filePath)
            print("JSON object saved successfully at \(filePath)")
        } catch {
            print("Error saving JSON object: \(error)")
        }
    }

    func loadJSON<T: Decodable>(forKey key: String, as type: T.Type) -> T? {
        let filePath = getFilePath(forKey: key)
        do {
            let data = try Data(contentsOf: filePath)
            let object = try JSONDecoder().decode(type, from: data)
            return object
        } catch {
            print("Error loading JSON object: \(error)")
            return nil
        }
    }

    // MARK: - Image Caching
    func saveImage(_ image: UIImage, forKey key: String) {
        let filePath = getFilePath(forKey: key)
        do {
            if let data = image.jpegData(compressionQuality: 1.0) {
                try data.write(to: filePath)
                print("Image saved successfully at \(filePath)")
            } else {
                print("Error: Unable to convert UIImage to JPEG data.")
            }
        } catch {
            print("Error saving image: \(error)")
        }
    }

    func loadImage(forKey key: String) -> UIImage? {
        let filePath = getFilePath(forKey: key)
        do {
            let data = try Data(contentsOf: filePath)
            return UIImage(data: data)
        } catch {
            print("Error loading image: \(error)")
            return nil
        }
    }

    func deleteData(forKey key: String) {
        let filePath = getFilePath(forKey: key)
        do {
            try FileManager.default.removeItem(at: filePath)
            print("Data deleted successfully.")
        } catch {
            print("Error deleting data: \(error)")
        }
    }

    func isDataCached(forKey key: String) -> Bool {
        let filePath = getFilePath(forKey: key)
        return FileManager.default.fileExists(atPath: filePath.path)
    }
}
