//
//  SettingViewController.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 09/05/2022.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOutButton(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "username")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
}
