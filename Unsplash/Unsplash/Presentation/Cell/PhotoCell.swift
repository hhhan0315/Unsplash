//
//  PhotoCell.swift
//  Unsplash
//
//  Created by rae on 2022/05/08.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    static let identifier: String = String(describing: PhotoCell.self)
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.contentMode = .scaleAspectFill
    }
    
    func setImage(_ indexPath: IndexPath, photo: Photo) {
        guard let url = URL(string: photo.urls.small) else { return }
        
        DispatchQueue.global().async {
          if let data = try? Data(contentsOf: url){
            if let image = UIImage(data: data){
              DispatchQueue.main.async {
                  self.imageView.image = image
              }
            }
          }
        }
    }
}
