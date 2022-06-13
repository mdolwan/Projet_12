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
    }
    
    @IBAction func goToPrimary(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let primaryViewController = storyBoard.instantiateViewController(withIdentifier: "testVC") as! PrimaryViewController
        self.navigationController?.pushViewController(primaryViewController, animated: true)
    }
}
