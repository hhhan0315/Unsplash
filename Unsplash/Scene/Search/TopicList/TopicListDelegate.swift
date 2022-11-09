//
//  TopicListDelegate.swift
//  Unsplash
//
//  Created by rae on 2022/11/08.
//

import UIKit

final class TopicListDelegate: NSObject, UICollectionViewDelegate {
    var topics: [Topic] = []
    var selectTopicClosure: ((Topic) -> Void)?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topic = topics[indexPath.item]
        selectTopicClosure?(topic)
    }
}
