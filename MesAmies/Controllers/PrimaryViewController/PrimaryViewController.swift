//
//  MaternelleViewController.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 24/05/2022.
//

import UIKit
import Alamofire

class PrimaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
     
    var repository : RequestService = RequestService()
    var student : [Student] = []
    let listEmptyLabel = UILabel()
    var page : Int = 0
    let parameters: Parameters = [
        "userId": UserDefaults.standard.integer(forKey: "id"),
        "level": "Primary",
        "page": 0
        ]
    let api = URL(string: "http://localhost/mesamies/getstudents.php") 
    @IBOutlet weak var primaryTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Primary"
       
        RequestService.gettenStudentId.removeAll()
        RequestService.gettenStudent.removeAll()
        // MARK: - Get All Students
        repository.getStudent(url: api!, method: .post, parameters: parameters) { result in
            switch result{
            case .success(let getStudent):
                //
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    for i in 0...getStudent.count-1{
                        if Int(getStudent[i].userid) != -1 {
                        RequestService.gettenStudent.append(getStudent[i].username)
                        RequestService.gettenStudentId.append(Int(getStudent[i].userid)!)
                        } else{
                            self.createLabel()
                            return
                        }
                    }
                    DispatchQueue.main.async { [self] in
                        primaryTableView.reloadData()
                    }
                })
                //
            case .failure(let error):
                print(error)
            }
        }
        //
        
        primaryTableView.dataSource = self
        primaryTableView.delegate = self
    }
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
 }
    // MARK: - Navigation
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
         })
         return RequestService.gettenStudentId.count
     }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfPrimaryStudent", for: indexPath) as? PrimaryStudentTableViewCell else {
             return UITableViewCell()
         }
         let studentName = RequestService.gettenStudent[indexPath.row]
         let studentid =  RequestService.gettenStudentId[indexPath.row]
         cell.configure(with: studentName, and: studentid)
         cell.textLabel?.backgroundColor = .black
         cell.textLabel?.textColor = .white
         return cell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goToMessenger = storyboard?.instantiateViewController(withIdentifier: "MessengerVC") as! MessengerViewController
        goToMessenger.friendName = RequestService.gettenStudent[indexPath.row]
        goToMessenger.friendId = RequestService.gettenStudentId[indexPath.row]
        self.navigationController?.pushViewController(goToMessenger, animated: true)
    }

}

extension PrimaryViewController{
    // MARK: - To indicate that there are no recipe in favorite
    func createLabel(){
        if self.student.count == 0 {
            listEmptyLabel.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100)
            listEmptyLabel.text = "There are no Student in your School.\("\n") Add Your School, Please...."
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
        

        let position = scrollView.contentOffset.y
        if primaryTableView.contentSize.height == 0 { return }
        if position > (primaryTableView.contentSize.height - scrollView.frame.size.height)
        {
            
            self.primaryTableView.tableFooterView = createSpinnerFooter()
            let newParameters: Parameters = [
                "userId": UserDefaults.standard.integer(forKey: "id"),
                "level": "Primary",
                "page": page + 1
                ]
            // MARK: - Get All Students
            repository.getStudent(url: api!, method: .post, parameters: newParameters) { result in
                switch result{
                case .success(let getStudent):
                    //
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        for i in 0...getStudent.count-1{
                            if Int(getStudent[i].userid) != -1 {
                            RequestService.gettenStudent.append(getStudent[i].username)
                            RequestService.gettenStudentId.append(Int(getStudent[i].userid)!)
                            } else{
                                self.createLabel()
                                return
                            }
                        }
                        DispatchQueue.main.async { [self] in
                            primaryTableView.reloadData()
                        }
                    })
                    //
                case .failure(let error):
                    print(error)
                }
            }
            //
        }else{
            return
        }
    }
}
