//
//  SceneDelegate.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/01/31.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }

        // 起動画面のStoryboardのインスタンスを生成
        let navigationController = UIStoryboard(name: PokemonListPresenter.storyboardName, bundle: nil).instantiateInitialViewController() as! UINavigationController
        let pokemonListVC = navigationController.viewControllers[0] as! PokemonListViewController

        // 起動画面のModel,Presenterのインスタンスを生成
        let model = API()
        let pokemonDownloder = PokemonDownloder()
        let pokemonListPresenter = PokemonListPresenter(view: pokemonListVC, model: model, pokemonDownloder: pokemonDownloder)
        // 生成したPresenterを起動画面にセット
        pokemonListVC.inject(presenter: pokemonListPresenter)

        // 🍎起動画面の遷移先の画面のPresenterの初期化処理を記述する箇所の候補
        // ポケモンの詳細画面のStoryboardのインスタンスを生成
           // 🍎生成したインスタンスを起動画面にも共有する方法を考える必要がある。シングルトンパターンか？
//        let pokemonDetailsVC = UIStoryboard(name: PokemonDetailsPresenter.storyboardName, bundle: nil).instantiateViewController(withIdentifier: PokemonDetailsPresenter.idenfitifier) as! PokemonDetailsViewController
        // ポケモンの詳細画面のPresenterのインスタンスを生成
//        let pokemonDetailsPresenter = PokemonDetailsPresenter(view: pokemonDetailsVC)
        // 生成したPresenterをポケモンの詳細画面にセット
//        pokemonDetailsVC.inject(presenter: pokemonDetailsPresenter)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

