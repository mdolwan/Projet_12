//
//  signUpViewController.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 08/05/2022.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController {
    
    var repository : RequestService = RequestService()
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpNewMember(_ sender: UIButton) {
        guard
            let useremail = emailTextField.text,
            let password = passWordTextField.text,
            let username = nameTextField.text
        else { return }
        
        let parameters: Parameters = [
            "username":username,
            "useremail": useremail,
            "password": password
        ]
        guard let api = URL(string:"http://localhost/mesamies/signup.php")
        else { return  }
        repository.signUpRequest(url: api, method: .post, parameters: parameters) { dataResponse in
            switch dataResponse{
            case .success(let isSuccess):
                if isSuccess.error == false {
                    self.showSimpleAlert(withTitle: "congratulations", andDescription: "You are signed up, Sign in now")
                }
                else if isSuccess.error == true {
                    self.showSimpleAlert(withTitle : "Unfortunately", andDescription : "Try to use other informations")
                    return }
            case .failure(_):
                self.showSimpleAlert(withTitle : "Unfortunately", andDescription : "An Error is done")
                return
            }
        }
    }
}
extension SignUpViewController{
    func showSimpleAlert(withTitle title: String, andDescription description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
