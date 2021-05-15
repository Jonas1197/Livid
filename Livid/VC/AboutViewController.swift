//
//  AboutViewController.swift
//  Livid
//
//  Created by Jonas Gamburg on 15/05/2021.
//

import UIKit

class AboutViewController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var aboutTitleLabel: UILabel!
    
    fileprivate var pinkViewOne: UIView {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    fileprivate func setUp() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .secondarySystemBackground
        configureColorBand()
    }
    
    fileprivate func configureColorBand() {
        pinkViewOne.fix(in: view, belowView: aboutTitleLabel, andHeight: 14)
        view.sendSubviewToBack(pinkViewOne)
    }
}
