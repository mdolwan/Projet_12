//
//  ViewController.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 29/04/2022.
//

import UIKit
import Alamofire

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    var repository : RequestService = RequestService()
    var schools : [SchoolElement] = []
    @IBOutlet weak var passWordTestField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passWordTestField.delegate = self
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
        guard let api = URL(string: "http://myfriends.fr/Authentication.php") else { return  }
        
        repository.signInRequest(url: api, method: .post, parameters: parameters, callback: { [self] dataReponse in
            
            switch dataReponse{
            case .success(let isSuccess):
                if isSuccess.error == false {
                    let userId = String(isSuccess.userid)
                    UserDefaults.standard.set("\(userId)", forKey: "id")
                    UserDefaults.standard.set(true, forKey: "username")
                    UserDefaults.standard.set("\(isSuccess.username)", forKey: "pseudo")
                    self.goToMainViewController()}
                else if isSuccess.error == true {
                    showSimpleAlert(withTitle: "Error Happen", andDescription: "Try with other information")
                   return
                }
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
    
        func showSimpleAlert(withTitle title: String, andDescription description: String) {
            let alert = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
   
}

