//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Евгений Дроздов on 25.04.2023.
//

import CoreData

class CoreDataManager {

    static let shared = CoreDataManager()

    init(){
        reloadData()
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "note")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror.localizedDescription), \(nserror.userInfo)")
            }
        }
    }

    var posts = [Posts]()

    func reloadData(){
        let request = Posts.fetchRequest()
        let posts = (try? persistentContainer.viewContext.fetch(request)) ?? []
        self.posts = posts
    }

    func createPost(title: String, image: String, author: String, description: String, likes: Int, views: Int, id: String){
        let posts = Posts(context: persistentContainer.viewContext)
        posts.title = title
        posts.image = image
        posts.author = author
        posts.descriptionOfPost = description
        posts.likes = Int16(likes)
        posts.view = Int16(views)
        posts.id = id
        saveContext()
        reloadData()
    }

    func deletePostTypeNote(post: Posts){
        persistentContainer.viewContext.delete(post)
        saveContext()
        reloadData()
    }
}
