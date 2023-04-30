//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Евгений Дроздов on 24.10.2022.
//

import UIKit
import iOSIntPackage

class PostTableViewCell: UITableViewCell {
    
    let coreDataManager = CoreDataManager()
    var index: IndexPath?
    
    
    private(set) lazy var authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.font = .systemFont(ofSize: 20, weight: .bold)
        authorLabel.textColor = .black
        authorLabel.numberOfLines = 2
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        return authorLabel
    }()
    
    private lazy var titlePostLabel: UILabel = {
        let title = UILabel()
        title.font = .boldSystemFont(ofSize: 20)
        title.numberOfLines = 2
        title.textColor = .black
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var viewPostLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16)
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private(set) lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = .systemGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private(set) lazy var likesViewsLabel: UILabel = {
        let likesViewsLabel = UILabel()
        likesViewsLabel.font = .systemFont(ofSize: 16, weight: .regular)
        likesViewsLabel.textColor = .black
        likesViewsLabel.translatesAutoresizingMaskIntoConstraints = false
        return likesViewsLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapFunc))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
        
        self.contentView.addSubview(authorLabel)
        self.contentView.addSubview(postImageView)
        self.contentView.addSubview(descriptionLabel)
        self.contentView.addSubview(likesViewsLabel)
        self.contentView.addSubview(viewPostLabel)
        
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            authorLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            postImageView.topAnchor.constraint(equalTo: self.authorLabel.bottomAnchor, constant: 12),
            postImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            postImageView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: self.postImageView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            likesViewsLabel.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 16),
            likesViewsLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            likesViewsLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            likesViewsLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            
            viewPostLabel.topAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor, constant: -8),
            viewPostLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            viewPostLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
        ])
        
        
        
    }
    
    func setupForFavoriteFromCoreData(for postID: String){
        coreDataManager.reloadData()
        if let index = coreDataManager.posts.firstIndex(where: { $0.id == postID })  {
            titlePostLabel.text = coreDataManager.posts[index].title
            authorLabel.text = coreDataManager.posts[index].author
            descriptionLabel.text = coreDataManager.posts[index].descriptionOfPost
            postImageView.image = UIImage(named: coreDataManager.posts[index].image!)
            likesViewsLabel.text = "Likes: \(coreDataManager.posts[index].likes)"
            viewPostLabel.text = "Views: \(coreDataManager.posts[index].view)"
        }
    }
    
    @objc func doubleTapFunc() {
        if index != nil {
            let model = [post1, post2, post3, post4]
            print(model)
            
            if let _ = coreDataManager.posts.firstIndex(where: { $0.id == model[index!.row].uniqID }) {
                print("Заметка уже существует" + " " + "Добавление заметки еще раз невозможно")
            } else {
                coreDataManager.createPost(title: model[index!.row].title,
                                           image: model[index!.row].image,
                                           author: model[index!.row].author,
                                           description: model[index!.row].description,
                                           likes: model[index!.row].likes,
                                           views: model[index!.row].views,
                                           id: model[index!.row].uniqID)
                coreDataManager.reloadData()
            }
        } else {
            print("Index is nil when DoubleTap")
        }
    }
    
//    func setup(with post: Post){
//        ImageProcessor().processImage(sourceImage: UIImage(named: post.image)!, filter: .tonal) { image in
//            postImageView.image = image
//
//        }
        
        
        
//    }
    
}


