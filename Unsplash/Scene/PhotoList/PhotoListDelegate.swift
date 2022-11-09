//
//  PhotoListDelegate.swift
//  Unsplash
//
//  Created by rae on 2022/11/08.
//

import UIKit

final class PhotoListDeleagte: NSObject, UICollectionViewDelegateFlowLayout {
    var photos: [Photo] = []
    var willDisplayClosure: (() -> Void)?
    var selectPhotoClosure: ((Photo) -> Void)?
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == photos.count - 1 {
            willDisplayClosure?()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.item]
        selectPhotoClosure?(photo)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = UIScreen.main.bounds.width
        let imageHeight = photos[indexPath.item].height
        let imageWidth = photos[indexPath.item].width
        let imageRatio = imageHeight / imageWidth
        
        return CGSize(width: cellWidth, height: imageRatio * cellWidth)
    }
}
