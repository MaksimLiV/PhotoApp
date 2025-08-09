//
//  MainViewController.swift
//  PhotoApp
//
//  Created by Maksim Li on 30/07/2025.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - UI Elements
    private let tableView = UITableView()
    
    // MARK: - Data
    private var photos: [Photo] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
        loadPhotos()
    }
    
    private func setupUI() {
        title = "Photos"
        view.backgroundColor = .systemBackground
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 84
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "PhotoCell")
    }
    
    private func loadPhotos() {
        NetworkManager.shared.fetchPhotos { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos = photos
                self?.tableView.reloadData()
            case .failure(let error):
                print("Loading error: \(error.userFriendlyMessage)")
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoTableViewCell
        let photo = photos[indexPath.row]
        cell.configure(with: photo)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let photo = photos[indexPath.row]
        print("Selected: \(photo.title)")
    }
}
