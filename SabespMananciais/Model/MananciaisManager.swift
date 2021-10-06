//
//  MananciaisManager.swift
//  SabespMananciais
//
//  Created by Ed Yama on 05/10/21.
//

import Foundation

protocol ManancialManagerDelegate {
    func didFailWithError(error: Error)
    func didUpdateVolume(_ manancialManager: MananciaisManager, manancial: MananciaisModel)
}

struct MananciaisManager {
    
    // MARK: - Properties
    
    let mananciaisURL = "https://sabesp-api.herokuapp.com"
    let sistemas = ["Cantareira", "Alto Tietê", "Guarapiranga", "Cotia", "Rio Grande", "Rio Claro", "São Lourenço"]
    
    var delegate: ManancialManagerDelegate?
    
    func requestURL() {
        guard let url = URL(string: mananciaisURL) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            
            if let safeData = data {
                if let manancial = parseJSON(with: safeData) {
                    delegate?.didUpdateVolume(self, manancial: manancial)
                }
            }
        }
        
        task.resume()
    }
    
    func parseJSON(with data: Data) -> MananciaisModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode([MananciaisData].self, from: data)
            let dadosMananciais = decodedData
            
            let mananciais = MananciaisModel(mananciais: dadosMananciais)
            return mananciais
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
