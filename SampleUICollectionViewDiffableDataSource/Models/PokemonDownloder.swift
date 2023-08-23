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
