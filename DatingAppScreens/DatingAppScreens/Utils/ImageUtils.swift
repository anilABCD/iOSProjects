//
//  ImageUtils.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 14/03/25.
//


import SwiftUI
import UIKit

// MARK: - Resize Image and Compress to Under 4MB
   func resizeImage(_ image: UIImage, maxFileSize: Int, maxSize: CGSize = CGSize(width: 1080, height: 1350) ) -> Data? {
       var compression: CGFloat = 1.0
       var resizedData = image.jpegData(compressionQuality: compression)
       var resizedImage = image
      
       // Step 1: Resize First (if needed)
          if image.size.width > maxSize.width || image.size.height > maxSize.height {
            
              resizedImage = image.resized(toFit: maxSize) ?? image
          }
       
       // Step 2: Compress After Resizing
           
       
          // Step 2: Compress the resized image
          resizedData = resizedImage.jpegData(compressionQuality: compression)
 
          var maxFileSize = 300 * 1024 // 300KB in bytes
 

           while let data = resizedData, data.count > maxFileSize, compression > 0.1 {
               compression -= 0.1
               resizedData = resizedImage.jpegData(compressionQuality: compression)
           }

           return resizedData

//       // Reduce compression quality until image size is under 4MB
//       while let data = resizedData, data.count > maxFileSize, compression > 0.1 {
//           
//           print ( data.count)
//           
//           compression -= 0.1
//           resizedData = image.jpegData(compressionQuality: compression)
//       }
       
//       // If compression alone is not enough, resize and try again
//           var newSize = image.size
//       
//           newSize = CGSize(width: newSize.width * 0.8, height: newSize.height * 0.8) // Reduce by 10%
//       
//           if let resizedImage = resizedData.flatMap({ UIImage(data: $0) })?.resized(to: newSize)  {
//                   resizedData = resizedImage.jpegData(compressionQuality: compression)
//           }
       
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


// MARK: - UIImage Extension for Resizing
extension UIImage {
    func resized(toFit maxSize: CGSize) -> UIImage? {
        let aspectWidth = maxSize.width / size.width
        let aspectHeight = maxSize.height / size.height
        let aspectRatio = min(aspectWidth, aspectHeight) // Maintain aspect ratio
        
        let newSize = CGSize(width: size.width * aspectRatio, height: size.height * aspectRatio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}


func createPaddedPlaceholderImage(size: CGSize, padding: CGFloat) -> UIImage? {
    let newSize = CGSize(width: size.width + padding * 2, height: size.height + padding * 2)
    
    let renderer = UIGraphicsImageRenderer(size: newSize)
    return renderer.image { context in
        UIColor.black.setFill()
        context.fill(CGRect(origin: .zero, size: newSize))
        
        let config = UIImage.SymbolConfiguration(pointSize: size.width, weight: .bold, scale: .large)
        if let placeholder = UIImage(systemName: "person.crop.circle", withConfiguration: config)?.withRenderingMode(.alwaysOriginal) {
            let origin = CGPoint(x: padding, y: padding)
            placeholder.draw(in: CGRect(origin: origin, size: size))
        }
    }
}
