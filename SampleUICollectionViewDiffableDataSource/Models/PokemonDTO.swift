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
 }
