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

class MetDepartmentIDViewModel {

    var clientProtocol: NetworkManagerProtocol

    init(networkProtocol: NetworkManagerProtocol) {
        self.clientProtocol = networkProtocol
    }

    weak var delegate: MetDepartmentIDViewModelDelegate?

    func loadDepartmentIDs() {
        clientProtocol.retrieveDepartmentIDs { result in
            switch result {

            case .failure(let error):
                self.delegate?.handleError(error: error)
            case .success(let departmentIDs):
               let pickerModel = self.clientProtocol.parseDepartmentIDs(from: departmentIDs)
                self.delegate?.updatePicker(with: pickerModel)
            }
        }
    }
}


