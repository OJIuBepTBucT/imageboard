//
//  ViewController.swift
//  imageboard
//
//  Created by User on 20.07.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var indexPath:IndexPath!
    
    var networkDataFetcher = NetworkDataFetcher()
    
    private var timer: Timer?
    
    var photos = [UnsplashPhoto]()
    
    private var selectedImages = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
       
        FullScreenViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        setupNavigationBar()
            
    }
    
    private func setupNavigationBar() { //функция создания объектов в навигейшн баре. создаем иконку с натписью "поиск фотографий"
        let titleLabel = UILabel()
        titleLabel.text = "инфо"
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = #colorLiteral(red: 0.5019607843, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel) //ставим его вместо левой кнопки
      //  navigationItem.rightBarButtonItems = [actionBarButtonItem] //правой кнопкой ставим кнопку "поделится"
    }

}

