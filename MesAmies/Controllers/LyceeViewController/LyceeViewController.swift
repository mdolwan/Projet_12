//
//  LyceeViewController.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 26/05/2022.
//

import UIKit
import Alamofire

class LyceeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var repository : RequestService = RequestService()
    var student : [Student] = []
    let listEmptyLabel = UILabel()
    var page : Int = 0
    let parameters: Parameters = [
        "userId": UserDefaults.standard.integer(forKey: "id"),
        "level": "Lycee",
        "page": 0
        ]
    let api = URL(string: "http://localhost/mesamies/getstudents.php")
    
    @IBOutlet weak var studentLyceeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        RequestService.gettenStudentId.removeAll()
        RequestService.gettenStudent.removeAll()
        // MARK: - Get All Students
        repository.getStudent(url: api!, method: .post, parameters: parameters) { result in
            switch result{
            case .success(let getStudent):
                //
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    for i in 0...getStudent.count-1{
                        RequestService.gettenStudent.append(getStudent[i].username)
                        RequestService.gettenStudentId.append(getStudent[i].userid)
                    }
                    DispatchQueue.main.async { [self] in
                        studentLyceeTableView.reloadData()
                    }
                })
                //
            case .failure(let error):
                print(error)
            }
        }
        //
        studentLyceeTableView.dataSource = self
        studentLyceeTableView.delegate = self
    }
    

    // MARK: - Navigation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
           // print(RequestService.gettenStudent)
        })
        return RequestService.gettenStudentId.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfLyceeStudent", for: indexPath) as? LyceeStudentTableViewCell else {
            return UITableViewCell()
        }
        let studentName = RequestService.gettenStudent[indexPath.row]
        let studentid =  RequestService.gettenStudentId[indexPath.row]
        cell.configure(with: studentName, and: studentid)
        cell.textLabel?.backgroundColor = .black
        cell.textLabel?.textColor = .white
        return cell
    }

}

extension LyceeViewController{
    // MARK: - To indicate that there are no recipe in favorite
    func createLabel(){
        if self.student.count == 0 {
            listEmptyLabel.frame = CGRect(x: 0, y: 0, width: 250, height: 100)
            listEmptyLabel.text = "There are no Student in your School.\("\n") Wait...."
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
        if studentLyceeTableView.contentSize.height == 0 { return }
        if position > (studentLyceeTableView.contentSize.height - scrollView.frame.size.height)
        {
            
            self.studentLyceeTableView.tableFooterView = createSpinnerFooter()
            let newParameters: Parameters = [
                "userId": UserDefaults.standard.integer(forKey: "id"),
                "level": "Lycee",
                "page": page + 1
                ]
            // MARK: - Get All Students
            repository.getStudent(url: api!, method: .post, parameters: newParameters) { result in
                switch result{
                case .success(let getStudent):
                    //
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        for i in 0...getStudent.count-1{
                            RequestService.gettenStudent.append(getStudent[i].username)
                            RequestService.gettenStudentId.append(getStudent[i].userid)
                        }
                        DispatchQueue.main.async { [self] in
                            studentLyceeTableView.reloadData()
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
