//
//  DataBubble.swift
//  Livid
//
//  Created by Jonas Gamburg on 15/05/2021.
//

import UIKit

class DataBubble: UIView {
    
    var color: UIColor? {
        didSet {
            backgroundView.backgroundColor = color
            reloadInputViews()
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
            reloadInputViews()
        }
    }
    
    var value: String? {
        didSet {
            valueLabel.text = value
            reloadInputViews()
        }
    }
    
    var titleLabel: UILabel = {
        let label           = UILabel()
        label.text          = "Title"
        label.textAlignment = .center
        label.font          = UIFont(name: Font.bold, size: 14)
        label.textColor     = .label
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var valueLabel: UILabel = {
        let label           = UILabel()
        label.text          = "-"
        label.textAlignment = .center
        label.font          = UIFont(name: Font.regular, size: 24)
        label.textColor     = .white
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor     = .systemPink
        view.clipsToBounds       = true
        view.layer.masksToBounds = false
        view.layer.cornerRadius  = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    override func didAddSubview(_ subview: UIView) {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 70),
            widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    fileprivate func setUp() {
        translatesAutoresizingMaskIntoConstraints = false
        configureVisualElements()
    }
    
    fileprivate func configureVisualElements() {
        backgroundColor = .clear
        backgroundView.fix(in: self, toBottomWithHeight: 45)
        valueLabel.fix(in: backgroundView, withPadding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        titleLabel.fix(in: self, toTopWithPadding: 3)
    }
}
