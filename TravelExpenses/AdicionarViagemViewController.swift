//
//  AdicionarViagemViewController.swift
//  TravelExpenses
//
//  Created by Kiev Gama on 05/05/19.
//  Copyright © 2019 Kiev Gama. All rights reserved.
//

import UIKit

class AdicionarViagemViewController: UIViewController {

    @IBOutlet weak var descricaoTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func salvarViagem(_ sender: Any) {
        let texto: String = self.descricaoTextField.text!
        let novaViagem = Viagem(descricao: texto, gastos: [])
        Model.shared.addViagem(viagem: novaViagem)
        self.performSegue(withIdentifier: "unwindToStart",sender:self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
