//
//  Directions.swift
//  restaurants-project
//
//  Created by Ayris Gürbulak on 11.12.2021.
//

import Foundation

struct Directions: Decodable {
    let routes: [Routes]
}

struct Routes: Decodable {
    let overview_polyline: Polyline
}

struct Polyline: Decodable {
    let points: String
}
