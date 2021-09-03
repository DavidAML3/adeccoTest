//
//  ViewController.swift
//  adeccoTest
//
//  Created by David Andres Mejia Lopez on 30/08/21.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = MovieViewModel()
    private var urlString: String = ""
    private var detailVC = "DetailViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(MovieCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        loadPopularMoviesData()
    }
    
    private func loadPopularMoviesData() {
        viewModel.fetchPopularMoviesData { [weak self] in
            self?.collectionView.dataSource = self
            self?.collectionView.delegate = self
            self?.collectionView.reloadData()
        } 
    }
}

// MARK: - TableView
//extension MovieViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.numberOfRowsInSection(section: section)
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
//
//        let movie = viewModel.cellForRowAt(indexPath: indexPath)
//        cell.setCellWithValuesOf(movie)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
//            self.navigationController?.pushViewController(vc, animated: true)
//            let movie = viewModel.cellForRowAt(indexPath: indexPath)
//            vc.mTitle = movie.title!
//
//            guard let posterString = movie.posterImage else { return }
//            urlString = "https://image.tmdb.org/t/p/w300" + posterString
//
//            guard let posterImageURL = URL(string: urlString) else {
//                vc.mImage = UIImage(named: "noImageAvailable")!
//                return
//            }
//
//            viewModel.getImageDataFrom(vc: vc, url: posterImageURL)
//
//            vc.mOverview = movie.overview!
//        }
//    }
//}

// MARK: - CollectionView
extension MovieViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        
        let movie = viewModel.cellForRowAt(indexPath: indexPath)
        cell.setCellWithValuesOf(movie)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: detailVC) as? DetailViewController {
            self.navigationController?.pushViewController(vc, animated: true)
            let movie = viewModel.cellForRowAt(indexPath: indexPath)
            vc.mTitle = movie.title!
            
            guard let posterString = movie.posterImage else { return }
            urlString = "https://image.tmdb.org/t/p/w300" + posterString
            
            guard let posterImageURL = URL(string: urlString) else {
                vc.mImage = UIImage(named: "noImageAvailable")!
                return
            }
            
            viewModel.getImageDataFrom(vc: vc, url: posterImageURL)
            
            vc.mOverview = movie.overview!
        }

    }
}
