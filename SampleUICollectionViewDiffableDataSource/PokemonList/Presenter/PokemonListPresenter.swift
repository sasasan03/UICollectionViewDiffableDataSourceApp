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

// データソースに追加するItem
enum Item: Hashable {
    case pokemon(Pokemon)
    case type(PokemonType)
}

final class PokemonListPresenter: PokemonListPresenterInput {
    // ハードコーディング対策
    static let storyboardName = "PokemonList"
    
    // 通信で取得してパースしたデータを格納する配列
    private var pokemons: [Item] = []

    // ポケモンの全18タイプを格納した配列
    private var pokemonTypes: [Item] = [
        .type(PokemonType(name: "normal")),
        .type(PokemonType(name: "fire")),
        .type(PokemonType(name: "water")),
        .type(PokemonType(name: "grass")),
        .type(PokemonType(name: "electric")),
        .type(PokemonType(name: "ice")),
        .type(PokemonType(name: "fighting")),
        .type(PokemonType(name: "poison")),
        .type(PokemonType(name: "ground")),
        .type(PokemonType(name: "flying")),
        .type(PokemonType(name: "psychic")),
        .type(PokemonType(name: "bug")),
        .type(PokemonType(name: "rock")),
        .type(PokemonType(name: "ghost")),
        .type(PokemonType(name: "dragon")),
        .type(PokemonType(name: "dark")),
        .type(PokemonType(name: "steel")),
        .type(PokemonType(name: "fairy"))
    ]

    private weak var view: PokemonListPresenterOutput!
    private var model: APIInput

    init(view: PokemonListPresenterOutput, model: APIInput) {
        self.view = view
        self.model = model
    }

    // データソースを定義
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!

    // データソースを構築
    private func configureDataSource(collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView, cellProvider: { (collectionView: UICollectionView, indexpath: IndexPath, item: AnyHashable) -> UICollectionViewCell? in
            guard let self = self else { return }
            switch indexpath.section {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonTypeCell.identifier, for: indexpath) as! PokemonTypeCell
                cell.configure(type: self.pokemonTypes[indexpath.row].name)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.identifier, for: indexpath) as! PokemonCell
                cell.configure(imageURL: self.pokemons[indexpath.row].sprites.frontImage, name: self.pokemons[indexpath.row].name)
                return cell
            }
        })
        applySnapshot()
    }

    // データソースにデータを登録
    private func applySnapshot() {
        // データをViewに反映させる為のDiffableDataSourceSnapshotクラスのインスタンスを生成
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()

        // snapshotにSecrtionを追加
        snapshot.appendSections(Section.allCases)

        // snapshotにItemを追加
        snapshot.appendItems(pokemonTypes.map { $0 as AnyHashable }, toSection: .typeOfPokemonList)
        snapshot.appendItems(pokemons.map { $0 as AnyHashable }, toSection: .pokemonList)

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
