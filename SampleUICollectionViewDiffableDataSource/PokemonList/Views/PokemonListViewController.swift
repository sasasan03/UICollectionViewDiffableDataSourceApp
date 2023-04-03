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
        presenter.viewDidLoad(collectionView: collectionView)
    }

    // Cellのレイアウトを構築
    private func setUpCollectionView() {
        configureHierarchy()
    }
}

extension PokemonListViewController: PokemonListPresenterOutput {
    func updatePokemonTypeCellColor(item: Item) {
        <#code#>
    }

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

            // Itemのサイズを設定
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalHeight(1.0))

            // Itemを生成
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            // Itemの上下左右間隔を指定
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            // 列が1だった場合、CollectionViewの幅の20％の数値を返し、それ以外はCollectionViewの高さ40%の値を返す
            let groupHeight = columns == 1 ? NSCollectionLayoutDimension.fractionalWidth(0.2) : NSCollectionLayoutDimension.fractionalHeight(0.4)
            // 列が1だった場合、CollectionViewの幅の20％の数値を返し、それ以外はCollectionViewの幅の値を返す
            let groupWidth = columns == 1 ? NSCollectionLayoutDimension.fractionalWidth(0.2) : NSCollectionLayoutDimension.fractionalWidth(1.0)
            // Groupのサイズを設定
            let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth,
                                                   heightDimension: groupHeight)
            // Groupを生成
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)

            // Sectionを生成
            let section = NSCollectionLayoutSection(group: group)

            // Sectionの上下左右間隔を指定
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            // Sectionごとにスクロール方向を設定
            section.orthogonalScrollingBehavior = sectionKind.orthgonalScrollingBehavior
            return section
        }
        return layout
    }
}

extension Section {
    // SectionごとのScroll方向を返す ※これは描画処理な気もするので
    var orthgonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior {
        switch self {
        case .typeOfPokemonList:
            return .continuous
        case .pokemonList:
            return .none
        }
    }
}
