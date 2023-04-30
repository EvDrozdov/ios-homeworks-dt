//
//  Post.swift
//  Navigation
//
//  Created by Евгений Дроздов on 17.10.2022.
//

import UIKit



struct Post {
    
    var title: String
    var author: String
    var image: String
    var description: String
    var likes: Int
    var views: Int
    let uniqID: String
    
}


    
   

let post1 = Post(title: "Цельнометаллическая оболочка",
                 author: "Стенли Кубрик",
                 image: "Post1",
                 description: "Военная драма",
                 likes: Int.random(in: 1...1000),
                 views: Int.random(in: 1...10000),
                 uniqID: UUID().uuidString)
let post2 = Post(title: "Кольца силы",
                 author: "Нетфликс",
                 image: "Post2",
                 description: "Фентези",
                 likes: Int.random(in: 1...1000),
                 views: Int.random(in: 1...10000),
                 uniqID: UUID().uuidString)
let post3 = Post(title: "Ведьмак",
                 author: "Нетфликс и Спаковский",
                 image: "Post3",
                 description: "Сериал про Геральта из Ривии",
                 likes: Int.random(in: 1...1000),
                 views: Int.random(in: 1...10000),
                 uniqID: UUID().uuidString)
let post4 = Post(title: "Робокоп",
                 author: "Пол Верховен",
                 image: "Post4",
                 description: "Фильм про киборга",
                 likes: Int.random(in: 1...1000),
                 views: Int.random(in: 1...10000),
                 uniqID: UUID().uuidString)




struct PostImage {
    var image: String

    static func setupImages() -> [PostImage]{
        let data = ["1.jpg","2.jpg","3.jpg","4.jpg","5.jpg","6.jpg","7.jpg","8.jpg","9.jpg","10.jpg","11.jpg","12.jpg","13.jpg","14.jpg","15.jpg","16.jpg","17.jpg","18.jpg","19.jpg","20.jpg",]

        var tempImage = [PostImage]()
        for (_, names) in data.enumerated() {
            tempImage.append(PostImage(image: names))
        }
        return tempImage
    }
}



