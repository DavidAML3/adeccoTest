//
//  DetailViewController.swift
//  adeccoTest
//
//  Created by David Andres Mejia Lopez on 2/09/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieOverview: UILabel!
    
    var mImage = UIImage()
    var mTitle = ""
    var mOverview = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupAppearance()
        setupCollectionView()
    }
    
    private func fetchData() {
        movieTitle.text = mTitle
        posterImage.image = mImage
        movieOverview.text = mOverview
    }
    
    private func setupAppearance() {
        movieOverview.textColor = .white
    }
    
    private func setupCollectionView() {
        view.backgroundColor = .black
    }
}
