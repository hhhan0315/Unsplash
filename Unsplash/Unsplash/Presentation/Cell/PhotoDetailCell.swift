//
//  PhotoDetailCell.swift
//  Unsplash
//
//  Created by rae on 2022/05/19.
//

import UIKit

class PhotoDetailCell: UICollectionViewCell {
    static let identifier: String = String(describing: PhotoDetailCell.self)
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageView.image = nil
        self.imageView.contentMode = .scaleAspectFit
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
