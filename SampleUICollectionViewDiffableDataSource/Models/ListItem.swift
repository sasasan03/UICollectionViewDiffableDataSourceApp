//
//  Item.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/04/03.
//

import Foundation

// DiffableDataSourceに登録するItemはHashableプロトコルに準拠させる必要がある
//struct Item: Hashable {
//    let pokemon: Pokemon?
//    let pokemonType: String?
//
//    // デフォルト引数でnilを指定
//    init(pokemon: Pokemon? = nil, pokemonType: String? = nil) {
//        self.pokemon = pokemon
//        self.pokemonType = pokemonType
//    }
//    // インスタンスごとに一意のIDを付与
//    private let identifier = UUID()
//}

enum ListItem: Hashable {
    case pokemon(Pokemon)
    case pokemonType(String)
}
