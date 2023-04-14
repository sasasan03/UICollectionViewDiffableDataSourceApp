//
//  PokemonListViewController.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/02/01.
//

import UIKit

final class PokemonListViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!

    // PresenterはSceneDelegateにて初期化
    var presenter: PokemonListPresenterInput!
    func inject(presenter: PokemonListPresenterInput) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        presenter = PokemonListPresenter(view: self, model: API())
        self.inject(presenter: presenter)
        presenter.viewDidLoad(collectionView: collectionView)
        //        let pokemonListPresenter = PokemonListPresenter(view: pokemonListVC, model: model)
        //        pokemonListVC.inject(presenter: pokemonListPresenter)
    }

    // Cellのレイアウトを構築
    private func setUpCollectionView() {
        collectionView.delegate = self
        configureHierarchy()
    }
}

extension PokemonListViewController: PokemonListPresenterOutput {
    func showPokemonDetailsVC(pokemon: Pokemon) {
        // 遷移先のポケモンの詳細画面を生成
        let pokemonDetailsVC = UIStoryboard(name: PokemonDetailsPresenter.storyboardName, bundle: nil).instantiateViewController(withIdentifier: PokemonDetailsPresenter.idenfitifier) as! PokemonDetailsViewController
        let presenter = PokemonDetailsPresenter(view: pokemonDetailsVC)
        pokemonDetailsVC.inject(presenter: presenter)
        presenter.pokemon = pokemon
        // 🍎どのタイミングでItemのデータを遷移先のViewに渡すべきなのか。
        // 遷移先のViewControllerクラスにpokemon型のデータは設計上持たせるべきではない。
        // だからといってviewDidLoadをここで呼び出すのも間違っている。遷移後にライフサイクルで呼び出すべきものであるから。
        
        //        detailViewController.pokemon = pokemon
        // 🍎NavigationControllerがnilになってる？
        navigationController?.pushViewController(pokemonDetailsVC, animated: true)
    }

//    func updatePokemonTypeCellColor(item: Item) {
//        <#code#>
//    }

    // インジケータを起動させる
    func startIndicator() {
        view.alpha = 0.5
        indicator.isHidden = false
        indicator.startAnimating()
    }

    // Viewを更新
    func updateView() {
        indicator.stopAnimating()
        indicator.isHidden = true
        view.alpha = 1.0
        // しかしDiffableDaraSorceを使えばリロード処理は不要だった気がする
        collectionView.reloadData()
    }

    // 通信失敗時にアラートを表示する
    func showAlertMessage(errorMessage: String) {
        let alertController = UIAlertController(title: "通信エラー", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: { [weak self] _ in
            self?.presenter.didTapAlertCancelButton()
        }))
        alertController.addAction(UIAlertAction(title: "再度試す", style: .default, handler: { [weak self] _ in
            self?.presenter.didTapRestartURLSessionButton() }))

        present(alertController, animated: true)
    }
}

// Cellタップ時に実行
extension PokemonListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didTapCell(indexPath: indexPath)
    }
}


extension PokemonListViewController {
    private func configureHierarchy() {
        // CollectionViewのLayoutを実装
        collectionView.collectionViewLayout = createLayout()
        // XIBファイルCellをCollectionViewに登録
        collectionView.register(PokemonCell.nib, forCellWithReuseIdentifier: PokemonCell.identifier)
        collectionView.register(PokemonTypeCell.nib, forCellWithReuseIdentifier: PokemonTypeCell.identifier)
    }
}

// CollectionViewのLayoutを定義
extension PokemonListViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            // Sectionごとの列数を代入
            let columns = sectionKind.columnCount

            let section: NSCollectionLayoutSection

            switch sectionKind {
            case .pokemonTypeList:
                // Itemのサイズを定義
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                // Itemを生成
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                // Itemの上下左右間隔を指定
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

                // Groupのサイズを定義
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalWidth(0.2))
                // Groupを生成
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               repeatingSubitem: item,
                                                               count: columns)
                // Sectionを生成
                section = NSCollectionLayoutSection(group: group)
                // Section間のスペース
                section.interGroupSpacing = 10
                // Scroll方向を指定
                // 🍎この書き方ならswitchで書き分けると若干冗長かも？
                section.orthogonalScrollingBehavior = sectionKind.orthgonalScrollingBehavior
                // Sectionの上下左右間隔を指定
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            case .pokemonList:
                // Itemのサイズを設定
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                     heightDimension: .fractionalHeight(1.0))
                // Itemを生成
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                // Itemの上下左右間隔を指定
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

                let groupHeight = NSCollectionLayoutDimension.fractionalHeight(0.4)
                // CollectionViewのWidthの50%を指定
                let groupWidth = NSCollectionLayoutDimension.fractionalWidth(1)
                // Groupのサイズを設定
                let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth,
                                                       heightDimension: groupHeight)
                // Groupを生成
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               repeatingSubitem: item,
                                                               count: columns)
                // Sectionを生成
                section = NSCollectionLayoutSection(group: group)
                // Scroll方向を指定
                section.orthogonalScrollingBehavior = sectionKind.orthgonalScrollingBehavior
                // Sectionの上下左右間隔を指定
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            }
            return section
        }
        return layout
    }
}

extension Section {
    // SectionごとのScroll方向を返す ※これは描画処理な気もするので
    var orthgonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior {
        switch self {
        case .pokemonTypeList:
            return .continuous
        case .pokemonList:
            return .none
        }
    }
}
