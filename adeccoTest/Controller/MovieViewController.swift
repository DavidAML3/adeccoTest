//
//  ViewController.swift
//  adeccoTest
//
//  Created by David Andres Mejia Lopez on 30/08/21.
//

import UIKit

protocol MovieViewProtocol: AnyObject {
    func updateMovies(_ movies: [Movie])
}

class MovieViewController: UIViewController {
    
    private var popularMovies = [Movie]()
    lazy var presenter = MoviePresenter(view: self)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel = MoviesFacade()
    private var urlString: String = ""
    private var detailVC = "DetailViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(MovieCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        setupNavBar()
        setupCollectionView()
        presenter.getPopularMovies()
//        loadPopularMoviesData()
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "Movies"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .systemTeal
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Movies"
        titleLabel.font = UIFont.systemFont(ofSize: 30)
        titleLabel.textColor = .systemTeal
        titleLabel.backgroundColor = .black
        navigationItem.titleView = titleLabel
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .black
    }
    
    //    private func loadPopularMoviesData() {
    //        viewModel.fetchPopularMoviesData { [weak self] in
    //            self?.collectionView.dataSource = self
    //            self?.collectionView.delegate = self
    //            self?.collectionView.reloadData()
    //        }
    //    }
}

// MARK: - CollectionView DataSource
extension MovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularMovies.count
//        return viewModel.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        
//        let movie = viewModel.cellForRowAt(indexPath: indexPath)
        let movie = popularMovies[indexPath.item]
        cell.setCellWithValuesOf(movie)
        
        return cell
    }
}

// MARK: - CollectionView Delegate
extension MovieViewController: UICollectionViewDelegate {
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

            viewModel.getImageDataFromAsync(url: posterImageURL) { movieImage in
                guard let movieImage = movieImage else {
                    return
                }
                vc.mImage = movieImage
            }

            if let movieOverview = movie.overview, movieOverview == "" {
                vc.mOverview = "No overview registed for \(movie.title ?? "This movie")"
                return
            }
            vc.mOverview = movie.overview!
        }
    }
}

// MARK: CollectonView FlowLayout

extension MovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.size.width/3)-3
        return CGSize(width: width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
}

extension MovieViewController: MovieViewProtocol {
    func updateMovies(_ movies: [Movie]) {
        popularMovies = movies
        collectionView.reloadData()
    }
}
