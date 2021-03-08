//
//  CheckboxCell.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 7.03.21.
//

import UIKit

class CheckboxCell: UITableViewCell {
    private let button: UIButton
    private let label: UILabel
    
    private var resultHandler: ((Bool) -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        button = UIButton()
        label = UILabel()
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        button = UIButton()
        label = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    private func commonInit() {
        contentView.backgroundColor = ColorPalette.backgroundColor
        label.textColor = ColorPalette.activeColor
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let stackview = UIStackView(arrangedSubviews: [button, label])
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .horizontal
        stackview.isLayoutMarginsRelativeArrangement = true
        stackview.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        stackview.spacing = 8
        stackview.backgroundColor = ColorPalette.backgroundColor
        contentView.addSubview(stackview)
        
        button.setImage(UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate), for: .selected)
        button.setImage(UIImage(systemName: "circle")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = ColorPalette.activeColor
        button.addTarget(self, action: #selector(userDidTapCheckbox), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalTo: button.widthAnchor),
            stackview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            stackview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16),
            stackview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
        ])
    }
    
    func configure(with text: String, isSelected: Bool, resultHandler: @escaping ((Bool) -> Void)) {
        label.text = text
        button.isSelected = isSelected
        self.resultHandler = resultHandler
    }
    
    @objc private func userDidTapCheckbox() {
        button.isSelected.toggle()
        resultHandler?(button.isSelected)
    }
}
