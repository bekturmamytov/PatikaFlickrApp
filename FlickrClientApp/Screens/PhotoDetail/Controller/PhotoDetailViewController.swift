//
//  PhotoDetailViewController.swift
//  FlickrClientApp
//
//  Created by Bektur Mamytov on 24/10/22.
//

import UIKit
import LoremIpsum


class PhotoDetailViewController: UIViewController {
    
    var photo: Photo?
    
    @IBOutlet weak var detailMainImageView: UIImageView!
    @IBOutlet weak var detailProfileImageView: UIImageView!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailProfileNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Photo Detail"
        detailMainImageView.backgroundColor = .gray
        detailProfileImageView.backgroundColor = .darkGray
        detailProfileNameLabel.text = "Profile name"
        //detailDescriptionLabel.text = LoremIpsum.paragraph
        detailDescriptionLabel.lineBreakMode = .byWordWrapping
        
        detailProfileNameLabel.text = photo?.ownername
        
        //profileImage add
        NetworkManager.shared.fetchImage(with: photo?.bodyIconUrl) { data in
            self.detailProfileImageView.image = UIImage(data: data)
        }
        
        NetworkManager.shared.fetchImage(with: photo?.urlZ) { data in
            self.detailMainImageView.image = UIImage(data: data)
        }
        
        title = photo?.title
        
        detailDescriptionLabel.text = photo?.welcomeDescription?.content
    }
    

}
