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
    var city: String?
    var name: String?
    var level = ["maternelle","Collèges","lycée"]
    var tempArray : [String]  = [""]
    var tempArrayID : [Int] = []
    let pickerSchool = UIPickerView()
    var lastPressedButton: UIButton?
    
    let api = URL(string: "http://localhost/mesamies/index.php")
    
    @IBOutlet weak var chooseCityButton: UIButton!
    @IBOutlet weak var chooseLevelButton: UIButton!
    @IBOutlet weak var chooseSchoolButton: UIButton!
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var levelSchoolTextField: UITextField!
    @IBOutlet weak var schoolTextField: UITextField!
    
    @IBOutlet weak var stackCity: UIStackView!
    @IBOutlet weak var stackLevel: UIStackView!
    @IBOutlet weak var stackSchool: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        stackCity.layer.borderColor = UIColor.darkGray.cgColor
        stackCity.layer.borderWidth = 3.0
        stackLevel.layer.borderColor = UIColor.darkGray.cgColor
        stackLevel.layer.borderWidth = 3.0
        stackSchool.layer.borderColor = UIColor.darkGray.cgColor
        stackSchool.layer.borderWidth = 3.0
        
        pickerSchool.delegate = self
        pickerSchool.dataSource = self
        }

    @IBAction func getAllCitiesPressButton(_ sender: UIButton) {
        tempArray.removeAll()
        cityTextField.inputView = pickerSchool
        let parameters : Parameters = [ "city" : "q",
                                        "level": "q"
        ]
        repository.schoolSelect(url: api!, method: .post, parameters: parameters) { dataResponse in
            switch dataResponse {
            case .success(let schools):
               let school = schools.count
                for i in 0...school-1{
                    self.tempArray.append(schools[i].city!)
                    print( self.tempArray[i])
                }
            case .failure(let error):
                print(error)
            }
        }
       print(self.tempArray)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if lastPressedButton == chooseCityButton {
            return tempArray[row]
        } else if lastPressedButton == chooseLevelButton {
           // return  secondarySchoolArray[row]
        } else if lastPressedButton == chooseSchoolButton {
          //  return  highSchoolArray[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        if lastPressedButton == chooseCityButton {
            return tempArray.count
        } else if lastPressedButton == chooseLevelButton {
          //  return   temporaryArray.count
        } else if lastPressedButton == chooseSchoolButton {
          //  return  temporaryArray.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        if lastPressedButton == chooseCityButton {
                    self.cityTextField.text = tempArray[row]
                } else if lastPressedButton == chooseLevelButton {
                  //  self.SecondarySchoolText.text = temporaryArray[row]
                } else if lastPressedButton == chooseSchoolButton {
                 //   self.highSchoolText.text = temporaryArray[row]
                }
    }
    
    @IBAction func signOutButton(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "username")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
}

extension SettingViewController{
    
    func addSchool(forCity city: String, andLevel level: String, completion: @escaping([String]) -> Void){
        tempArray.removeAll()
        tempArrayID.removeAll()
        //        guard let api = URL(string: "http://localhost/mesamies/index.php") else { return }
        let parameters: Parameters = [
            "city": city,
            "level" : level
        ]
        repository.schoolSelect(url: api!, method: .post, parameters: parameters, callback:  {  dataReponse in
            var tempArrayCity = [""]
            var tempArrayId : [Int] = []
            switch dataReponse {
            case .success(let school):
                for index in 1...school.count-1 {
                    if city == "q" && level == "q"{
                        tempArrayCity.append(school[index].city!)
                    } else if city != "q" && level != "q"{
                        tempArrayCity.append(school[index].city!)
                        tempArrayId.append(Int(school[index].id!)!)
                    }
                }
                completion(tempArrayCity)
            case .failure(let error):
                print(error, "r")
            }
        })
    }
}
