//
//  PokemonListPresenter.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/01/31.
//

import Foundation

// ViewからPresenterに処理を依頼する際の処理
protocol PokemonListPresenterInput {
    var numberOfPokemons: Int { get }
    func fetchPokemonData()
//    func didTapTypeOfPokemonCell()
//    func didTapPokemonCell()
}

// ViewからPresenterに処理を依頼する際の処理
protocol PokemonListPresenterOutput: AnyObject {
    func startIndicator()
    func updateView()
    func showAlertMessage(errorMessage: String)
}


final class SearchPokemonPresenter: PokemonListPresenterInput {
    var pokemons: [Pokemon] = []

    private var api: APIInput!
    private weak var pokemonListVC: PokemonListPresenterOutput!

    init(pokemonListVC: PokemonListPresenterOutput!, api: APIInput) {
        self.pokemonListVC = pokemonListVC
        self.api = api
    }

    var numberOfPokemons: Int { pokemons.count }

    func fetchPokemonData() {
        pokemonListVC.startIndicator()
        api.decodePokemonData(completion: { [weak self] result in
            switch result {
            case .success(let pokemons):
                self?.pokemons = pokemons
                self?.pokemons.sort { $0.id < $1.id }

                DispatchQueue.main.async {
                    self?.pokemonListVC.updateView()
                }
            case .failure(let error as URLError):
                DispatchQueue.main.async {
                    self?.pokemonListVC.showAlertMessage(errorMessage: error.message)
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
