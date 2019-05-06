//
//  AdicionarGastoViewController.swift
//  TravelExpenses
//
//  Created by Kiev Gama on 05/05/19.
//  Copyright © 2019 Kiev Gama. All rights reserved.
//

import UIKit

class AdicionarGastoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var viagem: Viagem = Model.null_viagem
    
    @IBOutlet weak var moedaPickerView: UIPickerView!
    @IBOutlet weak var viagemLabel: UILabel!
    @IBOutlet weak var descricaoTextField: UITextField!
    @IBOutlet weak var dataTextField: UITextField!
    @IBOutlet weak var valorGastoTextField: UITextField!
    @IBOutlet weak var cambioTextField: UITextField!
    @IBOutlet weak var valorConvertidoLabel: UILabel!
    let moedas = ["USD", "EUR", "GBP"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viagemLabel.text = viagem.descricao
        self.moedaPickerView.delegate = self
        self.moedaPickerView.dataSource = self
    }
    
    @IBAction func consultarCambio(_ sender: Any) {
        let regex = "^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$"
        
        if dataTextField.text?.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil {
            if let data = dataTextField.text?.components(separatedBy:  "/") {
                let dataFormatada = String(format: "%2$@-%1$@-%3$@", data[0], data[1],data[2])
                print(dataFormatada)
                print(getMoeda())
                consultarCambio(moeda: getMoeda(), dataCotacao: dataFormatada)
            }
        } else {
            showAlert("O formato DD/MM/AAAA deve ser utilizado na data ")
        }
    }
    
    func consultarCambio(moeda: String, dataCotacao: String) {
        let session = URLSession.shared
        let urlString = "https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/CotacaoMoedaDia(moeda=@moeda,dataCotacao=@dataCotacao)?@moeda='" + moeda + "'&@dataCotacao='" + dataCotacao + "'&$top=1&$format=json&$select=cotacaoVenda"
        let url = URL(string: urlString)!
        let task = session.dataTask(with: url) { data, response, error in
            print(String(data: data!, encoding: String.Encoding.utf8))
            print(response)
            print(error)
            do {
                var cambio = 0.0
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                print("JSON: ",json)
                if let results = json["value"] as? [[String:Any]], results.count > 0 {
                    print(results[0]["cotacaoVenda"])
                    if let d = results[0]["cotacaoVenda"] as? NSNumber {
                        cambio = d.doubleValue
                    }
                }
                DispatchQueue.main.async {
                    if (cambio != 0.0) {
                        self.cambioTextField.text = String(format: "%.2f", cambio)
                    } else {
                        self.showAlert("Não houve retorno de taxa de câmbio para a data informada")
                    }
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showAlert("Não foi possível recuperar a taxa de câmbio")
                }
            }
        }
        task.resume()
    }
    
    func showAlert(_ mensagem: String) {
        let alertController = UIAlertController(title: "Travel Expenses", message:
            mensagem, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func getMoeda() -> String {
        let index = moedaPickerView.selectedRow(inComponent: 0)
        return moedas[index]
    }
    
    @IBAction func salvarGasto(_ sender: Any) {
        
        let novoGasto = Gasto(data: dataTextField.text!, valor: Double(valorGastoTextField.text!)!, moeda: getMoeda(), cambio: Double(cambioTextField.text!)!, descricao: descricaoTextField.text!)
        
        print("VC viagem [" + viagem.descricao + "]")
        viagem = Model.shared.addGasto(gasto: novoGasto, to: viagem)
        self.performSegue(withIdentifier: "unwindToGasto",sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ListarGastosViewController {
            vc.viagem = viagem
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return moedas.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return moedas[row]
    }

}
