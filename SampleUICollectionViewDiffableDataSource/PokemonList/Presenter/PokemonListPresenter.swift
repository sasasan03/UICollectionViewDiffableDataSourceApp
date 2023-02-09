//
//  PokemonListPresenter.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/01/31.
//

import Foundation
import UIKit

// ViewからPresenterに処理を依頼する際の処理
protocol PokemonListPresenterInput {
    var numberOfPokemons: Int { get }
    func viewDidLoad(collectionView: UICollectionView)
//    func didTapTypeOfPokemonCell()
//    func didTapPokemonCell()
}

// ViewからPresenterに処理を依頼する際の処理
protocol PokemonListPresenterOutput: AnyObject {
    func startIndicator()
    func updateView()
    func showAlertMessage(errorMessage: String)
}


final class PokemonListPresenter: PokemonListPresenterInput {
    var pokemons: [Pokemon] = []

    private weak var view: PokemonListPresenterOutput!
    private var model: APIInput

    init(view: PokemonListPresenterOutput, model: APIInput) {
        self.view = view
        self.model = model
    }

    var numberOfPokemons: Int { pokemons.count }

    // アプリ起動時にviewから通知
    func viewDidLoad(collectionView: UICollectionView) {
        view.startIndicator()
        model.decodePokemonData(completion: { [weak self] result in
            switch result {
            case .success(let pokemons):
                self?.pokemons = pokemons
                self?.pokemons.sort { $0.id < $1.id }

                DispatchQueue.main.async {
                    self?.view.updateView()
                }
            case .failure(let error as URLError):
                DispatchQueue.main.async {
                    self?.view.showAlertMessage(errorMessage: error.message)
                }
            case .failure:
                fatalError("unexpected Errorr")
            }
        })
    }
//    func didTapTypeOfPokemonCell() {
//        <#code#>
//    }
//
//    func didTapPokemonCell() {
//        <#code#>
//    }
}
