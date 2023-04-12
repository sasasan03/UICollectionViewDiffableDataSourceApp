//
//  PokemonListDetailsViewController.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/04/09.
//

import UIKit

final class PokemonDetailsViewController: UIViewController {
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // presenterにviewDidLoadを定義してここで呼びだす？
    }
}
