//
//  Cat.swift
//  Networking
//
//  Created by alina on 15.05.2026.
//

import Foundation

public struct Cat: Identifiable, Codable {
    public let id: String
    public let url: String
    public let width: Int?
    public let height: Int?
    public let breeds: [Breed]?

    public init(
        id: String,
        url: String,
        width: Int?,
        height: Int?,
        breeds: [Breed]?
    ) {
        self.id = id
        self.url = url
        self.width = width
        self.height = height
        self.breeds = breeds
    }
}

public struct Breed: Codable {
    public let name: String?
    public let life_span: String?
    public let temperament: String?
    public let origin: String?

    public init(
        name: String?,
        life_span: String?,
        temperament: String?,
        origin: String?
    ) {
        self.name = name
        self.life_span = life_span
        self.temperament = temperament
        self.origin = origin
    }
}
