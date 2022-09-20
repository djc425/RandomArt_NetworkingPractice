//
//  File.swift
//  RandomArt_APIPractice
//
//  Created by David Chester on 9/17/22.
//

import Foundation


// we use this to generate the url for a specific object, this is used once we have a department ID
struct ObjectID: Codable {
    var objectIDs: [Int]
}

struct ArtFromObject: Codable {
    var primaryImage: String
    var primaryImageSmall: String
    var objectName: String
    var title: String
    var artistDisplayName: String
    var artistRole: String
}






