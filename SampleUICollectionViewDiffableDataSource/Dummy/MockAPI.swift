//
//  MockAPI.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/06/25.
//

import Foundation

struct MockAPI: APIInput {
    var urlError: URLError?
    var apiError: APIError?

    // ダミーデータを定義
    var mockPokemonData: [Pokemon]?

    // TODO: (前に調べた気はしつつも)なぜ以下の場合はコンパイルエラーになるのか調査
//    let sampleData = PokemonListSampleData()
//    let pikachu = sampleData.pikachu

    func decodePokemonData(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        if let urlError { completion(.failure(urlError)) }
        if let apiError { completion(.failure(apiError)) }
        // ここに渡すデータが固定ではなく、変動して欲しい
        completion(.success(mockPokemonData ?? []))
    }
}
