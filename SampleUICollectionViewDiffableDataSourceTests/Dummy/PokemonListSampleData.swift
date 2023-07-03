//
//  PokemonListSampleData.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/06/26.
//

import Foundation
@testable import SampleUICollectionViewDiffableDataSource

struct PokemonListSampleData {
    // ピカチューのデータ
    let pikachu = [
        Pokemon(
            name: "pikachu",
            id: 25,
            sprites: Image(frontImage: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"),
            types: [
                TypeEntry(type: Mode(name: "electric"))
            ]
        )
    ]

    // 5体のポケモンのデータ
    let favoriteFivePokemons = [
        Pokemon(
            name: "charizard",
            id: 6,
            sprites: Image(frontImage: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/6.png"),
            types: [
                TypeEntry(type: Mode(name: "fire")),
                TypeEntry(type: Mode(name: "flying"))
            ]
        ),
        Pokemon(
            name: "raichu",
            id: 26,
            sprites: Image(frontImage: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/26.png"),
            types: [
                TypeEntry(type: Mode(name: "electric"))
            ]
        ),
        Pokemon(
            name: "pikachu",
            id: 25,
            sprites: Image(frontImage: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png"),
            types: [
                TypeEntry(type: Mode(name: "electric"))
            ]
        ),
        Pokemon(
            name: "jolteon",
            id: 135,
            sprites: Image(frontImage: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/135.png"),
            types: [
                TypeEntry(type: Mode(name: "electric"))
            ]
        ),
        Pokemon(
            name: "luxray",
            id: 405,
            sprites: Image(frontImage: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/405.png"),
            types: [
                TypeEntry(type: Mode(name: "electric"))
            ]
        ),
    ]
}
