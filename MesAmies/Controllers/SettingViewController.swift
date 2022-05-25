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
    var level =  [String]()
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
    
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var stackCity: UIStackView!
    @IBOutlet weak var stackLevel: UIStackView!
    @IBOutlet weak var stackSchool: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLevelArrayAfterAdditionASchool()
        
        stackCity.layer.borderColor = UIColor.darkGray.cgColor
        stackCity.layer.borderWidth = 3.0
        stackLevel.layer.borderColor = UIColor.darkGray.cgColor
        stackLevel.layer.borderWidth = 3.0
        stackSchool.layer.borderColor = UIColor.darkGray.cgColor
        stackSchool.layer.borderWidth = 3.0
        
        pickerSchool.delegate = self
        pickerSchool.dataSource = self
        cityTextField.placeholder = String(UserDefaults.standard.integer(forKey: "id"))
        
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
        level = RequestService.gettenLevel
        print(level, "level1")
        level = initialLevelArrayFinal()
        print(level, "level2")
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
    @IBAction func saveAddSchoolButtonPressed(_ sender: UIButton) {
        let userId : String = UserDefaults.standard.string(forKey: "id")!
        let schoolId = String( Int(RequestService.gettenSchool.firstIndex(where: {$0 == schoolTextField.text})!) + 1)
        let level = levelSchoolTextField.text!
        // MARK: - Add New School
        let parameters : Parameters = [ "userId" : userId as Any,
                                        "level": level,
                                        "schoolId": schoolId as Any
        ]
        guard let api = URL(string:"http://localhost/mesamies/addSchool.php")
        else { return  }
        repository.addNewSchool(url: api, method: .post, parameters: parameters) { dataResponse in
            switch dataResponse{
            case .success(let isSuccess):
                if isSuccess.error == false {
                    print(isSuccess.message)
                }
                else if isSuccess.error == true {
                    print(isSuccess.message)
                    return }
            case .failure(let error):
                print(error)
                return
            }
        }
        //
        cityTextField.text = ""
        levelSchoolTextField.text = ""
        schoolTextField.text = ""
        setLevelArrayAfterAdditionASchool()
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
            lastPressedTextField?.text = RequestService.gettenCity[currentIndex]
        } else if lastPressedTextField == levelSchoolTextField {
            //  lastPressedTextField?.text = level[currentIndex]
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
                        RequestService.gettenSchoolId.append(Int(schools[i].id!)!)
                    }
                case .failure(let error):
                    print(error)
                }
            } //
        }
        else if lastPressedTextField == schoolTextField {
            schoolTextField?.text = RequestService.gettenSchool[currentIndex]
        }
        lastPressedTextField?.resignFirstResponder()
        view.endEditing(true)
    }
    func fillLevelArray(for userId : Int){
        let parameters : Parameters = [ "userId" : userId ]
        guard let api = URL(string:"http://localhost/mesamies/countLevel.php")
        else { return }
        repository.countLevel(url: api, method: .post, parameters: parameters) { dataResponse in
            switch dataResponse{
            case .success(let levels):
                let level = levels.count
                for i in 0...level-1{
                    RequestService.gettenLevel.append(levels[i].level)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func initialLevelArrayFinal()->[String]{
        var fixedLevelArray = ["Maternelle","Colleges","Lycee"] //array1
        if RequestService.gettenLevel.count>0{
            for i in 0...RequestService.gettenLevel.count-1{
                if (  fixedLevelArray.contains(RequestService.gettenLevel[i])){
                    fixedLevelArray.remove(at:fixedLevelArray.firstIndex(of: RequestService.gettenLevel[i])! )
                }
            }
        }
        return fixedLevelArray
    }
    
    func setLevelArrayAfterAdditionASchool(){
        fillLevelArray(for: UserDefaults.standard.integer(forKey: "id"))
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [self] in
            level = RequestService.gettenLevel
            level = initialLevelArrayFinal()
            if level.count == 0{
                mainStack.isHidden = true
            }
        })
    }
}

