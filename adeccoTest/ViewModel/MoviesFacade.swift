//
//  MovieViewModel.swift
//  adeccoTest
//
//  Created by David Andres Mejia Lopez on 30/08/21.
//

import Foundation
import UIKit

class MoviesFacade {
    private var noImageAvailable = "noImageAvailable"
    
    private var apiService = ApiService()
//    private var popularMovies = [Movie]()
    
    func fetchPopularMoviesData(completion: @escaping ([Movie]) -> ()) {
        
        apiService.getPopularMoviesData { (result) in
            switch result {
            case .success(let listOf):
//                self?.popularMovies = listOf.movies
                completion(listOf.movies)
            case .failure(let error):
                print("Error processing json data: \(error)")
                completion([])
            }
        }
    }
    
    func getImageDataFromAsync(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Datatask error: \(error.localizedDescription)")
                completion(UIImage(named: self.noImageAvailable))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(UIImage(named: self.noImageAvailable))
                return
            }
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                completion(UIImage(named: self.noImageAvailable))
                return
            }
            
            if let image = UIImage(data: data) {
                completion(image)
            }
        }.resume()
    }
    
    
    func numberOfItemsInSection(section: Int) -> Int {
//        if popularMovies.count != 0 {
//            return popularMovies.count
//        }
        return 0
    }
    
//    func cellForRowAt (indexPath: IndexPath) -> Movie {
//        return popularMovies[indexPath.row]
//    }
}
