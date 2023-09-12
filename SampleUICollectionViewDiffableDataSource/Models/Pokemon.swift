//
//  Pokemon.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/01/31.
//

import Foundation

// ポケモンのデータ構造
// 🍎Hashableにしたらインスタンスが一意となるようにUUIDの生成が必要なんじゃなかったか？
struct Pokemon: Decodable, Hashable {
    // ポケモンの名前
    let name: String
    // ポケモンの図鑑No.
    let id: Int
    // ポケモンの画像
    let sprites: Image
    // ポケモンのタイプ
    let types: [TypeEntry]
}

// 画像のデータ構造
struct Image: Decodable, Hashable {
    // ポケモンが正面向きの画像
    let frontImage: String

    // デコードの際の代替キーをfrontImageプロパティにセット
    enum CodingKeys: String, CodingKey {
        case frontImage = "front_default"
    }
}

// ポケモンのタイプ
struct TypeEntry: Decodable, Hashable {
  let type: Mode
}

// ポケモンの説明文のリンク
struct SpeciesReference: Decodable, Hashable {
    let url: String
  }

// "Type"が命名で利用できず、他に適切な表現が思い浮かばなかった。
struct Mode: Decodable, Hashable {
    let name: String
}

//　ポケモンの説明文のリンク先で取得した値を格納するためのModel
struct Species: Decodable {
  let flavorTextEntries: [FlavorText]

  struct FlavorText: Decodable {
    let flavorText: String
    let language: Language

    struct Language: Decodable {
      let name: String
    }
  }
}
