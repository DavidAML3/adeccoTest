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
        
        movieTitle.text = mTitle
        posterImage.image = mImage
        movieOverview.text = mOverview
    }

}
