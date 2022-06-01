//
//  ViewController.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 29/04/2022.
//

import UIKit
import Alamofire

class SignInViewController: UIViewController {
    
    var repository : RequestService = RequestService()
    var schools : [SchoolElement] = []
    @IBOutlet weak var passWordTestField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pressedButton(_ sender: Any) {
        guard
            let useremail = emailTextField.text,
            let password  = passWordTestField.text
        else { return }
        
        let parameters: Parameters = [
            "useremail": useremail,
            "password": password
        ]
        guard let api = URL(string: "http://localhost/mesamies/Authentication.php") else { return  }
        
        repository.signInRequest(url: api, method: .post, parameters: parameters, callback: { dataReponse in
            
            switch dataReponse{
            case .success(let isSuccess):
                if isSuccess.error == false {
                    let userId = String(isSuccess.userid)
                    UserDefaults.standard.set("\(userId)", forKey: "id")
                    UserDefaults.standard.set(true, forKey: "username")
                    UserDefaults.standard.set("\(isSuccess.username)", forKey: "pseudo")
                    self.goToMainViewController()}
                else if isSuccess.error == true {
                   return }
            case .failure(_):
       return
            }
        })
        //

        }
}

extension SignInViewController {
    func isSighned ()-> Bool{
        return UserDefaults.standard.integer(forKey: "id") > 0
        //return UserDefaults.standard.bool( forKey: "username")
    }
    
    func goToMainViewController() {
        if isSighned(){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        }
        
    }
}

