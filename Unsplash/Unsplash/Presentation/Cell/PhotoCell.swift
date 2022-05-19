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
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.image = nil
        self.imageView.contentMode = .scaleAspectFill
        self.nameLabel.text = nil
        self.nameLabel.textColor = .white
        self.nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    func setImage(_ indexPath: IndexPath, photo: Photo) {
        guard let url = URL(string: photo.urls.small) else { return }
        let name = photo.user.name
        
//        self.imageView.setImageUrl(id: photo.id, url: url, indexPath: indexPath)
//        self.nameLabel.text = name
        
        DispatchQueue.global().async {
          if let data = try? Data(contentsOf: url){
            if let image = UIImage(data: data){
              DispatchQueue.main.async {
                  self.imageView.image = image
                  self.nameLabel.text = name
              }
            }
          }
        }
    }
}
