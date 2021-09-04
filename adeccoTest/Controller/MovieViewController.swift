//
//  ViewController.swift
//  adeccoTest
//
//  Created by David Andres Mejia Lopez on 30/08/21.
//

import UIKit

class MovieViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel = MovieViewModel()
    private var urlString: String = ""
    private var detailVC = "DetailViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(MovieCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        setupNavBar()
        setupCollectionView()
        loadPopularMoviesData()
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
    
    private func loadPopularMoviesData() {
        viewModel.fetchPopularMoviesData { [weak self] in
            self?.collectionView.dataSource = self
            self?.collectionView.delegate = self
            self?.collectionView.reloadData()
        } 
    }
}

// MARK: - CollectionView DataSource
extension MovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        
        let movie = viewModel.cellForRowAt(indexPath: indexPath)
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
//            vc.mOverview = movie.overview!
            vc.mOverview = "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat."
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
