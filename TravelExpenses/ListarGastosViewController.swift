//
//  ListarGastosViewController.swift
//  TravelExpenses
//
//  Created by Kiev Gama on 05/05/19.
//  Copyright © 2019 Kiev Gama. All rights reserved.
//

import UIKit

class ListarGastosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    var viagem: Viagem = Model.null_viagem
    
    @IBOutlet weak var labelViagem: UILabel!
    @IBOutlet weak var tableViewGastos: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewGastos.delegate = self
        self.tableViewGastos.dataSource = self
        self.labelViagem.text = viagem.descricao
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewGastos.reloadData()
        var total = 0.0
        
        for gasto in viagem.gastos {
            total = total + gasto.valor
        }
        totalLabel.text = "Total de Gastos R$ " + String(format: "%.2f", total)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viagem.gastos.count
    }
    
    
   @IBAction func unwindToGastos(segue: UIStoryboardSegue) {}
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewGastos.dequeueReusableCell(withIdentifier: "cellGasto") as! GastoTableViewCell
        let gasto = viagem.gastos[indexPath.row]

        let valorGasto = String(format: "%.2f", gasto.cambio * gasto.valor)
        let textoValor  = String(format: "R$%1$@(%2$@%3$@)", valorGasto , gasto.moeda,  String(format: "%.2f", gasto.valor) )
        cell.descricaoLabel?.text = gasto.descricao
        cell.dataLabel?.text = gasto.data
        cell.cambioLabel?.text = String(format: "R$%1$@/%2$@", String(format: "%.2f", gasto.cambio) , gasto.moeda)
        cell.valorLabel?.text = textoValor
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adicionarGasto" {
            if let vc = segue.destination as? AdicionarGastoViewController {
               vc.viagem = self.viagem
            }
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            viagem.gastos.remove(at: indexPath.row)
            tableViewGastos.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
}
