//
//  PhotoCoreDataRepository.swift
//  Unsplash
//
//  Created by rae on 2022/12/13.
//

import Foundation

protocol PhotoCoreDataRepository {
    func fetchAll() -> [Photo]
    func create(photo: Photo)
    func delete(id: String)
    func isExist(id: String) -> Bool
}
