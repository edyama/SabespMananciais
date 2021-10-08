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
    
    func requestURL(at row: Int) {
        guard let url = URL(string: mananciaisURL) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            
            if let safeData = data {
                if let manancial = parseJSON(with: safeData, at: row) {
                    delegate?.didUpdateVolume(self, manancial: manancial)
                }
            }
        }
        
        task.resume()
    }
    
    func parseJSON(with data: Data, at row: Int) -> MananciaisModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode([MananciaisData].self, from: data)
            let name = decodedData[row].name
            let volume = decodedData[row].data[0].value
            let rainDay = decodedData[row].data[1].value
            let rainMonth = decodedData[row].data[2].value
            let rainAvg = decodedData[row].data[3].value
            
            let mananciais = MananciaisModel(
                name: name,
                volume: volume,
                rainDay: rainDay,
                rainMonth: rainMonth,
                rainAvg: rainAvg
            )
            return mananciais
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
