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
    var level = ["Maternelle","Collèges","Lycée"]
    let pickerSchool = UIPickerView()
    var lastPressedTextField: UITextField?
    var currentIndex = 0
    let toolBar = UIToolbar()
    
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
                    RequestService.gettenCity.append(cities[i].city!)
                }
            case .failure(let error):
                print(error)
            }
        }
        //
        
       
        toolBar.sizeToFit()
        let buttonDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closePicker))
        toolBar.setItems([buttonDone], animated: true)
       // lastPressedTextField?.inputAccessoryView = toolBar
    }
    
    @IBAction func textFieldDidBeginEditing(_ textField: UITextField) {
        lastPressedTextField = textField
        lastPressedTextField?.inputAccessoryView = toolBar
        lastPressedTextField!.inputView = pickerSchool
    }
    
    @IBAction func getAllCitiesPressButton(_ sender: UIButton) {
        
        print(RequestService.gettenSchool)
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
        currentIndex = row
        if lastPressedTextField == cityTextField {
            self.cityTextField.text = RequestService.gettenCity[row]
        }
        else if lastPressedTextField == levelSchoolTextField {
            self.levelSchoolTextField?.text = level[row]
        }
        else  {
            self.schoolTextField.text = RequestService.gettenSchool[row]
        }
    }
}

extension SettingViewController{
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
            pickerSchool.isHidden = false
            textField.inputView = pickerSchool;
            return false
        }
   func textFieldDidEndEditing(_ textField: UITextField) {
            pickerSchool.isHidden = true
        }
    
    
    @IBAction func signOutButton(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "username")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
    
    @objc func closePicker(){
        if lastPressedTextField == cityTextField {
                  print(currentIndex)
                  lastPressedTextField?.text = RequestService.gettenCity[currentIndex]
              } else if lastPressedTextField == levelSchoolTextField {
                  print(currentIndex)
                  lastPressedTextField?.text = level[currentIndex]
                  //
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
                              RequestService.gettenSchool.append(schools[i].name!)
                          }
                      case .failure(let error):
                          print(error)
                      }
                  }
                  //
              }
        else if lastPressedTextField == schoolTextField {
                  print(currentIndex)
                  schoolTextField?.text = RequestService.gettenSchool[currentIndex]
              }
        lastPressedTextField?.resignFirstResponder()
        view.endEditing(true)
    }
}
