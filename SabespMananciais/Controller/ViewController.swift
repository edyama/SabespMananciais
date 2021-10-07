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
    @IBOutlet var rainDayLabel: UILabel!
    @IBOutlet var rainDayData: UILabel!
    @IBOutlet var rainMonthLabel: UILabel!
    @IBOutlet var rainMonthData: UILabel!
    @IBOutlet var rainAvgLabel: UILabel!
    @IBOutlet var rainAvgData: UILabel!
    @IBOutlet var pickerView: UIPickerView!
    
    let nameComponents = NameComponents()
    let numberOfComponents = 1
    
    var mananciaisManager = MananciaisManager()
    var intRowManancial = 0
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        mananciaisManager.delegate = self
        
        labelTextSetup()
        setupAcessibility()
    }
    
    func labelTextSetup() {
        capacidadeLabel.text = nameComponents.capacidadeText
        rainDayLabel.text = nameComponents.rainDay
        rainMonthLabel.text = nameComponents.rainMonth
        rainAvgLabel.text = nameComponents.rainAvg
    }
    
    func setupAcessibility() {
        sistemaLabel.accessibilityLabel = "\(nameComponents.sistemaAccessibility) é \(mananciaisManager.sistemas[intRowManancial])"
        sistemaLabel.accessibilityTraits = .header
        
        capacidadeLabel.accessibilityLabel = nameComponents.capacidadeAccessibility
        rainDayLabel.accessibilityLabel = nameComponents.rainDayAccessibility
        rainMonthLabel.accessibilityLabel = nameComponents.rainMonthAccessibility
        rainAvgLabel.accessibilityLabel = nameComponents.rainAvgAccessibility
        
        pickerView.isAccessibilityElement = true
        pickerView.accessibilityLabel = nameComponents.pickerViewAccessibility
        pickerView.accessibilityHint = nameComponents.pickerViewAccessibilityHint
        
        UIAccessibility.post(notification: .screenChanged, argument: pickerView)
    }
}

// MARK: - Picker View Data Source

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mananciaisManager.sistemas.count
    }
}

// MARK: - Picker View Delegate

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mananciaisManager.sistemas[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        intRowManancial = row
        mananciaisManager.requestURL()
        setupAcessibility()
    }
}

// MARK: - Manancial Manager Delegate

extension ViewController: ManancialManagerDelegate {
    func didUpdateVolume(_ manancialManager: MananciaisManager, manancial: MananciaisModel) {
        DispatchQueue.main.async {
            self.sistemaLabel.text = manancial.mananciais[self.intRowManancial].name
            self.volumeLabel.text = manancial.mananciais[self.intRowManancial].data[0].value
            self.rainDayData.text = manancial.mananciais[self.intRowManancial].data[1].value
            self.rainMonthData.text = manancial.mananciais[self.intRowManancial].data[2].value
            self.rainAvgData.text = manancial.mananciais[self.intRowManancial].data[3].value
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

