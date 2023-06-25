//
//  MockAPI.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/06/25.
//

import Foundation

struct MockAPIInput: APIInput {
    func asyncFetchPokemonData() async -> [Pokemon] {
        []
    }

    func decodePokemonData(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        completion(.success([]))
    }
}
