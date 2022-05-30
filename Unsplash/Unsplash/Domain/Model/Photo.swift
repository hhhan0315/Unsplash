//
//  Photo.swift
//  Unsplash
//
//  Created by rae on 2022/05/27.
//

import UIKit

class Photo {
    var image: UIImage?
    var imageUrl: URL?
    var identifier = UUID()

    init(image: UIImage?, imageUrl: URL?) {
        self.image = image
        self.imageUrl = imageUrl
    }
}

extension Photo: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
