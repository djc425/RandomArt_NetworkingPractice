//
//  Errors.swift
//  RandomArt_APIPractice
//
//  Created by David Chester on 9/20/22.
//

import Foundation

enum NetworkError: String, Error {
    case invalidDepartmentUrl = "Invalid URL for department look up"
    case couldNotFetchDepartments = "unable to load departments"
    case couldNotGenerateDepartmentData = "unable to get departments"
}

enum ObjectError: String, Error {
    case invalidObjectURL = "Invalid URL for object look up"
    case couldNotFetchObjectIDs = "unable to load objects"
    case couldNotGenerateObjectIDtData = "unable to get object ID"

}

enum ArtistError: String, Error {
    case invalidArtURL = "Error with URL, please try again"
    case couldNotFetchArt = "Error with Art data, please try again"
    case couldNotGenerateArtData = "Error with generating art info, please try again"
}
