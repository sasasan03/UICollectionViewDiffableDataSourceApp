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
struct DiffableItemData: Hashable {
    var pokemons: [Pokemon] = []
    var pokemonTypes: [PokemonType] = []
}

final class PokemonListPresenter: PokemonListPresenterInput {
    // ハードコーディング対策
    static let storyboardName = "PokemonList"
    
    // 通信で取得してパースしたデータを格納する配列
    private var pokemons: [Pokemon] = []

    // ポケモンの全て18タイプを格納した配列
    private var pokemonTypes: [PokemonType] = [
        PokemonType(name: "normal"),
        PokemonType(name: "fire"),
        PokemonType(name: "water"),
        PokemonType(name: "grass"),
        PokemonType(name: "electric"),
        PokemonType(name: "ice"),
        PokemonType(name: "fighting"),
        PokemonType(name: "poison"),
        PokemonType(name: "ground"),
        PokemonType(name: "flying"),
        PokemonType(name: "psychic"),
        PokemonType(name: "bug"),
        PokemonType(name: "rock"),
        PokemonType(name: "ghost"),
        PokemonType(name: "dragon"),
        PokemonType(name: "dark"),
        PokemonType(name: "steel"),
        PokemonType(name: "fairy")
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
                self?.pokemons = pokemons
                self?.pokemons.sort { $0.id < $1.id }

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
//    func didTapTypeOfPokemonCell() {
//        <#code#>
//    }
//
//    func didTapPokemonCell() {
//        <#code#>
//    }
}
