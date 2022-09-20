//
//  NetworkManager.swift
//  RandomArt_APIPractice
//
//  Created by David Chester on 9/17/22.
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

protocol NetworkManagerProtocol: AnyObject {
    func retrieveDepartmentIDs(completion: @escaping (Result<DepartmentIDs, NetworkError>) -> Void)
    func parseDepartmentIDs(from departmentData: DepartmentIDs) -> [PickerModel]

    func retrieveObjectIDs(objectID: Int, completion: @escaping (Result<ObjectID, ObjectError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {

    // type Alias for the department Result type
    typealias DepartmentResult = Result<DepartmentIDs, NetworkError>

    typealias ObjectResult = Result<ObjectID, ObjectError>

   // typealias ArtResult = Result<>

    //MARK: Retrieve Department IDs (first called
    func retrieveDepartmentIDs(completion: @escaping (DepartmentResult) -> Void) {
        guard let departmentIDUrl = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/departments") else {
            completion(.failure(.invalidDepartmentUrl))
            return
        }
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
        guard let objectIDURL = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/search?departmentIds=\(objectID)&isHighlight=true&q=cat") else {
            completion(.failure(.invalidObjectURL))
            return
        }

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


   /* func retrieveArt(usingObjectID: Int, completion: ){
        guard let url = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/search?departmentId=6&hasImages=true&q=cat")
    }
        */
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
}

