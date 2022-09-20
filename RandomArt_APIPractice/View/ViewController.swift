//
//  ViewController.swift
//  RandomArt_APIPractice
//
//  Created by David Chester on 9/17/22.
//

import UIKit

class ViewController: UIViewController {

    let mainView = MainView()

    var metDepartmentIDViewModel: MetDepartmentIDViewModel

    var pickerModels: [PickerModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.pickerView.delegate = self
        mainView.pickerView.dataSource = self
        mainView.randomBttn.addTarget(self, action: #selector(randomBttnPressed), for: .touchUpInside)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        metDepartmentIDViewModel.loadDepartmentIDs()
    }

    init(model: MetDepartmentIDViewModel) {
        self.metDepartmentIDViewModel = model
        super.init(nibName: nil, bundle: nil)
        self.metDepartmentIDViewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func randomBttnPressed(){
        if metDepartmentIDViewModel.objectID == 0 {
            print("change dat")
        } else {
            metDepartmentIDViewModel.loadObjectIDs()
        }

    }

}
//MARK: UIPickerDelegate and DataSource methods
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerModels.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerModels[row].departmentNameForPicker
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       // departmentIDForURL = pickerModels[row].departmentIDForPicker
        metDepartmentIDViewModel.objectID = pickerModels[row].departmentIDForPicker
    }
}

//MARK: MetDepartmentViewModelDelegate
//here we pass in the picker model we parsed from the department call to generate our picker info
extension ViewController: MetDepartmentIDViewModelDelegate {

    func updatePicker(with departmentIDs: [PickerModel]) {
        DispatchQueue.main.async {
            self.pickerModels = departmentIDs
            self.mainView.pickerView.reloadAllComponents()
        }
    }

    func handleNetworkError(error: NetworkError) {
        DispatchQueue.main.async {
            self.errorAlert(error: error.rawValue)
        }

    }

    //MARK: the ObjectID methods
    func handleObjectError(error: ObjectError) {
        DispatchQueue.main.async {
            self.errorAlert(error: error.rawValue)
        }
    }

    func updateObjectIds(with object: ObjectID) {
        DispatchQueue.main.async {
            print(object.objectIDs.count)
        }
    }
}

// MARK: UIAlertController for errors
extension ViewController {
    func errorAlert(error: String){
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))

        present(alert, animated: true)
    }
}

// MARK: LoadView Extension
extension ViewController {

    override func loadView() {
        view = UIView()
        view.backgroundColor = .purple

        view.addSubview(mainView)

        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
    }
}

