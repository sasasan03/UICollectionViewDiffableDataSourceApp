//
//  MockAPI.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/05/30.
//

import Foundation

import Foundation

enum PokemonAPIError: Error, LocalizedError {
    case invalidURL
    case decodingFailed


    var errorDescription: String? {
        #if DEBUG
        return debugDescription
        #else
        return description
        #endif
    }

    var description: String {
        switch self {
        case .invalidURL:
             return "無効なURLです"
        case .decodingFailed:
            return "デコードに失敗しました"
        }
    }

    var debugDescription: String {
        switch self {
        case .invalidURL:
            return "無効なURLです"
        case .decodingFailed:
            return "デコードに失敗しました"
        }
    }
}

struct MockPokemonAPI : APIInput {
    func asyncFetchPokemonData() async -> [Pokemon] {
        <#code#>
    }
    // 通信エラー
    var returnHTTPError: HTTPError?
    // パースエラー
    var returnPokemonAPIError: PokemonAPIError?
    // mockポケモンデータ
    let returnMockPokemonList = PokemonListSampleData().pokemonList

    let returnMockPokemonDetail = PokemonDetailSampleData().pokemon

    func fetchPokemonList() async throws -> Pokemons {
        if let returnHTTPError {  throw returnHTTPError }
        if let returnPokemonAPIError { throw returnPokemonAPIError }
        return returnMockPokemonList
    }
}
