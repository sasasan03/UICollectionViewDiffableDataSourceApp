//
//  Pokemon.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/01/31.
//

import Foundation

// ポケモンのデータ構造
struct Pokemon: Codable {
    // ポケモンの名前
    let name: String
    // ポケモンの図鑑No.
    let id: Int
    // ポケモンの画像
    let sprites: Image
}

// 画像のデータ構造
struct Image: Codable {
    // ポケモンが正面向きの画像
    let frontImage: String

    // デコードの際の代替キーをfrontImageプロパティにセット
    enum CodingKeys: String, CodingKey {
        case frontImage = "front_default"
    }
}
