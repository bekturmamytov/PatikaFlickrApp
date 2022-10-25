//
//  RecentPhotosTableViewController.swift
//  FlickrClientApp
//
//  Created by Bektur Mamytov on 24/10/22.
//

import UIKit

class RecentPhotosTableViewController: UITableViewController, UISearchResultsUpdating {
    
    private var response: PhotosRersponse? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    private var selectedPhoto: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        fetchRecentPhotos()
    }
    
    private func fetchRecentPhotos() {
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=6f890008043d60b079d83bbf4b0aa763&format=json&nojsoncallback=1&extras=description,owner_name,icon_server,url_n,url_z") else { return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                debugPrint(error)
                return //asagidaki kodlarin calismamasi icin bu yazilir
            }
            if let data = data, let response = try? JSONDecoder().decode(PhotosRersponse.self, from: data) {
                self.response = response
            }
        }.resume()//To activate URLSession
    }
    
    private func searchPhotos(with text: String) {
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=6f890008043d60b079d83bbf4b0aa763&text=\(text)&format=json&nojsoncallback=1&extras=description,owner_name,icon_server,url_n,url_z") else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                debugPrint(error)
                return //asagidaki kodlarin calismamasi icin bu yazilir
            }
            if let data = data, let response = try? JSONDecoder().decode(PhotosRersponse.self, from: data) {
                self.response = response
            }
        }.resume()//To activate URLSession
    }
    // MARK: - UITableViewDataSource & UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response?.photos?.photo?.count ?? .zero
    }
    
    //to create cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //FIXME: Burada bir optional kaynakli bir hata olusabilir.
        let photo = response?.photos?.photo?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoTableViewCell
        cell.profileImageView.backgroundColor = .darkGray
        cell.profileLabel.text = photo?.ownername
        
        //profileImage add
        
        NetworkManager.shared.fetchImage(with: photo?.bodyIconUrl) { data in
            cell.profileImageView.image = UIImage(data: data)
        }
        
        NetworkManager.shared.fetchImage(with: photo?.urlN) { data in
            cell.mainImageView.image = UIImage(data: data)
        }
        
        cell.titleLabel.text = photo?.title
        
        return cell
    }
    
    //when select the row will work this method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPhoto = response?.photos?.photo?[indexPath.row]
        performSegue(withIdentifier: "toPhotoDetail", sender: nil)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let viewController = segue.destination as? PhotoDetailViewController {
            viewController.photo = selectedPhoto
        }
    }
    
    // MARK: - UISearchResultsUpdating
    private func setupSearchController() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count > 2 {
            searchPhotos(with: text)
        }
        
    }
    
    

}

