//
//  Coordinator.swift
//  Livid
//
//  Created by Jonas Gamburg on 15/05/2021.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinator: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
