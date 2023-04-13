//
//  PokemonDetailsPresenter.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/04/12.
//

import Foundation

// ViewからPresenterに処理を依頼する際の処理
protocol PokemonDetailsPresenterInput {
    func viewDidLoad()
}

// PresenterからViewに処理を依頼する際の処理
protocol PokemonDetailsPresenterOutput: AnyObject {
    // updateViewとかの方が適切？Presenterは指示を出すだけでViewの具体的な処理内容については知っているべきではない？
    func configure(pokemon: Pokemon?)
}

final class PokemonDetailsPresenter: PokemonDetailsPresenterInput {
    // PokemonListからの値を受け取って保持するためのプロパティ
    var pokemon: Pokemon?
    // Viewへ描画指示を出すためのデリゲート
    private weak var view: PokemonDetailsPresenterOutput!
    // 🍎イニシャライザを書かなくてもコンパイラがエラー吐かないのって保守的観点で微妙かも？
    init(view: PokemonDetailsPresenterOutput) {
        self.view = view
    }
    // インスタンス生成時のハードコーディング対策
    static let storyboardName = "PokemonDetails"
    static let idenfitifier = "PokemonDetails"

    func viewDidLoad() {
        // Viewに描画指示
        view.configure(pokemon: pokemon)
    }
}
