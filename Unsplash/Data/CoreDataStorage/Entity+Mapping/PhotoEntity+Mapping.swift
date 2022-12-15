//
//  PhotoEntity+Mapping.swift
//  Unsplash
//
//  Created by rae on 2022/12/15.
//

import Foundation

extension PhotoEntity {
    func toDomain() -> Photo {
        return Photo(
            identifier: UUID(),
            id: id ?? "",
            width: CGFloat(width),
            height: CGFloat(height),
            urls: URLs(regular: url ?? ""),
            links: Links(html: linkHtml ?? ""),
            user: User(name: userName ?? "")
        )
    }
}
