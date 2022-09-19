//
//  MetDepartmentIDs.swift
//  RandomArt_APIPractice
//
//  Created by David Chester on 9/18/22.
//

import Foundation

protocol MetDepartmentIDViewModelDelegate: AnyObject {
    func updatePicker(with departmentIDs: [PickerModel])

    func handleError(error: NetworkError)
}

struct PickerModel {
    let departmentIDForPicker: Int
    let departmentNameForPicker: String
}

class MetDepartmentIDViewModel {

    var networkManager = NetworkManager.shared

    weak var delegate: MetDepartmentIDViewModelDelegate?

    func loadDepartmentIDs() {
        networkManager.retrieveDepartmentIDs { result in
            switch result {

            case .failure(let error):
                self.delegate?.handleError(error: error)
            case .success(let departmentIDs):
               let pickerModel = self.networkManager.parseDepartmentIDs(from: departmentIDs)
                self.delegate?.updatePicker(with: pickerModel)
            }
        }
    }
}


