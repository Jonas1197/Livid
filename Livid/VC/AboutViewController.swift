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
    
    private var pinkViewOne: UIView {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .secondarySystemBackground
        configureColorBand()
    }
    
    private func configureColorBand() {
        pinkViewOne.fix(in: view, belowView: aboutTitleLabel, andHeight: 14)
        view.sendSubviewToBack(pinkViewOne)
    }
}
