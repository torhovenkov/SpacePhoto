//
//  PhotoInfo.swift
//  SpacePhoto
//
//  Created by Vladyslav Torhovenkov on 18.06.2023.
//
import UIKit
import Foundation

enum PhotoInfoError: Error, LocalizedError {
    case itemNotFound
    case photoNotFound
}

struct PhotoInfo: Codable {
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
    }
    
    static func fetchPhoto(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw PhotoInfoError.itemNotFound
        }
        guard let image = UIImage(data: data) else {
            throw PhotoInfoError.photoNotFound
        }
        return image
    }
}
