import UIKit
import SDWebImage


class PhotosCell: UICollectionViewCell { //разбираемся с ячейками

  static let reuseId = "PhotosCell"

  let photoImageView: UIImageView = { //устанавливаем в ячейку фотографию
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  var unsplashPhoto: UnsplashPhoto! {
    didSet {
      let photoUrl = unsplashPhoto.urls["regular"]
      guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
      photoImageView.sd_setImage(with: url, completed: nil)
    }
  }

  override func prepareForReuse() { //переопределние метода для фотографий чтобы они не накладывались друг на друга при перелистовании
    super.prepareForReuse()
    photoImageView.image = nil
  }


  override init(frame: CGRect) { //вызов
    super.init(frame: frame)
    setupPhotoImageView()

  }

  private func setupPhotoImageView() { //устанавливаем расположение фотографии на ячейки при помощи якорей
    addSubview(photoImageView)
    photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true

  }

  required init?(coder: NSCoder) {
    fatalError("косяк с ячейками")
  }

}

