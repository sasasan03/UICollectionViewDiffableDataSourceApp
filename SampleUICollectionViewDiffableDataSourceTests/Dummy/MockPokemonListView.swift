//
//  MockPokemonListView.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/06/26.
//

import Foundation
@testable import SampleUICollectionViewDiffableDataSource

class MockPokemonListView {
    func updateDataSoure(pokemons: [Item]) {
    }

    var count = 0
    var updateViewHistory: [[Pokemon]] = []
}

extension MockPokemonListView: PokemonListPresenterOutput {
    func startIndicator() {
        print("Indicatorをスタート")
    }

    func updateView(pokemonTypeItems: [Item], pokemons: [Item]) {
        print("pokemonTypeItems", pokemonTypeItems)
        print("pokemons", pokemons)
    }

    // 実際はpokemonsがない。故にデータが期待通り渡されているかをテストすることができない。
//    func updateView(pokemons: [Pokemon]) {
//        updateViewHistory.append(pokemons)
//        count += 1
//    }
    func showAlertMessage(errorMessage: String) {
        print("取得したエラー:", errorMessage)
    }

    func showPokemonDetailsVC(pokemon: SampleUICollectionViewDiffableDataSource.Pokemon) {}
}
