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

        // 仮想通信を実行？
        //presenter.model.decodePokemonData(completion: { [weak self] result in
        //    switch result {
        //    case .success(let pokemonsData):
        //        // 順次要素を追加
        //        pokemonsData.forEach {
        //            self?.pokemons.append(Item(pokemon: $0))
        //        }
        //
        //        // ポケモン図鑑No.の昇順になるよう並び替え
        //        self?.pokemons.sort {
        //            guard let pokedexNumber = $0.pokemon else { fatalError("unexpectedError") }
        //            guard let anotherPokedexNumber = $1.pokemon else { fatalError("unexpectedError") }
        //            return pokedexNumber.id < anotherPokedexNumber.id
        //        }
        //
        //        // Setは要素を一意にする為、一度追加されたタイプを自動で省いてくれる。(例: フシギダネが呼ばれると草タイプと毒タイプを取得するので次のフシギソウのタイプは追加されない。
        //        // 結果としてタイプリストの重複を避けることができる
        //        self?.pokemons.forEach {
        //            $0.pokemon?.types.forEach { self?.pokemonTypes.insert($0.type.name) }
        //        }
        //        DispatchQueue.main.async {
        //            self?.applyInitialSnapshots()
        //            self?.view.updateView()
        //        }
        //    case .failure(let error as URLError):
        //        DispatchQueue.main.async {
        //            self?.view.showAlertMessage(errorMessage: error.message)
        //        }
        //    case .failure:
        //        fatalError("unexpected Errorr")
        //    }
        //})
    }

    func testEmptyPokemonsList() {
        // デフォルト引数でnilが入り、二項演算子でPokemonデータがnilである場合は空の配列を返す
        let mockAPI = MockAPI()
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



