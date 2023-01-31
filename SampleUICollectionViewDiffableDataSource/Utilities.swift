//
//  Utilities.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/01/31.
//

import Foundation

extension URLError {
    var message: String {
        switch self.code {
        case .timedOut:
            return "タイムアウトしました。通信環境を確認し、再度お試しください。"
        default:
            return "何らかのエラーが発生しました。通信環境を確認し、再度お試しください。"
        }
    }
}
