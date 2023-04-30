//
//  FavouriteViewController.swift
//  Navigation
//
//  Created by Евгений Дроздов on 25.04.2023.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController {

    var coreDataManager = CoreDataManager()
    var id = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        coreDataManager.reloadData()
        createDataForCoreData()
        tableView.reloadData()
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemGray6
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private func setupView(){
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Favorite"
        createDataForCoreData()
        view.addSubview(tableView)

        // настройка Constrait
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func createDataForCoreData(){
        if coreDataManager.posts.count > 0 {
            for i in coreDataManager.posts {
                id.append(i.id!)
            }
        }
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coreDataManager.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PostTableViewCell {
            let idForPost = id[indexPath.row]
            cell.backgroundColor = .white
            cell.setupForFavoriteFromCoreData(for: idForPost)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let post = coreDataManager.posts[indexPath.row]
            coreDataManager.deletePostTypeNote(post: post)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
