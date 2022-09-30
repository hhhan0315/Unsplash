//
//  PhotoCellViewModel.swift
//  Unsplash
//
//  Created by rae on 2022/09/30.
//

import Foundation

struct PhotoCellViewModel {
    let id: String
    let titleText: String
    let imageURL: String
    let imageWidth: Int
    let imageHeight: Int
}

extension PhotoCellViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
