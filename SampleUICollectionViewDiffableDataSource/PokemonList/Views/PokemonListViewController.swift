//
//  PokemonListViewController.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/02/01.
//

import UIKit

final class PokemonListViewController: UIViewController {
    /// DiffableDataSourceに渡すItemを管理
    private enum ListItem: Hashable {
        case pokemon(Pokemon)
        case pokemonType(String)
    }

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!

    // PresenterはSceneDelegateにて初期化
    var presenter: PokemonListPresenterInput!
    func inject(presenter: PokemonListPresenterInput) {
        self.presenter = presenter
    }

    // データソースを定義
    private var dataSource: UICollectionViewDiffableDataSource<Section, ListItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        presenter.viewDidLoad()
    }

    // Cellのレイアウトを構築
    private func setUpCollectionView() {
        collectionView.delegate = self
        configureHierarchy()
        configureDataSource()
    }
}

extension PokemonListViewController: PokemonListPresenterOutput {
    func showPokemonDetailsVC(pokemon: Pokemon) {
        // 遷移先のポケモンの詳細画面を生成
        let pokemonDetailsVC = UIStoryboard(name: PokemonDetailsPresenter.storyboardName, bundle: nil).instantiateViewController(withIdentifier: PokemonDetailsPresenter.idenfitifier) as! PokemonDetailsViewController

        // 🍎本来MVPアーキテクチャにおける"View"は描画処理に集中すべきなのでここに書くことが最適ではないはず、後に学習して修正
        // 遷移先の画面のPresenterのインスタンスを生成
        let pokemonDetailsPresenter = PokemonDetailsPresenter(view: pokemonDetailsVC)
        // 遷移先の画面で暗黙的アンラップで定義しているpresenterプロパティに生成したPresenterインスタンスを指定
        pokemonDetailsVC.inject(presenter: pokemonDetailsPresenter)
        // 引数の値をpresenterのインスタンスメンバーに渡す
        pokemonDetailsVC.presenter.pokemon = pokemon

        // 画面遷移
        navigationController?.pushViewController(pokemonDetailsVC, animated: true)
    }

    // インジケータを起動させる
    func startIndicator() {
        view.alpha = 0.5
        indicator.isHidden = false
        indicator.startAnimating()
    }

    // Viewを更新
    func updateView() {
        // しかしDiffableDaraSorceを使えばリロード処理は不要だった気がする
        collectionView.reloadData()
    }

    // 通信完了時に実行
    func updateView(pokemonTypeNames: [String], pokemons: [Pokemon]) {
        indicator.stopAnimating()
        indicator.isHidden = true
        view.alpha = 1.0
        // データソース登録
        applyInitialSnapshots(pokemonTypeItems: pokemonTypeItems, pokemons: pokemons)
        // collectionView更新(DiffableDataSourceは不要かも？)
        collectionView.reloadData()
    }

    // DiffableDataSource更新時に実行
    func updateDataSoure(pokemons: [Pokemon]) {
        applySnapshot(items: pokemons, section: .pokemonList)
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
        // Sectionを取得
        guard let sectionKind = Section(rawValue: indexPath.section) else { fatalError("unexpectedError") }

        switch sectionKind {
        case .pokemonTypeList:
            // タップしたポケモンのタイプを取得
            guard let pokemonTypeListItem = dataSource.itemIdentifier(for: indexPath) else { fatalError("unexpectedError") }
            guard let pokemonType = pokemonTypeListItem.pokemonType else { fatalError("unexpectedError") }
            presenter.didTapPokemonTypeCell(pokemonType: pokemonType)
        case .pokemonList:
            // タップしたポケモンを取得
            guard let listItem = dataSource.itemIdentifier(for: indexPath) else { fatalError("unexpectedError") }
            guard let pokemon = listItem.pokemon else { fatalError("unexpectedError") }
            presenter.didTapPokemonCell(pokemon: pokemon)
        }
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

    // データソースを構築
    // 直接CollectionViewを渡せる形にしてるからテストが書けない.
    private func configureDataSource() {
        // pokemonTypeCellの登録
        // 🍏UINibクラス型の引数『cellNib』にPokemonTypeCellクラスで定義したUINibクラス※1を指定
        // ※1: static let nib = UINib(nibName: String(describing: PokemonTypeCell.self), bundle: nil)
        let pokemonTypeCellRegistration = UICollectionView.CellRegistration<PokemonTypeCell, ListItem>(cellNib: PokemonTypeCell.nib) { cell, _, listItem in
            cell.layer.cornerRadius = 15
            cell.configure(type: listItem.pokemonType)
        }

        // pokemonCellの登録
        let pokemonCellRegistration = UICollectionView.CellRegistration<PokemonCell, ListItem>(cellNib: PokemonCell.nib) { cell, _, listItem in
            // Cellの構築処理
            cell.configure(imageURL: item.pokemon?.sprites.frontImage, name: item.pokemon?.name)
        }

        // data sourceの構築
        dataSource = UICollectionViewDiffableDataSource<Section, ListItem>(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .pokemonTypeList:
                return collectionView.dequeueConfiguredReusableCell(using: pokemonTypeCellRegistration,
                                                                    for: indexPath,
                                                                    item: item
                )
            case .pokemonList:
                return collectionView.dequeueConfiguredReusableCell(using: pokemonCellRegistration,
                                                                    for: indexPath,
                                                                    item: item
                )
            }
        }
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

extension PokemonListViewController {
    /// 画面起動時にDataSourceにデータを登録
    private func applyInitialSnapshots(pokemonTypeItems: [ListItem], pokemons: [ListItem] {
        print("pokemonTypeItems:", pokemonTypeItems)
        print("pokemons:", pokemons)
        // データをViewに反映させる為のDiffableDataSourceSnapshotクラスのインスタンスを生成
        var snapshot = NSDiffableDataSourceSnapshot<Section, ListItem>()
        // snapshotにSectionを追加
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot)

        // pokemonTypeListのItemをSnapshotに追加 (orthogonal scroller)
        var pokemonTypeSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
        pokemonTypeSnapshot.append(pokemonTypeItems)
        dataSource.apply(pokemonTypeSnapshot, to: .pokemonTypeList, animatingDifferences: true)

        // pokemonListのItemをSnapshotに追加
        var pokemonListSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
        pokemonListSnapshot.append(pokemons)
        dataSource.apply(pokemonListSnapshot, to: .pokemonList, animatingDifferences: true)
    }

    /// 新たなsnapshotをDataSourceにapplyしてデータ更新
    private func applySnapshot(items: [ListItem], section: Section) {
        var snapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
        snapshot.append(items)
        dataSource.apply(snapshot, to: section, animatingDifferences: true)
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
