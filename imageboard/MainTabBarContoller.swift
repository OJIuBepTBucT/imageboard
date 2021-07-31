//
//  MainTabBarContoller.swift
//  imageboard
//
//  Created by User on 20.07.2021.
//

import UIKit

class MainTabBarController: UITabBarController { //таб бар контроллер
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //контроллер содержащий фотографии и он же является рут
        let photosVC = PhotosCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()) //SceneDelegate назначаем его рут
        viewControllers = [
            generateNavigationController(rootViewController: photosVC, title: "Фотографии", image: #imageLiteral(resourceName: "photos")) //в массиве вью контроллеров вызываем универсальную функцию создания навигайшен контроллеров и наш рут контроллер оказывается еще и в навигейшн баре
            
            ]
    }
    //универсальная функция создания навигейшен контроллеров
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
