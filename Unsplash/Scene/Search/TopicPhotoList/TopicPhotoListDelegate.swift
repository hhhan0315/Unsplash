//
//  TopicPhotoListDelegate.swift
//  Unsplash
//
//  Created by rae on 2022/11/08.
//

import UIKit

final class TopicPhotoListDelegate: NSObject, UICollectionViewDelegate {
    var photos: [Photo] = []
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == photos.count - 1 {
            // 네트워크 요청 또 해주세요.
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 사진 클릭 시 PhotoDetail 이동
    }
}
