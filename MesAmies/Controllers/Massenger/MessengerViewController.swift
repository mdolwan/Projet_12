//
//  MassengerViewController.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 26/05/2022.
//

import UIKit
import Alamofire

class MessengerViewController: UIViewController {
    
    var repository : RequestService = RequestService()
    var friendId = -1
    var friendName = ""
    var senderName = UserDefaults.standard.string(forKey: "pseudo")!
    
    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var tabBarLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarLabel.text = "\(String(describing: senderName))  Chat With \(friendName)"

        /*
        Timer.scheduledTimer(timeInterval: 1, target: self, selector:  #selector(getLastMessages), userInfo: nil, repeats: true) */
               
    }
   
    // MARK: - Navigation

    @objc func getLastMessages(){

    }

   
    @IBAction func sendMessageButton(_ sender: UIButton) {

        if messageTextField.text.isEmpty { return }
        let userId = friendId
        let FromId = Int(UserDefaults.standard.string(forKey: "id")!)
        let Text = messageTextField.text!

        
        let parameters: Parameters = [
            "FromId":FromId as Any,
            "ToId": userId,
            "Text": Text as Any
        ]
        guard let api = URL(string:"http://localhost/mesamies/addMessage.php")
        else { return  }
        //
        repository.sendCurrentMessage(url: api, method: .post, parameters: parameters) { dataResponse in
            switch dataResponse{
            case .success(let isSuccess):
                if isSuccess.error == false {
                    print(isSuccess.message)
                }
                else if isSuccess.error == true {
                    print(isSuccess.message)
                    return }
            case .failure(let error):
                print(error)
                return
            }
        }
        //
        messageTextField.text=""
    }
    
}
