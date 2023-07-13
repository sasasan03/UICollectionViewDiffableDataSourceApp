//
//  MockPokemonListView.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/06/26.
//

import Foundation
import XCTest
@testable import SampleUICollectionViewDiffableDataSource

class MockPokemonListView {
    var count = 0
    var updateViewHistory: [[Pokemon]] = []

    private var expectation: XCTestExpectation

    init(expectationForUpdateView: XCTestExpectation) {
        self.expectation = expectationForUpdateView
    }
}

extension MockPokemonListView: PokemonListPresenterOutput {
    func updateDataSoure(pokemons: [SampleUICollectionViewDiffableDataSource.Pokemon]) {}

    func startIndicator() {
        print("Indicatorをスタート")
    }

    func updateView(pokemonTypeNames: [String], pokemons: [SampleUICollectionViewDiffableDataSource.Pokemon]) {
        updateViewHistory.append(pokemons)
        print("updateViewHistoryの中身：", updateViewHistory)
    }
    
    func showAlertMessage(errorMessage: String) {
        print("取得したエラー:", errorMessage)
    }

    func showPokemonDetailsVC(pokemon: SampleUICollectionViewDiffableDataSource.Pokemon) {}
}
