//
//  ViewController.swift
//  SearchPhoto
//
//  Created by Umut Ağbaba on 21.04.2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    
    let urlString = "https://api.unsplash.com/search/photos/?client_id=Rgq5NTjnJh6edtfnfJh4V948XyO5ygSw8nkVI5a4bu0&&per_page=30&query=office"
    
    private var collectionView: UICollectionView?
    
    var results: [Result] = []
    
    let searchBar = UISearchBar()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width / 2,
                                 height: view.frame.size.width / 2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifer)
        collectionView.dataSource = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
        view.addSubview(searchBar)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: 10, y: view.safeAreaInsets.top,
                                 width: view.frame.size.width - 20,
                                 height: 50)
        collectionView?.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 55,
                                       width: view.frame.size.width,
                                       height: view.frame.size.height - 55)
    }
    
    func fetchPhotos(query: String) {
        let urlString = "https://api.unsplash.com/search/photos/?client_id=Rgq5NTjnJh6edtfnfJh4V948XyO5ygSw8nkVI5a4bu0&&per_page=30&query=\(query)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.results = jsonResult.results
                    self?.collectionView?.reloadData()
                }
            }
            catch  {
                print(error)
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURLString = results[indexPath.row].urls.regular
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifer, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell()}
        cell.configure(with: imageURLString)
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            results = []
            collectionView?.reloadData()
            fetchPhotos(query: text)
        }
    }
}

