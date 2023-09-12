//
//  PokemonDTO.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/09/12.
//

import Foundation

struct PokemonDTO: Decodable {
     // ポケモンの名前
     let name: String
     // ポケモンの図鑑No.
     let id: Int
     // ポケモンの画像
     let sprites: Image
     // ポケモンのタイプ
     let types: [TypeEntry]

    ///  プロジェクトで扱うEntityを生成し、自身の値を渡す
    func convertToPokemon() -> PokemonEntity {
        // TypeEntryの要素にアクセスし、シーケンスを生成
        let types = self.types.map { $0.type.name }

        // Pokemon(Entity)インスタンスを生成
        return PokemonEntity(
            name: self.name,
            id: self.id,
            image: self.sprites.frontImage,
            types: types
        )
    }
 }
