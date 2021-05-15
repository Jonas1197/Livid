//
//  MainCoordinator.swift
//  Livid
//
//  Created by Jonas Gamburg on 15/05/2021.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = OverviewViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func settingsVC(withCountriesArray countries: [String]) {
        let vc         = SettingsViewController.instantiate()
        vc.coordinator = self
        vc.countries   = countries
        navigationController.present(vc, animated: true, completion: nil)
    }
    
    func aboutVC() {
        let vc = AboutViewController.instantiate()
        vc.coordinator = self
        navigationController.present(vc, animated: true, completion: nil)
    }
}
