//
//  PhotoInfoController.swift
//  SpacePhoto
//
//  Created by Vladyslav Torhovenkov on 18.06.2023.
//

import Foundation

class PhotoInfoController {
    
    //2013-10-20"
    func fetchPhotoInfo() async throws -> PhotoInfo {
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
        urlComponents.queryItems = [
            "api_key" : "DEMO_KEY",
            "thumbs": "true"].map{ URLQueryItem(name: $0.key, value: $0.value) }
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw PhotoInfoError.itemNotFound
        }
        let jsonDecoder = JSONDecoder()
        let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
        return photoInfo
    }
    
    func fetchPhotoInfo(for day: Date) async throws -> PhotoInfo {
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDay = dateFormatter.string(from: day)
        
        urlComponents.queryItems = [
            "api_key" : "DEMO_KEY",
            "date" : formattedDay,
            "thumbs": "true"].map{ URLQueryItem(name: $0.key, value: $0.value) }
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw PhotoInfoError.itemNotFound
        }
        let jsonDecoder = JSONDecoder()
        let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
        return photoInfo
    }

}
