//
//  Pokemon.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/01/31.
//

import Foundation

protocol DTODecodable: Decodable {
    associatedtype DTO: Decodable
    init(dto: DTO) throws
}

extension DTODecodable {
    init(from decoder: Decoder) throws {
        let dto = try DTO(from: decoder)
        self = try Self.init(dto: dto)
    }
}


// ポケモンのデータ構造
// 🍎Hashableにしたらインスタンスが一意となるようにUUIDの生成が必要なんじゃなかったか？
struct Pokemon: Decodable, Hashable {
    let name: String
    let id: Int
    let image: String
    let type: [String]
}

extension Pokemon: DTODecodable {
    struct DTO: Decodable {
        // ポケモンの名前
        let name: String
        // ポケモンの図鑑No.
        let id: Int
        // ポケモンの画像
        let sprites: Image
        // ポケモンのタイプ
        let types: [TypeEntry]
    }

    // DTOからプロジェクトで使用するModel(これがEntity?)に値を渡す
    // 型変換をして渡す値が存在し、変換失敗の可能性を考慮してthrowsキーワードを付与
    init(dto: DTO) throws {
        self.name = dto.name
        self.id = dto.id
        self.image = dto.sprites.frontImage
//        ...
    }
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
