import Foundation
import UIKit
import SDWebImage


class FullScreenCell: UICollectionViewCell { //разбираемся с ячейками
  static let reuseId = "FullScreenCell"
  private let checkmark: UIImageView = { //устанавливаем галочку в случае выбора фотографии и ячейки
    let image = UIImage(named: "bird")
    let imageView = UIImageView(image: image)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.alpha = 0
    return imageView
  }()

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
      setupPhotoImageView()
      setupCheckmarkView()
      photoImageView.sd_setImage(with: url, completed: nil)
    }
  }

  override var isSelected: Bool { //ячейка или нажата или нет
    didSet {
      updateSelectedState()
    }
  }

  override func prepareForReuse() { //переопределние метода для фотографий чтобы они не накладывались друг на друга при перелистовании
    super.prepareForReuse()
    photoImageView.image = nil
  }

  private func updateSelectedState() {
    photoImageView.alpha = isSelected ? 0.7 : 1
    checkmark.alpha = isSelected ? 1 : 0
  }

  override init(frame: CGRect) { //вызов
    super.init(frame: frame)
    updateSelectedState()
  }

  private func setupPhotoImageView() { //устанавливаем расположение фотографии на ячейки при помощи якорей
    addSubview(photoImageView)

    let availableWidth = frame.width
    let widthPerItem = availableWidth
    let height = CGFloat(unsplashPhoto.height) * widthPerItem / CGFloat(unsplashPhoto.width)

    photoImageView.translatesAutoresizingMaskIntoConstraints = false
    photoImageView.widthAnchor.constraint(equalToConstant: widthPerItem).isActive = true
    photoImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
    photoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    photoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

  }

  private func setupCheckmarkView() { //устанавливаем расположение галочки
    addSubview(checkmark)
    checkmark.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -8).isActive = true
    checkmark.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -8).isActive = true
  }
  required init?(coder: NSCoder) {
    fatalError("косяк с ячейками")
  }

}

