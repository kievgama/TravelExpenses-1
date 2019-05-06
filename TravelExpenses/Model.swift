//
//  Model.swift
//  TravelExpenses
//
//  Created by Kiev Gama on 05/05/19.
//  Copyright © 2019 Kiev Gama. All rights reserved.
//

import Foundation


class Model {
    static let shared = Model()
    static let VIAGEM_KEY = "_viagens"
    static let null_viagem = Viagem(descricao:"", gastos: [])
    var viagens: [Viagem]
    
    private init() {
        self.viagens = UserDefaults.standard.structArrayData(Viagem.self, forKey: Model.VIAGEM_KEY)
    }
    
    func addViagem(viagem: Viagem) {
        viagens.append(viagem)
        saveChanges()
    }
    
    func addGasto(gasto: Gasto, to: Viagem) -> Viagem {
        print("Adicionando gasto à viagem (" + to.descricao + " )")
        print("size " + String(viagens.count))
        var viagem = Model.null_viagem
        if let i = viagens.firstIndex(where:{$0.descricao==to.descricao}) {
            viagens[i].gastos.append(gasto)
            viagem = viagens[i]
        }
        //var viagem = viagens.filter({$0.descricao==to.descricao})[0]
        //viagem.gastos.append(gasto)
        
        return viagem
    }
    
    func saveChanges() {
        UserDefaults.standard.setStructArray(viagens, forKey:  Model.VIAGEM_KEY)
    }
    
}

struct Viagem : Codable {
    var descricao: String
    var gastos: [Gasto]
    
    
}

struct Gasto: Codable {
    var data: String
    var valor: Double
    var moeda: String
    var cambio: Double
    var descricao: String
    
}

struct CotacaoBC: Codable {
    let odataContext: URL
    struct Value: Codable {
        let cotacaoVenda: Double
    }
    let value: [Value]
    private enum CodingKeys: String, CodingKey {
        case odataContext = "@odata.context"
        case value
    }
}


extension UserDefaults {
    open func setStruct<T: Codable>(_ value: T?, forKey defaultName: String){
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: defaultName)
    }
    
    open func structData<T>(_ type: T.Type, forKey defaultName: String) -> T? where T : Decodable {
        guard let encodedData = data(forKey: defaultName) else {
            return nil
        }
        
        return try! JSONDecoder().decode(type, from: encodedData)
    }
    
    open func setStructArray<T: Codable>(_ value: [T], forKey defaultName: String){
        let data = value.map { try? JSONEncoder().encode($0) }
        
        set(data, forKey: defaultName)
    }
    
    open func structArrayData<T>(_ type: T.Type, forKey defaultName: String) -> [T] where T : Decodable {
        guard let encodedData = array(forKey: defaultName) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(type, from: $0) }
    }
}
