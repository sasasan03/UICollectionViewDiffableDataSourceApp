//
//  PokemonDownloder.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/08/15.
//

import Foundation

protocol PokemonDownloderDelegate {
    func fetchPokemons(model: APIInput, view: PokemonListPresenterOutput) async throws -> [Pokemon]
}

struct PokemonDownloder: PokemonDownloderDelegate {
    // TODO: Modelがドメインデータを持ってるのは違和感
    // 通信で取得してパースしたデータを格納する配列
    private var pokemons: [Pokemon] = []
    // ポケモンのタイプをまとめるSet
    private var pokemonTypes = Set<String>()
    // CellのLabel&Snapshotに渡すデータの配列
    // PokemonTypeListのSetの要素をItemインスタンスの初期値に指定し、mapで配列にして返す
    private var pokemonTypeNames: [String] { ["all"] + pokemonTypes }

    func fetchPokemons(model: APIInput, view: PokemonListPresenterOutput) async throws -> [Pokemon] {
        view.startIndicator()
        do {
            let pokemonsData = try await model.decodePokemonData()
            return pokemonsData
        } catch {
            throw error
        }
    }
}
