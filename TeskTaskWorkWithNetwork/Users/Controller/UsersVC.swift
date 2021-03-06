//
//  ViewController.swift
//  TeskTaskWorkWithNetwork
//
//  Created by Максим Окунеев on 2/19/20.
//  Copyright © 2020 Максим Окунеев. All rights reserved.
//

import UIKit

class UsersVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var users = [User]()
    var albums = [Album]()
    private let networkManagerMainData =  NetworkManagerMainData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsersData()
        fetchAlbumsData()
        self.tableView.tableFooterView = UIView()
    }
    
    @IBAction func updateUsers(_ sender: Any) {
        fetchUsersData()
        fetchAlbumsData()
        
    }
}

// MARK: Network
extension UsersVC {
    private func fetchUsersData() {
        networkManagerMainData.fetchUsersData() { [weak self]  (users, error)  in
            guard let users = users else {
                print(error ?? "")
                    DispatchQueue.main.async {
                        self?.alertNetwork(message: error ?? "")
                    }
                    return
                }
            self?.users = users
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func fetchAlbumsData() {
        networkManagerMainData.fetchAlbumData() { [weak self] (albums, error) in
            guard let albums = albums else {
                print(error ?? "")
                DispatchQueue.main.async {
                    self?.alertNetwork(message: error ?? "")
                }
                return
            }
            self?.albums = albums
            
        }
    }
}


// MARK: Navigation
extension UsersVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photosVC" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = users[indexPath.row]
            let photosVC = segue.destination as! PhotosVC
            let filterAlbums = albums.filter{ $0.userId == user.id }
            photosVC.albumsIDs = filterAlbums.compactMap { $0.id }
        }
    }
}

// MARK: TableViewDataSource
extension UsersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersVCCell", for: indexPath) as! UsersTableViewCell
        let user = users[indexPath.row]
        cell.configere(with: user)
        return cell
    }
}

//MARK: Alert
extension UsersVC  {
    func alertNetwork(message: String) {
        UIAlertController.alert(title:"Error", msg:"\(message)", target: self)
    }
}


