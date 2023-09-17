//
//  API.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/01/31.
//

import Foundation


protocol APIInput {
    //    func asyncFetchPokemonData() async -> [Pokemon]
    func decodePokemonData(completion: @escaping (Result<[Pokemon], Error>) -> Void)
    func decodePokemonData() async throws -> [Pokemon]
}


final class API: APIInput {
    private var dataArray: [Data] = []
    private var pokemons: [Pokemon] = []

    // 通信によって取得したデータをパース
    // 取得したポケモンのデータをSwiftの型として扱う為にデコード
    func decodePokemonData(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        print(#function)
        // データの取得を実行
        fetchPokemonData(completion: { result in
            switch result {
            case .success(let dataArray):
                var pokemons: [Pokemon] = []
                dataArray.forEach {
                    do {
                        // DTOにdecode
                        let pokemonDTO = try JSONDecoder().decode(PokemonDTO.self, from: $0)
                        // DTOをEntity(Pokemon)に変換
                        let pokemon = pokemonDTO.convertToPokemon()
                        // 変換した値をpokemonsの要素として追加
                        pokemons.append(pokemon)
                        // pokemonsを呼び出し元に通知
                        completion(.success(pokemons))
                    } catch {
                        completion(.failure(error))
                    }
                }
                completion(.success(pokemons))
            case .failure(let error as URLError):
                completion(.failure(error))
            case .failure(_):
                fatalError("Unexpected Error")
            }
        })
    }

    func decodePokemonData() async throws -> [Pokemon] {
        print("🟥")
        
        do {
            let dataArray = try await fetchPokemonData()
            pokemons = try dataArray.map { data in
                let pokemonDTO = try JSONDecoder().decode(PokemonDTO.self, from: data)
                let pokemon = pokemonDTO.convertToPokemon()
                return pokemon
            }
            
            /*❌ appendする作業がなくなる
            try dataArray.map({ data in
                let pokemonDTO = try JSONDecoder().decode(PokemonDTO.self, from: data)
                let pokemon = pokemonDTO.convertToPokemon()
                pokemons.append(pokemon)
            })
             ❌*/
            
//            try dataArray.forEach {
//                // DTOにdecode
//                let pokemonDTO = try JSONDecoder().decode(PokemonDTO.self, from: $0)
//                // DTOをEntity(Pokemon)に変換
//                let pokemon = pokemonDTO.convertToPokemon()
//                // 変換した値をpokemonsの要素として追加
//                pokemons.append(pokemon)
//            }
        } catch {
            throw error
        }
        print(pokemons)
        return pokemons
    }

    // 通信を実行
    private func fetchPokemonData(completion: @escaping (Result<[Data], Error>) -> Void) {
        var dataArray: [Data] = []
        let urls = getURLs()
        urls.forEach {
            print("🟦")
            guard let url = $0 else { return }
            let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
                if let error = error {
                    completion(.failure(error))
                }
                if let data = data {
                    dataArray.append(data)
                }
                if urls.count == dataArray.count {
                    completion(.success(dataArray))
                }
            })
            task.resume()
        }
    }

    private func fetchPokemonData() async throws -> [Data] {
        let urls = getURLs()
        return try await withCheckedThrowingContinuation { continuation in
            urls.forEach {
                guard let url = $0 else { return }
                let task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, _, error in
                    guard let strongSelf = self else { return }
                    if let error = error {
                        continuation.resume(throwing: error)
                    }
                    if let data = data {
                        strongSelf.dataArray.append(data)
                    }
                    if urls.count == strongSelf.dataArray.count {
                        continuation.resume(returning: strongSelf.dataArray)
                    }
                })
                task.resume()
            }
        }
    }

    // ポケモン151匹分のリクエストURLを取得
    private func getURLs() -> [URL?] {
        let pokeDexRange = 1...151
        let urls = pokeDexRange.map { URL(string: "https://pokeapi.co/api/v2/pokemon/\($0)/") }
        return urls
    }
}
