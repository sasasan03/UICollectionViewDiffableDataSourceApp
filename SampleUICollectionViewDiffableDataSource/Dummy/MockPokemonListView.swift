//
//  MockPokemonListView.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/06/26.
//

import Foundation

class MockPokemonListView: PokemonListPresenterOutput {
    func updateDataSoure(pokemons: [Item]) {
    }

    var count = 0
    var updateViewHistory: [[Pokemon]] = []


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
