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
    var tempArray : [String]  = []
    var tempArrayID : [Int] = []
    let pickerSchool = UIPickerView()
    var lastPressedTextField: UITextField?
    
    var api = URL(string: "http://localhost/mesamies/index.php")
    
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
           
        // MARK- get all cities available
        let parameters : Parameters = [ "city" : "",
                                        "level": ""
        ]
        repository.schoolSelect(url: api!, method: .post, parameters: parameters) { dataResponse in
            switch dataResponse {
            case .success(let cities):
               let city = cities.count
                for i in 0...city-1{
                    self.tempArray.append(cities[i].city!)
                    RequestService.gettenCity.append(cities[i].city!)
                }
            case .failure(let error):
                print(error)
            }
        } //
  }
    @IBAction func textFieldDidBeginEditing(_ textField: UITextField) {
        lastPressedTextField = textField
        textField.inputView = pickerSchool
    }
    
    @IBAction func getAllCitiesPressButton(_ sender: UIButton) {

       print(RequestService.gettenCity)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if lastPressedTextField == cityTextField {
            return RequestService.gettenCity[row]
        } else if lastPressedTextField == levelSchoolTextField {
            return  level[row]
        } else if lastPressedTextField == schoolTextField {
            return  RequestService.gettenSchool[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        if lastPressedTextField == cityTextField {
            return RequestService.gettenCity.count
        } else if lastPressedTextField == levelSchoolTextField {
            return   level.count
        } else if lastPressedTextField == schoolTextField {
            return  RequestService.gettenSchool.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        if lastPressedTextField == cityTextField {
            self.cityTextField.text = RequestService.gettenCity[row]
                }
        else if lastPressedTextField == levelSchoolTextField {
                    self.lastPressedTextField?.text = level[row]
                    let newParameters : Parameters = [
                        "city": cityTextField.text!,
                        "level" : levelSchoolTextField.text!
                    ]
                    api =  URL(string: "http://localhost/mesamies/getschools.php")
                    repository.schoolSelect(url: api!, method: .post, parameters: newParameters) { dataResponse in
                        switch dataResponse {
                        case .success(let schools):
                           let school = schools.count
                            for i in 0...school-1{
                                self.tempArray.append(schools[i].city!)
                                RequestService.gettenSchool.append(schools[i].city!)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
        else if lastPressedTextField == schoolTextField {
                    self.schoolTextField.text = RequestService.gettenSchool[row]
                }
    }
}

extension SettingViewController{
    
    @IBAction func signOutButton(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "username")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
}
