//
//  MovieCollectionViewCell.swift
//  adeccoTest
//
//  Created by David Andres Mejia Lopez on 3/09/21.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    static let identifier = "MovieCollectionViewCell"
    
    
    private var urlString: String = ""
    private var movieTitle: String = ""
    private var movieOverview: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func setCellWithValuesOf(_ movie: Movie) {
        updateUI(title: movie.title, overview: movie.overview, poster: movie.posterImage)
    }
    
    // Update the UI Views
    private func updateUI(title: String?, overview: String?, poster: String?) {
        
        self.movieTitle = title!
        self.movieOverview = overview!
        
        guard let posterString = poster else { return }
        urlString = "https://image.tmdb.org/t/p/w300" + posterString
        
        guard let posterImageURL = URL(string: urlString) else {
            self.posterImage.image = UIImage(named: "noImageAvailable")
            return
        }
        
        // Before we download the image we clear out the old one
        self.posterImage.image = nil
        
        getImageDataFrom(url: posterImageURL)
    }
    
    // MARK: - Get image data
    private func getImageDataFrom(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Datatask error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.posterImage.image = image
                }
            }
        }.resume()
    }
}
