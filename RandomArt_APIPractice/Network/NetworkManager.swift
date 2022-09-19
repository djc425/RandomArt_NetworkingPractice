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

protocol NetworkManagerProtocol: AnyObject {
    func retrieveDepartmentIDs(completion: @escaping (Result<DepartmentIDs, NetworkError>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {

    static let shared = NetworkManager()

    typealias DepartmentResult = Result<DepartmentIDs, NetworkError>

    //MARK: Retrieve Department IDs (first called
    func retrieveDepartmentIDs(completion: @escaping (DepartmentResult) -> Void) {
        guard let departmentIDUrl = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/departments") else {
            completion(.failure(.invalidDepartmentUrl))
            return
        }
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: departmentIDUrl)

        let task = session.dataTask(with: request) { data, _, error in

            if let error = error {
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

    //TODO: write method to parse departmentIDS, maybe use generics so the function can be reused
}

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

