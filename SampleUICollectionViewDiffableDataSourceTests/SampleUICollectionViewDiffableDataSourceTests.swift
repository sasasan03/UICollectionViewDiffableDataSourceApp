//
//  SampleUICollectionViewDiffableDataSourceTests.swift
//  SampleUICollectionViewDiffableDataSourceTests
//
//  Created by Johnny Toda on 2023/05/17.
//

import XCTest
@testable import SampleUICollectionViewDiffableDataSource

final class SampleUICollectionViewDiffableDataSourceTests: XCTestCase {
    // データ取得をテスト
    func testFetchPokemonsData() async {
        let api = API()
        let expectedPokemonsCount = 151
        let pokemons = await api.asyncFetchPokemonData()
        XCTAssertEqual(pokemons.count, expectedPokemonsCount)
    }
}
