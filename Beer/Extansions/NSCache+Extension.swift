//
//  NSCache+Extension.swift
//  Beer
//
//  Created by Nikita Chuklov on 12.03.2024.
//

import UIKit

extension NSCache where KeyType == NSString, ObjectType == UIImage {
    subscript(key: KeyType) -> ObjectType? {
        get {
            guard let object = self.object(forKey: key) else { return nil }
            return object
        }
        
        set {
            let object = newValue ?? UIImage()
            guard key.length > 0 else { return }
            setObject(object, forKey: key)
        }
    }
}
