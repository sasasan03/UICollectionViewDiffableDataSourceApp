//
//  PokemonListPresenter.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/01/31.
//

import Foundation
import UIKit

// ViewからPresenterに処理を依頼する際の処理
protocol PokemonListPresenterInput {
    var numberOfPokemons: Int { get }
    func viewDidLoad(collectionView: UICollectionView)
    func didTapRestartURLSessionButton()
    func didTapAlertCancelButton()
//    func didTapTypeOfPokemonCell()
//    func didTapPokemonCell()
}

// ViewからPresenterに処理を依頼する際の処理
protocol PokemonListPresenterOutput: AnyObject {
    func startIndicator()
    func updateView()
    func showAlertMessage(errorMessage: String)
}

// データソースに追加するSection
enum Section: Int, CaseIterable {
    case typeOfPokemonList, pokemonList

    // Sectionごとの列数を返す
    var columnCount: Int {
        switch self {
        case .typeOfPokemonList:
            return 1
        case .pokemonList:
            return 2
        }
    }
}

final class PokemonListPresenter: PokemonListPresenterInput {
    // ハードコーディング対策
    static let storyboardName = "PokemonList"
    
    // 通信で取得してパースしたデータを格納する配列
    private var pokemons: [Item] = []
    // ポケモンのタイプをまとめるSet
    private var pokemonTypes = Set<String>()
    // CellのLabel&Snapshotに渡すデータの配列
    // タイプ一覧のSetの要素をItemインスタンスの初期値に指定し、mapで配列にして返す
    private lazy var pokemomnTypeItems = pokemonTypes.map { Item(pokemonType: $0) }

    private weak var view: PokemonListPresenterOutput!
    private var model: APIInput

    init(view: PokemonListPresenterOutput, model: APIInput) {
        self.view = view
        self.model = model
    }

    // データソースを定義
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    // データソースを構築
    private func configureDataSource(collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { (collectionView: UICollectionView, indexpath: IndexPath, item: Item) -> UICollectionViewCell? in
            switch item {
            case .pokemon(let pokemon):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.identifier, for: indexpath) as! PokemonCell
                cell.configure(imageURL: pokemon.sprites.frontImage, name: pokemon.name)
                return cell
            case .type(let pokemonType):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonTypeCell.identifier, for: indexpath) as! PokemonTypeCell
                cell.configure(type: pokemonType.name)
                return cell
            }
        })
        applySnapshot()
    }

    // データソースにデータを登録
    private func applySnapshot() {
        // データをViewに反映させる為のDiffableDataSourceSnapshotクラスのインスタンスを生成
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

        // snapshotにSecrtionを追加
        snapshot.appendSections(Section.allCases)

        // snapshotにItemを追加
        snapshot.appendItems(pokemons, toSection: .pokemonList)
        snapshot.appendItems(pokemonTypes, toSection: .typeOfPokemonList)

        // データをViewに表示する処理を実行
        dataSource.apply(snapshot)
    }

    var numberOfPokemons: Int { pokemons.count }

    // アプリ起動時にviewから通知
    func viewDidLoad(collectionView: UICollectionView) {
        view.startIndicator()
        model.decodePokemonData(completion: { [weak self] result in
            switch result {
            case .success(let pokemons):
                // 順次要素を追加
                pokemons.forEach {
                    self?.pokemons.append(.pokemon($0))
                }

                // ポケモン図鑑No.通り昇順になるよう並び替え
                self?.pokemons.sort { a, b -> Bool in
                    switch (a, b) {
                    case let (.pokemon(pokemonA), .pokemon(pokemonB)):
                        return pokemonA.id < pokemonB.id
                    // 🍎本来ここは書きたくない。この実装はあくまでPokemonの配列に関する処理なので。これがenumで書くデメリットの一つ
                    default:
                        return true
                    }
                }

                DispatchQueue.main.async {
                    self?.configureDataSource(collectionView: collectionView)
                    self?.view.updateView()
                }
            case .failure(let error as URLError):
                DispatchQueue.main.async {
                    self?.view.showAlertMessage(errorMessage: error.message)
                }
            case .failure:
                fatalError("unexpected Errorr")
            }
        })
    }

    // 再度通信処理を実行
    func didTapRestartURLSessionButton() {
        view.startIndicator()
        model.decodePokemonData(completion: { [weak self] result in
            switch result {
            case .success(let pokemons):
                // 順次要素を追加
                pokemons.forEach {
                    self?.pokemons.append(.pokemon($0))
                }

                // ポケモン図鑑No.通り昇順になるよう並び替え
                self?.pokemons.sort { a, b -> Bool in
                    switch (a, b) {
                    case let (.pokemon(pokemonA), .pokemon(pokemonB)):
                        return pokemonA.id < pokemonB.id
                    // 🍎本来ここは書きたくない。この実装はあくまでPokemonの配列に関する処理なので。これがenumで書くデメリットの一つ
                    default:
                        return true
                    }
                }

                DispatchQueue.main.async {
                    self?.view.updateView()
                }
            case .failure(let error as URLError):
                DispatchQueue.main.async {
                    self?.view.showAlertMessage(errorMessage: error.message)
                }
            case .failure:
                fatalError("unexpected Errorr")
            }
        })
    }

    func didTapAlertCancelButton() {
        view.updateView()
    }

    //    func didTapTypeOfPokemonCell() {
//        <#code#>
//    }
//
//    func didTapPokemonCell() {
//        <#code#>
//    }
}
