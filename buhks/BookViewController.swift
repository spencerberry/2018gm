//
//  BookViewController.swift
//  buhks
//
//  Created by Spencer Berry on 10/1/18.
//  Copyright © 2018 a8c. All rights reserved.
//

import UIKit
import Kingfisher

struct BookViewModel{
    let title: String
    let subtitle: String
    let author: String
    let extendedDescription: String
    let thumbnail: String
}

class BookViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var bookCoverImage: UIImageView!
    
    var book: BookViewModel = BookViewModel(
        title: "Neuromancer",
        subtitle: "Better than the Matrix",
        author: "Gibson, William",
        extendedDescription: "The sky above the port was the color of television, tuned to a dead channel.",
        thumbnail: ""
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignTitle()
        assignSubtitle()
        assignAuthor()
        assignDescription()
        assignThumbnail()
    }
    
    private func assignTitle(){
        titleLabel.text = book.title
        authorLabel.text = book.author
        descriptionTextView.text = book.extendedDescription
    }
    
    private func assignSubtitle(){
        subtitleLabel.text = book.subtitle
        subtitleLabel.textColor = .gray
    }
    
    private func assignAuthor(){
        authorLabel.text = book.author
    }
    
    private func assignDescription(){
        descriptionTextView.text = book.extendedDescription
    }
    
    private func assignThumbnail(){
        let url = book.thumbnail
        guard let thumbnailURL = URL(string: url) else{
            return
        }
        
        let resource = ImageResource(downloadURL: thumbnailURL)
        bookCoverImage.kf.setImage(with: resource)
    }
    
}
