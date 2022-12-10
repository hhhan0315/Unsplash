//
//  PhotoListDelegate.swift
//  Unsplash
//
//  Created by rae on 2022/11/08.
//

import UIKit

protocol PhotoListDelegateActionListener: AnyObject {
    func willDisplayLast()
    func didSelect(with photo: Photo)
}

final class PhotoListDeleagte: NSObject, UICollectionViewDelegateFlowLayout {
    var photos: [Photo] = []
    
    weak var listener: PhotoListDelegateActionListener?
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if photos.count >= Constants.perPage && indexPath.item == photos.count - 1 {
            listener?.willDisplayLast()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        listener?.didSelect(with: photo)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = UIScreen.main.bounds.width
        let imageHeight = photos[indexPath.item].height
        let imageWidth = photos[indexPath.item].width
        let imageRatio = imageHeight / imageWidth
        
        return CGSize(width: cellWidth, height: imageRatio * cellWidth)
    }
}
