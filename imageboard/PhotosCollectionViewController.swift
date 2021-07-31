//
//  PhotosCollectionViewController.swift
//  imageboard
//
//  Created by User on 20.07.2021.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    
    var networkDataFetcher = NetworkDataFetcher()
    
    private var timer: Timer?
    
    var photos = [UnsplashPhoto]()
    
    private var selectedImages = [UIImage]()
    
    private let itemsPerRow: CGFloat = 2 //колличество ячеек в ряду
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    private lazy var actionBarButtonItem: UIBarButtonItem = { //кнопка поделится. иницилизирует себя только когда на неё нажимают
       return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()
    
    private var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
    override func viewDidLoad() { //в вью дид лоад вызываем все наши созданные объекты чтобы они отобразились на экране
        super.viewDidLoad()
        
        
        undateNavButtonsState()
        collectionView.backgroundColor = .white
        setupNavigationBar()
        setupCollectionView()
        setupSearchBar()
    }
    
    private func undateNavButtonsState() {
        actionBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }
    
    func refresh() {
        self.selectedImages.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        undateNavButtonsState()
    }
    
    // MARK: - работа кнопки поделится, она работает с элементами которые выбраны
    
    
    @objc private func actionBarButtonTapped(sender: UIBarButtonItem) {
        print(#function)

      //  let shareController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)


//        shareController.completionWithItemsHandler = { _, bool, _, _ in
//            if bool {
//                self.refresh()
//            }
//        }

//        shareController.popoverPresentationController?.barButtonItem = sender
//        shareController.popoverPresentationController?.permittedArrowDirections = .any
//        present(shareController, animated: true, completion: nil)
    }
    
    
    // MARK: - ячейки и тд
    
    private func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId") //
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseId)
        
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
    }
    
    
    private func setupNavigationBar() { //функция создания объектов в навигейшн баре. создаем иконку с натписью "поиск фотографий"
        let titleLabel = UILabel()
        titleLabel.text = "Поиск фотографий"
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = #colorLiteral(red: 0.5019607843, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel) //ставим его вместо левой кнопки
      //  navigationItem.rightBarButtonItems = [actionBarButtonItem] //правой кнопкой ставим кнопку "поделится"
    }
    
    private func setupSearchBar() { //организовываем строку поиска в навигейшн баре
        let seacrhController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = seacrhController
        seacrhController.hidesNavigationBarDuringPresentation = false
        seacrhController.obscuresBackgroundDuringPresentation = false
        seacrhController.searchBar.delegate = self
    }
    
    // MARK: - вьюшки с фотографиями и описание перехода в FullScreenViewController
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseId, for: indexPath) as! PhotosCell
        let unspashPhoto = photos[indexPath.item]
        cell.unsplashPhoto = unspashPhoto
        return cell
    }
    
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        undateNavButtonsState()
//        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
//        guard let image = cell.photoImageView.image else { return }
//            selectedImages.append(image)
//
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        undateNavButtonsState()
//        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
//        guard let image = cell.photoImageView.image else { return }
//        if let index = selectedImages.firstIndex(of: image) {
//            selectedImages.remove(at: index)
//        }
//   }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let FullScreenVC = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        FullScreenVC.photos = photos
        FullScreenVC.indexPath = indexPath
        self.navigationController?.pushViewController(FullScreenVC, animated: true)
    }
}
    
    


// MARK: - через extension задаём работу строки поиска

extension PhotosCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        timer?.invalidate()
        //указываем работу поиска таким образом чтобы картинка искалась только после окончанния ввода через 0,5 сек
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self] (searchResults) in
                guard let fetchedPhotos = searchResults else { return }
                self?.photos = fetchedPhotos.results
                self?.collectionView.reloadData()
                self?.refresh()
            }
        })
    }
}

// MARK: - авто Layout

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}

