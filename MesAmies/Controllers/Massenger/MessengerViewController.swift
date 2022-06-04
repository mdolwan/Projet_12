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
    var lastMessegeId = 0
    var page = 0
    var senderName = UserDefaults.standard.string(forKey: "pseudo")!
    let apiMessanger = URL(string:"http://localhost/mesamies/getMessages.php")
    // var indexPathForTabelView = 0
    
    var temporaryChatId : [Int] = []
    var temporaryUserMessangerId = [String]()
    var temporaryUserMessage = [String]()
    var temporaryMessageDate = [String]()
    var temporaryMessageTime = [String]()
    
    @IBOutlet weak var messangerTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var tabBarLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messangerTableView.delegate = self
        messangerTableView.dataSource = self
        messangerTableView.register(UINib(nibName: "RecieverTableViewCell", bundle: nil), forCellReuseIdentifier: "MessegeRecieved")
        messangerTableView.register(UINib(nibName: "SenderTableViewCell", bundle: nil), forCellReuseIdentifier: "MessegeSend")
        tabBarLabel.text = "\(String(describing: senderName)) Chat With \(friendName)"
        // Retrive The Messeges
        RequestService.chatId.removeAll()
        RequestService.userMessangerId.removeAll()
        RequestService.userMessage.removeAll()
        RequestService.messageTime.removeAll()
        RequestService.messageDate.removeAll()
        // MARK: - Get All Messages
        let parameters: Parameters = [
            "FromId": UserDefaults.standard.integer(forKey: "id"),
            "ToId": friendId
        ]
        repository.getMessageBetweenTowStudents(url: apiMessanger!, method: .post, parameters: parameters) { result in
            switch result{
            case .success(let getMessage):
                //
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [self] in
                    
                    for i in 0...getMessage.count-1 {
                        if (getMessage[i].fromID != "-1"){
                            RequestService.chatId.append(Int(getMessage[i].messegeID)!)
                            RequestService.userMessangerId.append(getMessage[i].fromID)
                            RequestService.userMessage.append(getMessage[i].message)
                            RequestService.messageDate.append(getMessage[i].date)
                            RequestService.messageTime.append(getMessage[i].time)
                        } else {
                            self.createLabel()
                            return
                        }
                    }
                    RequestService.chatId = RequestService.chatId.reversed()
                    RequestService.userMessangerId = RequestService.userMessangerId.reversed()
                    RequestService.userMessage = RequestService.userMessage.reversed()
                    RequestService.messageDate = RequestService.messageDate.reversed()
                    RequestService.messageTime = RequestService.messageTime.reversed()
                    lastMessegeId = Int(RequestService.chatId.last!)
                    DispatchQueue.main.async { [self] in
                        messangerTableView.reloadData()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [self] in
                        let  indexPathForTabelView = IndexPath(row: RequestService.userMessage.count-1, section: 0)
                        if indexPathForTabelView.row > 10 {
                            messangerTableView.scrollToRow(at: indexPathForTabelView, at: .top, animated: true)
                        }
                    })
                })
            case .failure(let error):
                print(error)
            }
        }
        Timer.scheduledTimer(timeInterval: 1, target: self, selector:  #selector(getNewMessegeInstantly), userInfo: nil, repeats: true)
    }
    // MARK: - Navigation
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
        repository.sendCurrentMessage(url: api, method: .post, parameters: parameters) { dataResponse in
            switch dataResponse{
            case .success(let isSuccess):
                if isSuccess.error == false {
                   // print(isSuccess.message)
                }
                else if isSuccess.error == true {
                   // print(isSuccess.message)
                    return }
            case .failure(let error):
                print(error)
                return
            }
        }
        self.messageTextField.text=""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
        })
        return RequestService.userMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if Int(RequestService.userMessangerId[indexPath.row]) == UserDefaults.standard.integer(forKey: "id"){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessegeSend", for: indexPath) as? SenderTableViewCell else {
                return UITableViewCell()
            }
            let message = RequestService.userMessage[indexPath.row]
            cell.configure(with: message)
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessegeRecieved", for: indexPath) as? RecieverTableViewCell else {
                return UITableViewCell()
            }
            let message = RequestService.userMessage[indexPath.row]
            cell.configure(with: message)
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
    @objc func getNewMessegeInstantly(){
        let parameters: Parameters = [
            "FromId": UserDefaults.standard.integer(forKey: "id"),
            "ToId": friendId
        ]
        // MARK: - Reinitialize For Every Time We recovery The New Messeges
        temporaryChatId.removeAll()
        temporaryUserMessangerId.removeAll()
        temporaryUserMessage.removeAll()
        temporaryMessageDate.removeAll()
        temporaryMessageTime.removeAll()
        //
        repository.getMessageBetweenTowStudents(url: apiMessanger!, method: .post, parameters: parameters) { [self] newResult in
            switch newResult{
            case .success(var newGetMessage):
               newGetMessage = newGetMessage.reversed()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [self] in
                    let numberOfNewMesseges = Int(newGetMessage.last!.messegeID)! - lastMessegeId
                    if (numberOfNewMesseges == 0){
                        return
                    }else{
                        for i in newGetMessage.count - numberOfNewMesseges...newGetMessage.count-1{
                            RequestService.chatId.append(Int(newGetMessage[i].messegeID)!)
                            RequestService.userMessangerId.append(newGetMessage[i].fromID)
                            RequestService.userMessage.append(newGetMessage[i].message)
                            RequestService.messageDate.append(newGetMessage[i].date)
                            RequestService.messageTime.append(newGetMessage[i].time)
                        }
                    }
                    DispatchQueue.main.async { [self] in
                        lastMessegeId = Int(newGetMessage.last!.messegeID)!
                        messangerTableView.reloadData()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [self] in
                        let  indexPathForTabelView = IndexPath(row: RequestService.userMessage.count-1, section: 0)
                        if indexPathForTabelView.row > 10 {
                            messangerTableView.scrollToRow(at: indexPathForTabelView, at: .top, animated: true)
                        }
                    })
                })
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MessengerViewController{
    // MARK: - Create Footer with ActivityIndicator
    private func createSpinnerFooter() -> UIView {
        
        let footerView = UIView(frame: CGRect (x: 0, y: 0, width: view.frame.size.width, height:100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        spinner.color = UIColor.white
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    // MARK: - Function for Traite The Pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        page += 1
        print(page)
//        let parameters: Parameters = [
//            "FromId": UserDefaults.standard.integer(forKey: "id"),
//            "ToId": friendId,
//            "page": page
//        ]
//        let position = scrollView.contentOffset.y
//        if messangerTableView.contentSize.height == 0 { return }
//        if position < (messangerTableView.contentSize.height - scrollView.frame.size.height)
//        {
//            self.messangerTableView.tableFooterView = createSpinnerFooter()
//            repository.getMessageBetweenTowStudents(url: apiMessanger!, method: .post, parameters: parameters) { [self] resultPlus in
//                self.messangerTableView.tableFooterView = nil
//                switch resultPlus {
//                case .success(let oldMessege):
//                   print(oldMessege)
//                case .failure(let error):
//                    print(error)
//                }
//            }
//        }else{
//            return
//        }
    }
}
