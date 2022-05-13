//
//  SettingViewController.swift
//  MesAmies
//
//  Created by Mohammad Olwan on 09/05/2022.
//

import UIKit
import Alamofire

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    
    var repository : RequestService = RequestService()
    
    var typeSchool: String = ""
    var primarySchoolArray : [String] = []
    var primarySchoolId : [Int] = []
    var secondarySchoolArray : [String] = []
    var secondarySchoolId : [Int] = []
    var highSchoolArray : [String] = []
    var highSchoolId : [Int] = []
    var temporaryArray: [String] = []
    var temporaryId: [Int] = []
    let pickerSchool = UIPickerView()
    var lastPressedButton: UIButton?
    
    @IBOutlet weak var addSchoolMaternnelleButton: UIButton!
    @IBOutlet weak var addSecondaryButton: UIButton!
    @IBOutlet weak var AddHighSchoolButton: UIButton!
    
    @IBOutlet weak var maternelleSchoolText: UITextField!
    @IBOutlet weak var SecondarySchoolText: UITextField!
    @IBOutlet weak var highSchoolText: UITextField!
    
    @IBOutlet weak var stackUp: UIStackView!
    @IBOutlet weak var stackMiddle: UIStackView!
    @IBOutlet weak var stackHigh: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        primarySchoolArray = addSchool(forSchoolType: "maternelle").0
        primarySchoolId = addSchool(forSchoolType: "maternelle").1
//       hSchoolId = temporaryId
      
        stackUp.layer.borderColor = UIColor.darkGray.cgColor
        stackUp.layer.borderWidth = 3.0
        stackHigh.layer.borderColor = UIColor.darkGray.cgColor
        stackHigh.layer.borderWidth = 3.0
        stackMiddle.layer.borderColor = UIColor.darkGray.cgColor
        stackMiddle.layer.borderWidth = 3.0
        
        pickerSchool.dataSource = self
        pickerSchool.dataSource = self
        
        addSchoolMaternnelleButton.addTarget(self, action:#selector(buttonClicked(sender:)), for: .touchUpInside)
        addSecondaryButton.addTarget(self, action:#selector(buttonClicked(sender:)), for: .touchUpInside)
        AddHighSchoolButton.addTarget(self, action:#selector(buttonClicked(sender:)), for: .touchUpInside)

    }
    
    @objc func buttonClicked(sender:UIButton!) {

            lastPressedButton = sender
            if lastPressedButton == addSchoolMaternnelleButton {
                maternelleSchoolText.inputView = pickerSchool
            } else if lastPressedButton == addSecondaryButton {
                SecondarySchoolText.inputView = pickerSchool
            } else if lastPressedButton == AddHighSchoolButton {
                highSchoolText.inputView = pickerSchool
            }
        }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if lastPressedButton == addSchoolMaternnelleButton {
            return primarySchoolArray[row]
        } else if lastPressedButton == addSecondaryButton {
            return  secondarySchoolArray[row]
        } else if lastPressedButton == AddHighSchoolButton {
            return  highSchoolArray[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        if lastPressedButton == addSchoolMaternnelleButton {
            return temporaryArray.count
        } else if lastPressedButton == addSecondaryButton {
            return   temporaryArray.count
        } else if lastPressedButton == AddHighSchoolButton {
            return  temporaryArray.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        if lastPressedButton == addSchoolMaternnelleButton {
                    self.maternelleSchoolText.text = temporaryArray[row]
                } else if lastPressedButton == addSecondaryButton {
                    self.SecondarySchoolText.text = temporaryArray[row]
                } else if lastPressedButton == AddHighSchoolButton {
                    self.highSchoolText.text = temporaryArray[row]
                }
    }
    
   @IBAction func addHighSchoolButtonPressed(_ sender: Any) {
//        addSchool(forSchoolType: "lycée", sender : sender as! UIButton)
    }
    @IBAction func addSecondarySchoolButtonPressed(_ sender: Any) {
//        addSchool(forSchoolType: "Collèges", sender : sender as! UIButton)
    }
    @IBAction func addMaternelleButtonPressed(_ sender: UIButton) {
//        addSchool(forSchoolType: "maternelle", sender : sender )
    }
    @IBAction func signOutButton(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "username")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
}

extension SettingViewController{
    
    func addSchool(forSchoolType type: String)-> ([String],[Int]){
       
        guard let api = URL(string: "http://localhost/mesamies/schools.php") else { return ([""],[])  }
        let parameters: Parameters = [
            "type" : type
        ]
        repository.schoolSelect(url: api, method: .post, parameters: parameters, callback:  {  dataReponse in
            
            switch dataReponse {
            case .success(let school):
                print( school.count )
                self.temporaryArray.removeAll()
                self.temporaryId.removeAll()
                for i in 0...school.count-1 {
                    self.temporaryArray.append("\(school[i].name), \(school[i].city) - \(school[i].code)")
                    self.temporaryId.append(Int(school[i].id)!)
                }
                print(self.temporaryId, self.temporaryArray)
                self.primarySchoolArray = self.temporaryArray
                self.primarySchoolId = self.temporaryId
            case .failure(let error):
                print(error)
            }
        })
        return (temporaryArray, temporaryId)
    }
}
