//
//  NetworkManager.swift
//  RandomArt_APIPractice
//
//  Created by David Chester on 9/17/22.
//

import Foundation
import UIKit

// type Alias for the department Result type
typealias DepartmentResult = Result<DepartmentIDs, NetworkError>

typealias ObjectResult = Result<ObjectID, ObjectError>

typealias ArtResult = Result<ArtFromObject, ArtistError>


protocol NetworkManagerProtocol: AnyObject {
    // initial Department Method
    func retrieveDepartmentIDs(completion: @escaping (DepartmentResult) -> Void)
    func parseDepartmentIDs(from departmentData: DepartmentIDs) -> [PickerModel]

    func retrieveObjectIDs(objectID: Int, completion: @escaping (ObjectResult) -> Void)

    func retrieveArt(usingObjectID: Int, completion: @escaping (ArtResult) -> Void)
    func parseArtData(from art: ArtFromObject) -> ArtModel

}

class NetworkManager: NetworkManagerProtocol {

    //MARK: Retrieve Department IDs (first called
    func retrieveDepartmentIDs(completion: @escaping (DepartmentResult) -> Void) {
        guard let departmentIDUrl = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/departments") else {
            completion(.failure(.invalidDepartmentUrl))
            return
        }
        print(departmentIDUrl)

        let session = URLSession(configuration: .default)
        let request = URLRequest(url: departmentIDUrl)

        let task = session.dataTask(with: request) { data, _, error in

            if error != nil {
                completion(.failure(.couldNotFetchDepartments))
            }

            guard let data = data else {
                completion(.failure(.couldNotFetchDepartments))
                return
            }

            do {
                let decoder = JSONDecoder()
                let departmentData = try decoder.decode(DepartmentIDs.self, from: data)
                print(departmentData.departments.count)
                completion(.success(departmentData))
            } catch {
                completion(.failure(.couldNotGenerateDepartmentData))
            }
        }
        task.resume()
    }

    // MARK: Retrieve ObjectIDs that we will then use to call a random object
    func retrieveObjectIDs(objectID: Int, completion: @escaping (ObjectResult) -> Void) {
        guard let objectIDURL = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/search?departmentIds=\(objectID)&hasImages=true&q=cat") else {
            completion(.failure(.invalidObjectURL))
            return
        }
        print(objectIDURL)

        let session = URLSession(configuration: .default)
        let request = URLRequest(url: objectIDURL)

        let task = session.dataTask(with: request) { data, _, error in

            if error != nil {
                completion(.failure(.couldNotFetchObjectIDs))
            }

            guard let data = data else {
                completion(.failure(.couldNotGenerateObjectIDtData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let objectData = try decoder.decode(ObjectID.self, from: data)

                completion(.success(objectData))
            } catch {
                completion(.failure(.couldNotGenerateObjectIDtData))
            }
        }
        task.resume()
    }


    func retrieveArt(usingObjectID: Int, completion: @escaping (ArtResult) -> Void){
        guard let artUrl = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/objects/\(usingObjectID)") else {
            completion(.failure(.couldNotGenerateArtData))
            return
        }

        print(artUrl)

        let session = URLSession(configuration: .default)
        let request = URLRequest(url: artUrl)

        let task = session.dataTask(with: request) { data, _, error in

            if error != nil {
                completion(.failure(.couldNotFetchArt))
            }

            guard let data = data else {
                completion(.failure(.couldNotGenerateArtData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let artData = try decoder.decode(ArtFromObject.self, from: data)

                completion(.success(artData))
            } catch {
                completion(.failure(.couldNotGenerateArtData))
            }
        }
        task.resume()
    }

}

//MARK: ParseMethod for departmentIDs
extension NetworkManager {
    func parseDepartmentIDs(from departmentData: DepartmentIDs) -> [PickerModel] {
        var pickerArray = [PickerModel]()

        for department in departmentData.departments {
            let departmentName = department.displayName
            let departmentID = department.departmentId

            let pickerModel = PickerModel(departmentIDForPicker: departmentID, departmentNameForPicker: departmentName)

            pickerArray.append(pickerModel)
        }
        return pickerArray
    }

    func parseArtData(from art: ArtFromObject) -> ArtModel {

        // TODO: add in conditional to display a message if there is no artist name supplied
        let name = art.artistDisplayName
        
        //TODO: Unwrap this safely

        var imageForModel = UIImage()

        let imageString = art.primaryImage

        if imageString != "" {
             imageForModel = UIImage().load(urlString: imageString)!
        } else {
             imageForModel = UIImage(systemName: "photo.artframe")!
        }


        let title = art.title
        let artModel = ArtModel(artistName: name, heroImage: imageForModel, titleOfPiece: title)

        return artModel
        }
    }




