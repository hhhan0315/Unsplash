//
//  Photo.swift
//  Unsplash
//
//  Created by rae on 2022/05/27.
//

import UIKit

class Photo {
    var identifier = UUID()
    var image: UIImage?
    var imageUrl: URL?
    var userName: String

    init(image: UIImage?, imageUrl: URL?, userName: String) {
        self.image = image
        self.imageUrl = imageUrl
        self.userName = userName
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
