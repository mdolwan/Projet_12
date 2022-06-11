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
    
    var api = URL(string: "http://bmz.otajer.com/index.php")
    
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
        cityTextField.delegate = self
        levelSchoolTextField.delegate = self
        schoolTextField.delegate = self
        cityTextField.inputView = pickerSchool
        levelSchoolTextField.inputView = pickerSchool
        schoolTextField.inputView = pickerSchool
        cityTextField.tintColor = .clear
        levelSchoolTextField.tintColor = .clear
        schoolTextField.tintColor = .clear
        
        cityTextField.placeholder = String(UserDefaults.standard.integer(forKey: "id")) + "  " + cityTextField.placeholder!
        
        // MARK- get all cities available
        let parameters : Parameters = [: // This Query don't need to Parameters, becuase it is SELECT * FROM TABLE
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
        lastPressedTextField?.inputAccessoryView = toolBar
    }
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func textFieldDidBeginEditing(_ sender: UITextField) {
        lastPressedTextField = sender
       }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currentIndex = row
        if lastPressedTextField == cityTextField {
            return RequestService.gettenCity[currentIndex]
        } else if lastPressedTextField == levelSchoolTextField {
            return  level[currentIndex]
        } else if lastPressedTextField == schoolTextField {
            return  RequestService.gettenSchool[currentIndex]
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
            self.cityTextField.text = RequestService.gettenCity[currentIndex]
        }
        else if lastPressedTextField == levelSchoolTextField {
            self.levelSchoolTextField?.text = level[currentIndex]
            let newParameters : Parameters = [
                "city": cityTextField.text!,
                "level" : levelSchoolTextField.text!
            ]
            //http://bmz.otajer.com/
           // api =  URL(string: "http://localhost/MyFriends/getschools.php")
            api =  URL(string: "http://bmz.otajer.com/getschools.php")
            RequestService.gettenSchool.removeAll()
            RequestService.gettenSchoolId.removeAll()
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
            }
        }
        else  {
            self.schoolTextField.text = RequestService.gettenSchool[currentIndex]
        }
    }
    @IBAction func saveAddSchoolButtonPressed(_ sender: UIButton) {
        let userId : String = UserDefaults.standard.string(forKey: "id")!
        let schoolNameId = String(Int(RequestService.gettenSchool.firstIndex(where: {$0 == schoolTextField.text})!))
        let schoolId = RequestService.gettenSchoolId[Int(schoolNameId)!]

        let level = levelSchoolTextField.text!
        // MARK: - Add New School
        let parameters : Parameters = [ "userId" : userId as Any,
                                        "level": level,
                                        "schoolId": schoolId as Any
        ]
        guard let api = URL(string:"http://localhost/MyFriends/addSchool.php")
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
        RequestService.gettenSchool.removeAll()
        RequestService.gettenSchoolId.removeAll()
        setLevelArrayAfterAdditionASchool()
    }
    
}

extension SettingViewController{
    
    @IBAction func signOutButton(_ sender: UIButton) {
        RequestService.gettenStudent.removeAll()
        RequestService.gettenStudentId.removeAll()
        RequestService.gettenSchoolId.removeAll()
        RequestService.gettenCity.removeAll()
        RequestService.gettenLevel.removeAll()
        RequestService.gettenSchool.removeAll()
        UserDefaults.standard.set(false, forKey: "username")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
    
    @objc func closePicker(){
    
        if lastPressedTextField == cityTextField {
            lastPressedTextField?.text = RequestService.gettenCity[currentIndex]
        } else if lastPressedTextField == levelSchoolTextField {
            levelSchoolTextField.text = level[currentIndex]
        }
        else if lastPressedTextField == schoolTextField {
            schoolTextField?.text = RequestService.gettenSchool[currentIndex]
        }
       // lastPressedTextField?.resignFirstResponder()
        view.endEditing(true)
    }
    func fillLevelArray(for userId : Int){
        let parameters : Parameters = [ "userId" : userId ]
        guard let api = URL(string:"http://localhost/MyFriends/countLevel.php")
        else { return }
        repository.countLevel(url: api, method: .post, parameters: parameters) { dataResponse in
            switch dataResponse{
            case .success(let levels):
                let level = levels.count
                for i in 0...level-1{
                    if levels[i].level != "null" {
                        RequestService.gettenLevel.append(levels[i].level)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func initialLevelArrayFinal()->[String]{
        var fixedLevelArray = ["Primary","Secondary","Lyceum"] //array1
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

extension SettingViewController{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
      }
}
