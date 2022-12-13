//
//  PhotoCoreDataRepository.swift
//  Unsplash
//
//  Created by rae on 2022/12/13.
//

import Foundation

protocol PhotoCoreDataRepository {
    func fetchAll() async throws -> [Photo]
    func create(photo: Photo) async throws -> ()
    func delete(id: String) async throws -> ()
    func isExist(id: String) async throws -> Bool
}
