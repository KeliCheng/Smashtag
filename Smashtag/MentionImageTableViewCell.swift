//
//  MentionImageTableViewCell.swift
//  Smashtag
//
//  Created by ❤ on 12/25/16.
//  Copyright © 2016 Keli Cheng. All rights reserved.
//

import UIKit

class MentionImageTableViewCell: UITableViewCell {
    @IBOutlet weak var mentionImageView: UIImageView!
    

//    var image: UIImage? {
//        get {
//            return imageView.image
//        }
//        set {
//            imageView.image = newValue
//            imageView.sizeToFit()
//        }
//    }
//    
    var imageURL: URL? {
        didSet {
            mentionImageView.image = nil
            fetchImage()
//            adjustImage()
        }
    }

    private func fetchImage() {
        if let url = imageURL {
            DispatchQueue.global(qos: .userInitiated).async {
                let contentsOfURL = NSData(contentsOf: url)
                DispatchQueue.main.async {
                    if url == self.imageURL {
                        if let imageData = contentsOfURL {
                            self.mentionImageView.image = UIImage(data: imageData as Data)!
                        }
                    } else {
                        print("ignored data returned from url \(url)")
                    }
                    
                }
            }
        }
    }
    
//    private func adjustImage() {
//        if Float((mentionImageView.image?.size.width)!) > Float((mentionImageView.image?.size.height)!) {
//            mentionImageView.contentMode = UIViewContentMode.scaleAspectFit
//        } else {
//            mentionImageView.contentMode = UIViewContentMode.scaleAspectFill
//        }
//    }
    
    
}
