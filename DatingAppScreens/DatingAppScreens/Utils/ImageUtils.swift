//
//  ImageUtils.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 14/03/25.
//


import SwiftUI
import UIKit

// MARK: - Resize Image and Compress to Under 4MB
   func resizeImage(_ image: UIImage, maxFileSize: Int) -> Data? {
       var compression: CGFloat = 1.0
       var resizedData = image.jpegData(compressionQuality: compression)
       
       // Reduce compression quality until image size is under 4MB
       while let data = resizedData, data.count > maxFileSize, compression > 0.1 {
           compression -= 0.1
           resizedData = image.jpegData(compressionQuality: compression)
       }
       
       // If compression alone is not enough, resize and try again
           var newSize = image.size
       
           newSize = CGSize(width: newSize.width * 0.8, height: newSize.height * 0.8) // Reduce by 10%
       
           if let resizedImage = resizedData.flatMap({ UIImage(data: $0) })?.resized(to: newSize)  {
                   resizedData = resizedImage.jpegData(compressionQuality: compression)
           }
       
       return resizedData
   }


// MARK: - UIImage Extension for Resizing
extension UIImage {
    func resized(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
