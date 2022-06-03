//
//  MassengerViewController.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 26/05/2022.
//

import UIKit
import Alamofire

class MessengerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var repository : RequestService = RequestService()
    var friendId = -1
    var friendName = ""
    var senderName = UserDefaults.standard.string(forKey: "pseudo")!
    let apiMessanger = URL(string:"http://localhost/mesamies/getMessages.php")
    @IBOutlet weak var messangerTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var tabBarLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        messangerTableView.register(UINib(nibName: "RecieverTableViewCell", bundle: nil), forCellReuseIdentifier: "MessegeRecieved")
        messangerTableView.register(UINib(nibName: "SenderTableViewCell", bundle: nil), forCellReuseIdentifier: "MessegeSend")
        tabBarLabel.text = "\(String(describing: senderName)) Chat With \(friendName)"
       
        Timer.scheduledTimer(timeInterval: 1, target: self, selector:  #selector(getALLMessegeInstantly), userInfo: nil, repeats: true)
        //
        messangerTableView.delegate = self
        messangerTableView.dataSource = self
        

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
        self.messageTextField.text=""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
        })
        return RequestService.userMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print(UserDefaults.standard.integer(forKey: "id"), "idmoi")
//        print(RequestService.userMessangerId[indexPath.row], "idfriend")
        if Int(RequestService.userMessangerId[indexPath.row]) == UserDefaults.standard.integer(forKey: "id"){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessegeSend", for: indexPath) as? SenderTableViewCell else {
                return UITableViewCell()
            }
            let message = RequestService.userMessage[indexPath.row]
            //let studentid =  RequestService.userMessangerId[indexPath.row]
            cell.configure(with: message)
    //        cell.textLabel?.backgroundColor = .black
    //        cell.textLabel?.textColor = .white
            return cell

        } else {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessegeRecieved", for: indexPath) as? RecieverTableViewCell else {
            return UITableViewCell()
        }
        let message = RequestService.userMessage[indexPath.row]
        //let studentid =  RequestService.userMessangerId[indexPath.row]
        cell.configure(with: message)
//        cell.textLabel?.backgroundColor = .black
//        cell.textLabel?.textColor = .white
        return cell
      }
    }
}


extension MessengerViewController{
    // MARK: - To indicate that there are no recipe in favorite
    func createLabel(){

       
    }
}


extension MessengerViewController{
    // MARK: - Get ALL Messeges Instantly
 @objc func getALLMessegeInstantly(){
        RequestService.userMessangerId.removeAll()
        RequestService.userMessage.removeAll()
        RequestService.messageTime.removeAll()
        RequestService.messageDate.removeAll()
        // MARK: - Get All Messages
        let parameters1: Parameters = [
            "FromId": UserDefaults.standard.integer(forKey: "id"),
            "ToId": friendId
            ]
        repository.getMessageBetweenTowtudents(url: apiMessanger!, method: .post, parameters: parameters1) { result in
            switch result{
            case .success(let getMessage):
                //
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
      
                    for i in 0...getMessage.count-1 {
                        if (getMessage[i].fromID != "-1"){
                        RequestService.userMessangerId.append(getMessage[i].fromID)
                        RequestService.userMessage.append(getMessage[i].message)
                        RequestService.messageDate.append(getMessage[i].date)
                        RequestService.messageTime.append(getMessage[i].time)
                        } else {
                            self.createLabel()
                            return
                        }
                    }
                    DispatchQueue.main.async { [self] in
                        messangerTableView.reloadData()
                    }
                })
                //
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
}
