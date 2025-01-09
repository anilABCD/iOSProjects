//
//  UIImageExtension.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 09/01/25.
//

import SwiftUI

extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.jpegData(compressionQuality: 0.5) else { return nil }
        return imageData.base64EncodedString()
    }
}
