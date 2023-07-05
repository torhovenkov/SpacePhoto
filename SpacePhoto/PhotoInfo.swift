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
    var mediaType: String
    var thumbsUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
        case mediaType = "media_type"
        case thumbsUrl = "thumbnail_url"
    }
    
    enum UrlError: Error, LocalizedError {
        case cannotChangeUrlScheme
    }
    
    static func fetchPhoto(from url: URL) async throws -> UIImage {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.scheme = "https"
        guard let url = urlComponents?.url else { throw UrlError.cannotChangeUrlScheme }
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
