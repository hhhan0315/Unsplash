//
//  TopicListDataSource.swift
//  Unsplash
//
//  Created by rae on 2022/11/08.
//

import UIKit

final class TopicListDataSource: NSObject, UICollectionViewDataSource {
    var topics: [Topic] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicListCollectionViewCell.identifier, for: indexPath) as? TopicListCollectionViewCell else {
            return .init()
        }
        
        let topic = topics[indexPath.item]
        cell.topic = topic
        return cell
    }
}
