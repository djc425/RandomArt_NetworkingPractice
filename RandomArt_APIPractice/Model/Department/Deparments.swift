//
//  DeparmentModel.swift
//  RandomArt_APIPractice
//
//  Created by David Chester on 9/18/22.
//

import Foundation

// we load these first to give the user the option of choosing which department they want to search
struct DepartmentIDs: Codable {
    var departments: [Departments]
}

struct Departments: Codable {
    let departmentId: Int
    let displayName: String
}
