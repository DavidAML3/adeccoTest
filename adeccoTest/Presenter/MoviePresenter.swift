//
//  MoviePresenter.swift
//  adeccoTest
//
//  Created by David Andres Mejia Lopez on 13/09/21.
//

import Foundation

protocol MoviePresenterProtocol {
    func getPopularMovies()
}

class MoviePresenter {
    weak var movieView: MovieViewProtocol?
    private var facade = MoviesFacade()
    
    init(view: MovieViewProtocol) {
        self.movieView = view
    }
    
    
}

extension MoviePresenter: MoviePresenterProtocol {
    func getPopularMovies() {
        facade.fetchPopularMoviesData(completion: { [weak self] movies in
            self?.movieView?.updateMovies(movies)
        })
    }
}
