//
//  MenuViewConroller.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 30/05/2022.
//

import UIKit

class MenuViewConroller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

 
    
    
    @IBAction func goToPrimary(_ sender: UIButton) {
//        let primaryViewController = storyboard?.instantiateViewController(withIdentifier: "testVC") as! PrimaryViewController
//        self.navigationController?.pushViewController(primaryViewController, animated: true)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let primaryViewController = storyBoard.instantiateViewController(withIdentifier: "testVC") as! PrimaryViewController
        self.navigationController?.pushViewController(primaryViewController, animated: true)
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
