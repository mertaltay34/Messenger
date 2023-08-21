//
//  Extension.swift
//  Messenger
//
//  Created by Mert Altay on 15.08.2023.
//

import Foundation
import UIKit

extension UIViewController{
    func configureNavigationBarApperance() {
        if let navigationController = navigationController {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            navigationController.navigationBar.compactAppearance = appearance
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
            navigationController.navigationBar.compactScrollEdgeAppearance = appearance
        }
    }
}
