//
//  PinterestLayout.swift
//  Unsplash
//
//  Created by rae on 2022/05/31.
//

import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
    func numberOfItemsInCollectionView() -> Int
}

final class PinterestLayout: UICollectionViewLayout {
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
        
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    weak var delegate: PinterestLayoutDelegate?
        
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        cache.removeAll()
                
        let numberOfColumns: Int = 2
        let cellWidth = contentWidth / CGFloat(numberOfColumns)
        let cellPadding: CGFloat = 1
        
        let xOffset: [CGFloat] = [0, cellWidth]
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        var currentColumn: Int = 0
        
        let numberOfItems = delegate?.numberOfItemsInCollectionView() ?? 0
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let imageHeight = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 100
            
            let frame = CGRect(x: xOffset[currentColumn], y: yOffset[currentColumn], width: cellWidth, height: imageHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[currentColumn] = yOffset[currentColumn] + imageHeight
            
            currentColumn = yOffset[0] > yOffset[1] ? 1 : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
