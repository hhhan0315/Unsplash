//
//  PhotoListDataSource.swift
//  Unsplash
//
//  Created by rae on 2022/11/08.
//

import UIKit

final class PhotoListDataSource: NSObject, UICollectionViewDataSource {
    var photos: [Photo] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return .init()
        }
        let photo = self.photos[indexPath.item]
        cell.photo = photo
        return cell
    }
}
