//
//  TypeOfPokemonCell.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/02/01.
//

import UIKit

final class PokemonTypeCell: UICollectionViewCell {
    @IBOutlet private weak var typeLabel: UILabel!

    static let nib = UINib(nibName: String(describing: PokemonTypeCell.self), bundle: nil)
    static let identifier = String(describing: PokemonTypeCell.self)

    // 選択されたCellのselectedBackGroundViewのColorをblueに変更
    override var isSelected: Bool {
        didSet {
            selectedBackgroundView?.backgroundColor = .systemBlue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        createSelectedBackgroundView()
        createBackgroundView()
    }

    // BackgroundViewを生成
    private func createBackgroundView() {
        backgroundView = UIView(frame: super.frame)
        backgroundView?.backgroundColor = .systemGray5
        backgroundView?.layer.cornerRadius = 15
    }

    // SelectedBackgroundViewを生成
    private func createSelectedBackgroundView() {
        selectedBackgroundView = UIView(frame: super.frame)
        selectedBackgroundView?.layer.cornerRadius = 15
    }

    func configure(type: String?) {
        typeLabel.text = type
    }
}
