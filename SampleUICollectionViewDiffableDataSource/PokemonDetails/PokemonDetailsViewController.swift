//
//  PokemonListDetailsViewController.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/04/09.
//

import UIKit
import Kingfisher

final class PokemonDetailsViewController: UIViewController {
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    // PresenterはSceneDelegateにて初期化
    var presenter: PokemonDetailsPresenterInput!
    func inject(presenter: PokemonDetailsPresenterInput) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // presenterに処理を依頼
        presenter.viewDidLoad()
    }

    // 遷移元に戻る際、インスタンスがメモリから解放されているかをチェック
    deinit {
        print(String(describing: PokemonDetailsViewController.self) + " is deinitialized.")
    }
}

extension PokemonDetailsViewController: PokemonDetailsPresenterOutput {
    // presenterから描画指示を受けて処理を実行
    func configure(pokemon: Pokemon?) {
        // 🍎ここに関しては強制終了させずとも、エラー時の代替データを表示させる処理をthrowする方向で良いかも？
        guard let pokemon = pokemon else { fatalError("unexpected error") }
        iconView.kf.setImage(with: URL(string: pokemon.image))
        nameLabel.text = pokemon.name
    }
}
