//
//  ImageUtils.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 14/03/25.
//


import SwiftUI

// MARK: - Resize Image and Compress to Under 4MB
   func resizeImage(_ image: UIImage, maxFileSize: Int) -> Data? {
       var compression: CGFloat = 1.0
       var resizedData = image.jpegData(compressionQuality: compression)
       
       // Reduce compression quality until image size is under 4MB
       while let data = resizedData, data.count > maxFileSize, compression > 0.1 {
           compression -= 0.1
           resizedData = image.jpegData(compressionQuality: compression)
       }
       
       return resizedData
   }
