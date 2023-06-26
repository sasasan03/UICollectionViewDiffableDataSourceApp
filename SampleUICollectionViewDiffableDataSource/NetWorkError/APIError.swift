//
//  APIError.swift
//  SampleUICollectionViewDiffableDataSource
//
//  Created by Johnny Toda on 2023/06/27.
//

import Foundation

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
