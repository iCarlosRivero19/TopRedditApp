//
//  RedditCell.swift
//  TopRedditApp
//
//  Created by Carlos Mendoza on 3/4/24.
//

import Foundation
import UIKit
import Kingfisher
import Combine

class PostCell: UITableViewCell {
    
    @IBOutlet weak var subredditLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var numCommentsLbl: UILabel!
    @IBOutlet weak var createdlbl: UILabel!
    
    private var post: Post!
    var event: PassthroughSubject<TopPostCellEvent, Never> = .init()
    var cancellable = Set<AnyCancellable>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let primaryGesture = UITapGestureRecognizer(target: self, action: #selector(didSelectPost))
        addGestureRecognizer(primaryGesture)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellable = Set<AnyCancellable>()
    }
    
    @objc private func didSelectPost() {
        event.send(.selected(post))
    }
    
    func configure(post: Post) {
        self.post = post
        subredditLbl.text = post.subredditDisplay
        titleLbl.text = post.title
        authorLbl.text = post.author
        numCommentsLbl.attributedText = "\(post.numComments ?? 0)".numCommentsAttibutedString()
        createdlbl.text = Date.redditPostDateFormat(unix: post.created ?? 0)
        if let thumbnailStr = post.thumbnail, let thumbnailURL = URL(string: thumbnailStr) {
            thumbnailImg.isHidden = false
            thumbnailImg.kf.setImage(with: thumbnailURL, placeholder: Resources.Images.placeholderPost)
        } else {
            thumbnailImg.isHidden = true
        }
    }
}

extension PostCell {
    static var nibName: String {
        return "PostCell"
    }
    
    static var reuseIdentifierName: String {
        return "postCell"
    }
}
