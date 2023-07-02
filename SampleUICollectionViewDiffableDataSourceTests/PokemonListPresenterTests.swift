//
//  PokemonListPresenterTests.swift
//  SampleUICollectionViewDiffableDataSourceTests
//
//  Created by Johnny Toda on 2023/06/25.
//

import XCTest
@testable import SampleUICollectionViewDiffableDataSource

final class PokemonListPresenterTests: XCTestCase {
    // 1体のポケモンデータが取得できているかのテスト
    func testOnePokemonList() {
        // 1体のポケモンデータが含まれたデータ配列を代入
        let mockAPI = MockAPI(mockPokemonData: PokemonListSampleData().pikachu)
        let mockPokemonListView = MockPokemonListView()
        let presenter = PokemonListPresenter(view: mockPokemonListView, model: mockAPI)

        // 仮想通信を実行
        presenter.viewDidLoad()
    }

    
    func testEmptyPokemonsList() {
        // デフォルト引数でnilが入り、二項演算子でPokemonデータがnilである場合は空の配列を返す
        // 1体のポケモンデータが含まれたデータ配列を代入
        let mockAPI = MockAPI()
        let mockPokemonListView = MockPokemonListView()
        let presenter = PokemonListPresenter(view: mockPokemonListView, model: mockAPI)

        // 仮想通信を実行
        presenter.viewDidLoad()
    }

    // 5体のポケモンデータが取得できているかテスト
    func testFivePokemonsList() {
        // 5体のポケモンデータが含まれたデータ配列を代入
        let mockAPI = MockAPI(mockPokemonData: PokemonListSampleData().favoriteFivePokemons)
    }

    // エラー発生時のテスト
    func testCheckError() {
        // パース処理失敗時のエラーを代入
        let mockAPI = MockAPI(apiError: .decodingFailed)
    }
}



