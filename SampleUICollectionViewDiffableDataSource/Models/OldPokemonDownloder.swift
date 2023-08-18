//
//  OldPokemonDownloder.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/08/08.
//

import Foundation

struct OldPokemonDownloder: PokemonDownloderDelegate {
    func fetchPokemons(model: APIInput, view: PokemonListPresenterOutput) async throws -> [Pokemon] {
        try await withCheckedThrowingContinuation { continuation in
            fetchPokemons(model: model, view: view) { result in
                switch result {
                case .success(let pokemonsData):
                    DispatchQueue.main.async {
                        continuation.resume(returning: pokemonsData)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    private func fetchPokemons(model: APIInput, view: PokemonListPresenterOutput, completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        view.startIndicator()
        // selfを追加
        model.decodePokemonData(completion: { result in
            switch result {
            case .success(let pokemonsData):
                DispatchQueue.main.async {
                    completion(.success(pokemonsData))
                }
                // URLErrorにキャストすべきではない。HTTPErrorが来る場合もあればAPIErrorが来る可能性もある。つまり、PokemonListPresenterOutputのデリゲートメソッドから作り直す必要がある？
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        })
    }

    // 通信で取得してパースしたデータを格納する配列
    private var pokemons: [Pokemon] = []
    // ポケモンのタイプをまとめるSet
    private var pokemonTypes = Set<String>()
    // CellのLabel&Snapshotに渡すデータの配列
    // PokemonTypeListのSetの要素をItemインスタンスの初期値に指定し、mapで配列にして返す
    private var pokemonTypeNames: [String] { ["all"] + pokemonTypes }
}
