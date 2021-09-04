//
//  MovieViewModel.swift
//  adeccoTest
//
//  Created by David Andres Mejia Lopez on 30/08/21.
//

import Foundation
import UIKit

class MovieViewModel {
    private var apiService = ApiService()
    private var popularMovies = [Movie]()
    
    func fetchPopularMoviesData(completion: @escaping () -> ()) {
        
        apiService.getPopularMoviesData { [weak self] (result) in
            switch result {
            case .success(let listOf):
                self?.popularMovies = listOf.movies
                completion()
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
        }
    }
    
    func getImageDataFrom(vc: DetailViewController, url: URL) {
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
            if let image = UIImage(data: data) {
                vc.mImage = image
            }
        }.resume()
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if popularMovies.count != 0 {
            return popularMovies.count
        }
        return 0
    }
    
    func cellForRowAt (indexPath: IndexPath) -> Movie {
        return popularMovies[indexPath.row]
    }
}
