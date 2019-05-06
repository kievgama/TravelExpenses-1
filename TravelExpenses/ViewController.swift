//
//  ViewController.swift
//  TravelExpenses
//
//  Created by Kiev Gama on 05/05/19.
//  Copyright © 2019 Kiev Gama. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func unwindToStart(segue: UIStoryboardSegue) {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.viagens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "viagemCell") as! UITableViewCell
        
        cell.textLabel?.text = Model.shared.viagens[indexPath.row].descricao
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            Model.shared.viagens.remove(at: indexPath.row)
            Model.shared.saveChanges()
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
   

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalhesViagem" {
            if let vc = segue.destination as? ListarGastosViewController {
                let linha = tableView.indexPathForSelectedRow!.row
                vc.viagem = Model.shared.viagens[linha]
            }
        }
    }

}

