//
//  MetDepartmentIDs.swift
//  RandomArt_APIPractice
//
//  Created by David Chester on 9/18/22.
//

import Foundation

protocol MetDepartmentIDViewModelDelegate: AnyObject {
    func updatePicker(with departmentIDs: [PickerModel])

    func updateObjectIds(with object: ObjectID)

    func handleNetworkError(error: NetworkError)

    func handleObjectError(error: ObjectError)
}

class MetDepartmentIDViewModel {

    var clientProtocol: NetworkManagerProtocol

    init(networkProtocol: NetworkManagerProtocol) {
        self.clientProtocol = networkProtocol
    }

    var objectID: Int = 0

    weak var delegate: MetDepartmentIDViewModelDelegate?

    func loadDepartmentIDs() {
        clientProtocol.retrieveDepartmentIDs { result in
            switch result {

            case .failure(let error):
                self.delegate?.handleNetworkError(error: error)
            case .success(let departmentIDs):
               let pickerModel = self.clientProtocol.parseDepartmentIDs(from: departmentIDs)
                self.delegate?.updatePicker(with: pickerModel)
            }
        }
    }

    func loadObjectIDs(){
        clientProtocol.retrieveObjectIDs(objectID: objectID) { result in

            switch result {
            case .failure(let error):
                self.delegate?.handleObjectError(error: error)
            case .success(let objectIDs):
                self.delegate?.updateObjectIds(with: objectIDs)
                
            }
        }
    }
}


