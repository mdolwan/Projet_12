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
    let listEmptyLabel = UILabel()
    var friendId = -1
    var friendName = ""
    var lastMessegeId = 0
    var firstMessegeId = 1
    var page = 0
    var senderName = UserDefaults.standard.string(forKey: "pseudo")!
    //http://bmz.otajer.com/
    //http://localhost/MyFriends/
    // http://myfriends.fr/getMessages.php
    let apiMessanger = URL(string:"http://myfriends.fr/getMessages.php")
    // variable to save the last position visited, default to zero
    private var lastContentOffset: CGFloat = 0
    
    @IBOutlet weak var messangerTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var tabBarLabel: UILabel!
    var myActivityIndicator: UIActivityIndicatorView! = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messangerTableView.delegate = self
        messangerTableView.dataSource = self
        messangerTableView.separatorStyle = .none
        messangerTableView.rowHeight = UITableView.automaticDimension;
        messangerTableView.estimatedRowHeight = 70.0; // set to whatever your "average" cell height is
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
        createActivityIndicator()
        let parameters: Parameters = [
            "FromId": UserDefaults.standard.integer(forKey: "id"),
            "ToId": friendId,
            "Page": page
        ]
        repository.getMessageBetweenTowStudents(url: apiMessanger!, method: .post, parameters: parameters) { result in
            switch result{
            case .success(let getMessage):
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
                            self.page = 0
                            print(page)
                        }
                    })
                })
            case .failure(let error):
                print(error)
            }
           
        }
        self.hideActivityIndicator()
        Timer.scheduledTimer(timeInterval: 10, target: self, selector:  #selector(getNewMessegeInstantly), userInfo: nil, repeats: true)
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
            "Text": Text as Any // http://localhost/MyFriends/
        ]
        guard let api = URL(string:"http://myfriends.fr/addMessage.php")
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
    // MARK: - Get ALL Messeges Instantly
    @objc func getNewMessegeInstantly(){
        let parameters: Parameters = [
            "FromId": UserDefaults.standard.integer(forKey: "id"),
            "ToId": friendId,
            "Page": 0
        ]
        // MARK: - Reinitialize For Every Time We recovery The New Messeges
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
        spinner.color = UIColor.black
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    // MARK: - Function for Traite The Pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !repository.isPagination else{
            return
        }
       // print(!repository.isPagination)
        if firstMessegeId == 0 { return }
       // repository.isPagination = true
        if (self.lastContentOffset > scrollView.contentOffset.y)
        { //
            print(page, "1")
            page += 1
            print(scrollView.contentOffset.y, page)
            let parameters: Parameters = [
                "FromId": UserDefaults.standard.integer(forKey: "id"),
                "ToId": friendId,
                "Page": page
            ]
            print(page, "2")
            //
            self.messangerTableView.tableHeaderView = createSpinnerFooter()
            repository.getMessageBetweenTowStudents(url: apiMessanger!, method: .post, parameters: parameters) { [self] oldResultPlus in
                self.messangerTableView.tableHeaderView = nil
                switch oldResultPlus {
                case .success(let oldMessege):
                    for i in 0...oldMessege.count-1{
                        if Int(oldMessege[oldMessege.count-1].messegeID) == 1 {
                            self.firstMessegeId = 0
                        }
                        print(self.firstMessegeId, "firstMessegeId")
                        if (oldMessege[i].fromID != "-1"){
                        RequestService.chatId.insert(Int(oldMessege[i].messegeID)!, at: 0)
                        RequestService.userMessangerId.insert(oldMessege[i].fromID, at: 0)
                        RequestService.userMessage.insert(oldMessege[i].message, at: 0)
                        RequestService.messageDate.insert(oldMessege[i].date, at: 0)
                        RequestService.messageTime.insert(oldMessege[i].time, at: 0)
                        }else { return }
                    }
                case .failure(let error):
                    print(error)
                }
                print(page, "3")
                DispatchQueue.main.async { [self] in
                    messangerTableView.reloadData()
                }
                repository.isPagination = false
            }
        }else if (self.lastContentOffset < scrollView.contentOffset.y){
            print("move to down")
//            page = 0
            return
        }
        // update the new position acquired
            self.lastContentOffset = scrollView.contentOffset.y
    }
    
}
extension MessengerViewController{
// MARK: - Display UIActivityIndiatorView
func createActivityIndicator(){
    myActivityIndicator.center = self.view.center
    myActivityIndicator.hidesWhenStopped = true
    myActivityIndicator.style = .large
    myActivityIndicator.color = .black
    self.view.addSubview(myActivityIndicator)
    myActivityIndicator.startAnimating()
    self.view.isUserInteractionEnabled = false
}

// MARK: - Hide UIActivityIndicator
func hideActivityIndicator() {
    myActivityIndicator.stopAnimating()
    self.view.isUserInteractionEnabled = true
}
    // MARK: - To indicate that there are no friends
    func createLabel(){
        if RequestService.chatId.count == 0 {
            listEmptyLabel.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100)
            listEmptyLabel.text = "There are no more messeges.\("\n") Send First messege now...."
            listEmptyLabel.numberOfLines = 0
            listEmptyLabel.center = self.view.center
            listEmptyLabel.textAlignment = .center
            listEmptyLabel.backgroundColor = UIColor.black
            listEmptyLabel.textColor = UIColor.white
            self.view.addSubview(listEmptyLabel)
        }
        else{
            listEmptyLabel.removeFromSuperview()
        }
    }
}


