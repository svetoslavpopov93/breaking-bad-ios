//
//  SegmentedControlCell.swift
//  BreakingBad
//
//  Created by Svetoslav Popov on 7.03.21.
//

import UIKit

class SegmentedControlCell: UITableViewCell {
    let segmentedControl: UISegmentedControl
    var resultsHandler: ((Int) -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        segmentedControl = UISegmentedControl()
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        segmentedControl = UISegmentedControl()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    override func prepareForReuse() {
        segmentedControl.removeAllSegments()
    }
    
    private func commonInit() {
        contentView.backgroundColor = ColorPalette.backgroundColor
        
        segmentedControl.backgroundColor = ColorPalette.backgroundColor
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = .red
        segmentedControl.selectedSegmentTintColor = ColorPalette.activeColor
        segmentedControl.layer.borderColor = ColorPalette.activeColor.cgColor
        segmentedControl.selectedSegmentTintColor = ColorPalette.activeColor
        segmentedControl.layer.borderWidth = 1
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ColorPalette.activeColor], for:.normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ColorPalette.backgroundColor], for:.selected)
        
        contentView.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(SegmentedControlCell.valueChanged), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            segmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
        ])
    }
    
    func configure(with options: [String], selectedSegment: Int, resultsHandler: @escaping ((Int) -> Void)) {
        self.resultsHandler = resultsHandler
        
        for (index, option) in options.enumerated() {
            segmentedControl.insertSegment(withTitle: option, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = selectedSegment
    }
    
    @objc private func valueChanged(_ sender: UISegmentedControl) {
        resultsHandler?(sender.selectedSegmentIndex)
    }
}
