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
    //var schools : [SchoolElement] = []
    var typeSchool: String = ""
    var allSchoolArray : [String] = []
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
        repository.schoolSelect(url: api, method: .post, parameters: parameters, callback: {   dataReponse in
    
            switch dataReponse{
            case .success(let school):
                school.forEach { thisSchool in
                    let schoolInfo = thisSchool.id + thisSchool.name + thisSchool.city + thisSchool.code
                    allSchoolArray.append(schoolInfo) }
                print( self.allSchoolArray )
            case .failure(let error):
                print(error, "rr")
            }
        })
    }
    
}
