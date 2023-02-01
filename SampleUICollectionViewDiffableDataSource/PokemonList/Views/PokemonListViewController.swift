//
//  PokemonListViewController.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/02/01.
//

import UIKit

final class PokemonListViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!

    static let storyboardName = "PokemonList"
    
    // PresenterはSceneDelegateにて初期化
    var presenter: PokemonListPresenterInput!
    func inject(presenter: PokemonListPresenterInput) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PokemonListViewController: PokemonListPresenterOutput {
    func startIndicator() {
        <#code#>
    }

    func updateView() {
        <#code#>
    }

    func showAlertMessage(errorMessage: String) {
        <#code#>
    }
}
