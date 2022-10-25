//
//  PhotoDetailViewController.swift
//  FlickrClientApp
//
//  Created by Bektur Mamytov on 24/10/22.
//

import UIKit
import LoremIpsum


class PhotoDetailViewController: UIViewController {
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
        detailDescriptionLabel.text = LoremIpsum.paragraph
        detailDescriptionLabel.lineBreakMode = .byWordWrapping
    }
    

}
