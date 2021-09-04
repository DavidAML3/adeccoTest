//
//  ViewController.swift
//  adeccoTest
//
//  Created by David Andres Mejia Lopez on 30/08/21.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = MovieViewModel()
    private var urlString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPopularMoviesData()
    }
    
    private func loadPopularMoviesData() {
        viewModel.fetchPopularMoviesData { [weak self] in
            self?.tableView.dataSource = self
            self?.tableView.delegate = self
            self?.tableView.reloadData()
        } 
    }
}

// MARK: - TableView
extension MovieViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        
        let movie = viewModel.cellForRowAt(indexPath: indexPath)
        cell.setCellWithValuesOf(movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
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
