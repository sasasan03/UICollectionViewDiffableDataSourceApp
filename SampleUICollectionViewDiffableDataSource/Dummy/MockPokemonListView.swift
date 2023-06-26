//
//  MockPokemonListView.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/06/26.
//

import Foundation

class MockPokemonListView: PokemonListPresenterOutput {
    var count = 0
    var updateViewHistory: [[Pokemon]] = []


    func startIndicator() {
    }

    // 実際はpokemonsがない。故にデータが期待通り渡されているかをテストすることができない。
//    func updateView(pokemons: [Pokemon]) {
//        updateViewHistory.append(pokemons)
//        count += 1
//    }
    func updateView() {
    }

    func showAlertMessage(errorMessage: String) {
    }

    func showPokemonDetailsVC(pokemon: SampleUICollectionViewDiffableDataSource.Pokemon) {}
}
