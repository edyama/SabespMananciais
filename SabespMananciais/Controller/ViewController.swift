//
//  ViewController.swift
//  SabespMananciais
//
//  Created by Ed Yama on 05/10/21.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet var sistemaLabel: UILabel!
    @IBOutlet var capacidadeLabel: UILabel!
    @IBOutlet var volumeLabel: UILabel!
    @IBOutlet var pickerView: UIPickerView!
    
    let nameComponents = NameComponents()
    let numberOfComponents = 1
    
    var mananciais = MananciaisManager()
    var intRowManancial = 0
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        mananciais.delegate = self
        
        capacidadeLabel.text = nameComponents.capacidadeText
    }
}

// MARK: - Picker View Data Source

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mananciais.sistemas.count
    }
}

// MARK: - Picker View Delegate

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mananciais.sistemas[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        intRowManancial = row
        mananciais.requestURL()
    }
}

// MARK: - Manancial Manager Delegate

extension ViewController: ManancialManagerDelegate {
    func didUpdateVolume(_ manancialManager: MananciaisManager, manancial: MananciaisModel) {
        DispatchQueue.main.async {
            self.sistemaLabel.text = manancial.mananciais[self.intRowManancial].name
            self.volumeLabel.text = manancial.mananciais[self.intRowManancial].data[0].value
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

