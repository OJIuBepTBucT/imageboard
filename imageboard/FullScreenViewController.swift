import UIKit
private let reuseIdentifier = "FullScreenViewController"

class FullScreenViewController: UICollectionViewController {
  var networkDataFetcher = NetworkDataFetcher()
  var indexPath: IndexPath!
  private var timer: Timer?
  var photos = [UnsplashPhoto]()
  private var selectedImages = [UIImage]()
  private let itemsPerRow: CGFloat = 1 //колличество ячеек в ряду
  private let sectionInserts = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  private lazy var actionBarButtonItem: UIBarButtonItem = { //кнопка поделиться. иницилизирует себя только когда на неё нажимают
    return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
  }()
  private var numberOfSelectedPhotos: Int {
    return collectionView.indexPathsForSelectedItems?.count ?? 0
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    undateNavButtonsState()
    collectionView.backgroundColor = .white
    collectionView.isPagingEnabled = true
    setupNavigationBar()
    setupCollectionView()
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
    let shareController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
    shareController.completionWithItemsHandler = { _, bool, _, _ in
      if bool {
        self.refresh()
      }
    }
    shareController.popoverPresentationController?.barButtonItem = sender
    shareController.popoverPresentationController?.permittedArrowDirections = .any
    present(shareController, animated: true, completion: nil)
  }
  // MARK: - ячейки и тд

  private func setupCollectionView() {
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "FullScreenCell")
    collectionView.register(FullScreenCell.self, forCellWithReuseIdentifier: FullScreenCell.reuseId)
    collectionView.contentInsetAdjustmentBehavior = .automatic
    collectionView.allowsMultipleSelection = true
  }

  private func setupNavigationBar() { //функция создания объектов в навигейшн баре. оставляем только кнпоку поделиться
    navigationItem.rightBarButtonItems = [actionBarButtonItem] //правой кнопкой ставим кнопку "поделится"
  }
  // MARK: - вьюшки с фотографиями а так же описание работы функции выделения фотографий

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FullScreenCell.reuseId, for: indexPath) as! FullScreenCell
    let unspashPhoto = photos[indexPath.item]
    cell.unsplashPhoto = unspashPhoto

    return cell
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    undateNavButtonsState()
    let cell = collectionView.cellForItem(at: indexPath) as! FullScreenCell
    guard let image = cell.photoImageView.image else { return }
    selectedImages.append(image)

  }

  override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    undateNavButtonsState()
    let cell = collectionView.cellForItem(at: indexPath) as! FullScreenCell
    guard let image = cell.photoImageView.image else { return }
    if let index = selectedImages.firstIndex(of: image) {
      selectedImages.remove(at: index)
    }
  }
}

extension FullScreenViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return UIScreen.main.bounds.size
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .zero
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0

  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}


