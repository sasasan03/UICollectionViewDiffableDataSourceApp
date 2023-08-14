//
//  OldPokemonDownloder.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/08/08.
//

import Foundation

final class OldPokemonDownloder: PokemonDownloderDelegate {
    // 通信で取得してパースしたデータを格納する配列
    private var pokemons: [Pokemon] = []
    // ポケモンのタイプをまとめるSet
    private var pokemonTypes = Set<String>()
    // CellのLabel&Snapshotに渡すデータの配列
    // PokemonTypeListのSetの要素をItemインスタンスの初期値に指定し、mapで配列にして返す
    private var pokemonTypeNames: [String] { ["all"] + pokemonTypes }

    func fetchPokemons(model: APIInput, view: PokemonListPresenterOutput) {
        view.startIndicator()
        // selfを追加
        model.decodePokemonData(completion: { [self] result in
            switch result {
            case .success(let pokemonsData):
                DispatchQueue.main.async {
                    // 非同期処理で受け取ったpokeomの配列データをポケモン図鑑No.の昇順になるよう並び替え、pokemons配列に渡す
                    self.pokemons.append(contentsOf: pokemonsData)
                    // Setは要素を一意にする為、一度追加されたタイプを自動で省いてくれる。(例: フシギダネが呼ばれると草タイプと毒タイプを取得するので次のフシギソウのタイプは追加されない。
                    // 結果としてタイプリストの重複を避けることができる
                    self.pokemons.forEach {
                        $0.types.forEach { self.pokemonTypes.insert($0.type.name) }
                    }
                    view.updateView(pokemonTypeNames: self.pokemonTypeNames, pokemons: self.pokemons)
                }
                // URLErrorにキャストすべきではない。HTTPErrorが来る場合もあればAPIErrorが来る可能性もある。つまり、PokemonListPresenterOutputのデリゲートメソッドから作り直す必要がある？
            case .failure(let error as URLError):
                DispatchQueue.main.async {
                    view.showAlertMessage(errorMessage: error.message)
                }
            case .failure(let error as HTTPError):
                DispatchQueue.main.async {
                    view.showAlertMessage(errorMessage: error.description)
                }
            case .failure(let error as APIError):
                DispatchQueue.main.async {
                    view.showAlertMessage(errorMessage: error.description)
                }
            case .failure:
                fatalError("unexpectedError")
            }
        })
    }
}
