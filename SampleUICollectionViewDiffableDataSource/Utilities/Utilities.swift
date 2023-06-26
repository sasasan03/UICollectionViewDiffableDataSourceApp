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


enum APIError: Error, LocalizedError {
    case invalidURL
    case decodingFailed


    var errorDescription: String? {
        #if DEBUG
        return debugDescription
        #else
        return description
        #endif
    }

    var description: String {
        switch self {
        case .invalidURL:
             return "無効なURLです"
        case .decodingFailed:
            return "デコードに失敗しました"
        }
    }

    var debugDescription: String {
        switch self {
        case .invalidURL:
            return "無効なURLです"
        case .decodingFailed:
            return "デコードに失敗しました"
        }
    }
}
