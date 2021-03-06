//
//  CharacterPreviewViewController.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 5.03.21.
//

import UIKit
import QuartzCore

class CharacterPreviewViewController: UIViewController {
    private let character: Character
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        return stackView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let imageContainerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = ColorPalette.backgroundColor
        return container
    }()
    
    private let namesShadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let namesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        return stackView
    }()
    
    let gradientLayer = CAGradientLayer()
    
    init(character: Character) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorPalette.backgroundColor
        configureSubvies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !(namesShadowView.layer.sublayers?.contains(gradientLayer) ?? false) {
            view.layoutIfNeeded()
            gradientLayer.frame = namesShadowView.bounds
            gradientLayer.colors = [UIColor.clear.cgColor, ColorPalette.backgroundColor.cgColor]
            namesShadowView.layer.insertSublayer(gradientLayer, at: 0)
        }
        
        closeButton.layer.cornerRadius = closeButton.bounds.height / 2
        closeButton.backgroundColor = ColorPalette.activeColor.withAlphaComponent(0.4)
    }
    
    private func configureSubvies() {
        view.addSubview(stackView)
        
        configureImageContainerView()
        configureStatusAndAppearancesLabels()
        
        let placeholderView = UIView()
        placeholderView.backgroundColor = ColorPalette.backgroundColor
        
        stackView.addArrangedSubview(placeholderView)
        NSLayoutConstraint.activate([
            // Stack view
            view.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            view.topAnchor.constraint(equalTo: stackView.topAnchor),
            view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),

            // Button
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -16),
            closeButton.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 16),
            
            // Image containerView
            imageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8),
            imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            
            // Names
            namesStackView.leadingAnchor.constraint(equalTo: namesShadowView.leadingAnchor),
            namesStackView.topAnchor.constraint(equalTo: namesShadowView.topAnchor, constant: 50),
            namesStackView.trailingAnchor.constraint(equalTo: namesShadowView.trailingAnchor),
            namesStackView.bottomAnchor.constraint(equalTo: namesShadowView.bottomAnchor),
            
            namesShadowView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            namesShadowView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            namesShadowView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
        ])
    }
    
    private func configureImageContainerView() {
        imageContainerView.addSubview(imageView)
        imageContainerView.addSubview(namesShadowView)
        namesShadowView.addSubview(namesStackView)
        imageContainerView.addSubview(closeButton)
        
        closeButton.addAction(UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)
        
        let nicknameLabel = UILabel()
        nicknameLabel.textColor = ColorPalette.activeColor
        nicknameLabel.text = character.nickname
        nicknameLabel.font = .systemFont(ofSize: 34, weight: .bold)
        namesStackView.addArrangedSubview(nicknameLabel)
        
        let nameLabel = UILabel()
        nameLabel.textColor = ColorPalette.activeColor
        nameLabel.text = "Actor: \(character.name ?? "")"
        namesStackView.addArrangedSubview(nameLabel)
        imageContainerView.addSubview(namesStackView)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: URL(string: character.imageUrl ?? ""),
                              placeholderImage: UIImage(systemName: "person.fill"),
                              options: .continueInBackground,
                              context: [:])
        
        stackView.addArrangedSubview(imageContainerView)
    }
    
    private func configureStatusAndAppearancesLabels() {
        let appearancesLabel = UILabel()
        appearancesLabel.textColor = ColorPalette.activeColor
        appearancesLabel.translatesAutoresizingMaskIntoConstraints = false
        appearancesLabel.setContentHuggingPriority(.required, for: .horizontal)
        let seasons: [Season]? = character.seasons?.allObjects as? [Season]
        let joinedSeasons = (seasons ?? [])
            .sorted(by: { $0.number < $1.number })
            .map({ "\($0.number)" })
            .joined(separator: ", ")
        appearancesLabel.text = "Seasons: \(joinedSeasons)"
        appearancesLabel.font = .systemFont(ofSize: 14)
        
        let statusLabel = UILabel()
        statusLabel.textColor = ColorPalette.activeColor
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.text = "Status: \(character.status ?? "")"
        statusLabel.font = .systemFont(ofSize: 14)
        
        let occupationLabel = UILabel()
        occupationLabel.textColor = ColorPalette.activeColor
        occupationLabel.translatesAutoresizingMaskIntoConstraints = false
        occupationLabel.numberOfLines = 0
        let occupation = character.occupation ?? []
        occupationLabel.text = "Occupation: \(occupation.joined(separator: ", "))"
        occupationLabel.font = .systemFont(ofSize: 14)
        
        let container = UIStackView(arrangedSubviews: [appearancesLabel, statusLabel, occupationLabel])
        container.axis = .vertical
        container.isLayoutMarginsRelativeArrangement = true
        container.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        container.spacing = 4
        stackView.addArrangedSubview(container)
    }
}
