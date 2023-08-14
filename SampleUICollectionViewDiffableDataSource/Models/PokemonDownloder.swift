//
//  PokemonDownloder.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/08/15.
//

import Foundation


final class PokemonDownloder {
    // 通信で取得してパースしたデータを格納する配列
    private var pokemons: [Pokemon] = []
    // ポケモンのタイプをまとめるSet
    private var pokemonTypes = Set<String>()
    // CellのLabel&Snapshotに渡すデータの配列
    // PokemonTypeListのSetの要素をItemインスタンスの初期値に指定し、mapで配列にして返す
    private var pokemonTypeNames: [String] { ["all"] + pokemonTypes }

    func fetchPokemons(model: APIInput, view: PokemonListPresenterOutput) {
        view.startIndicator()
        Task {
            do {
                let pokemonsData = try await model.decodePokemonData()
                pokemons.append(contentsOf: pokemonsData)
                pokemons.forEach {
                    $0.types.forEach { pokemonTypes.insert($0.type.name) }
                }
                view.updateView(pokemonTypeNames: pokemonTypeNames, pokemons: pokemons)
            } catch let error as URLError {
                view.showAlertMessage(errorMessage: error.message)
            } catch let error as HTTPError {
                view.showAlertMessage(errorMessage: error.description)
            } catch let error as APIError {
                view.showAlertMessage(errorMessage: error.description)
            }
        }
    }
}
