//
//  SettingViewController.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 09/05/2022.
//

import UIKit
import Alamofire

class SettingViewController: UIViewController {

    var repository : RequestService = RequestService()
   
    var typeSchool: String = ""
    var allSchoolArray : [String] = []
    var schoolId : [Int] = []
    @IBOutlet weak var addSchoolMaternnelleButton: UIButton!
    @IBOutlet weak var maternelleSchoolLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        maternelleSchoolLabel.layer.borderColor = UIColor.darkGray.cgColor
        maternelleSchoolLabel.layer.borderWidth = 3.0
    }
    

    @IBAction func addMaternelleButtonPressed(_ sender: UIButton) {
         addSchool(forSchoolType: "maternelle")
    }
    @IBAction func signOutButton(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "username")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
}

extension SettingViewController{
    
    func addSchool(forSchoolType type: String){
        allSchoolArray.removeAll()
        guard let api = URL(string: "http://localhost/mesamies/schools.php") else { return  }
        let parameters: Parameters = [
            "type" : type
        ]
        repository.schoolSelect(url: api, method: .post, parameters: parameters, callback: { [self]   dataReponse in
        
            switch dataReponse {
            case .success(let school):
                print( school.count )
                for i in 0...school.count-1 {
                    self.allSchoolArray.append("\(school[i].name), \(school[i].city) - \(school[i].code)")
                    self.schoolId.append(Int(school[i].id)!)
                  //  print("\(i+1)-", school[i].name)
                }
                print(schoolId, allSchoolArray)
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
}
