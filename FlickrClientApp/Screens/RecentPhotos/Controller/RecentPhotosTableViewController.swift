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
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        fetchRecentPhotos()
    }
    
    private func fetchRecentPhotos() {
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=6f890008043d60b079d83bbf4b0aa763&format=json&nojsoncallback=1&extras=description,license,date_upload,date_taken,owner_name,icon_server,original_format,last_update,geo,tags,machine_tags,o_dims,views,media,path_alias,url_sq,url_t,url_s,url_q,url_m,url_n,url_z,url_c,url_l,url_o") else { return }
        
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
        guard let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=6f890008043d60b079d83bbf4b0aa763&text=flower&format=json&nojsoncallback=1&extras=description,license,date_upload,date_taken,owner_name,icon_server,original_format,last_update,geo,tags,machine_tags,o_dims,views,media,path_alias,url_sq,url_t,url_s,url_q,url_m,url_n,url_z,url_c,url_l,url_o") else { return }
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
        cell.mainImageView.backgroundColor = .gray
        cell.titleLabel.text = photo?.title
        
        return cell
    }
    
    //when select the row will work this method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toPhotoDetail", sender: nil)
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        // FIXME: Fix warning
        if let viewController = segue.destination as? PhotoDetailViewController {
            // TODO: Show selected image in deetail view
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

