import UIKit
import Firebase
import CryptoSwift
import CoreData

class SignupViewController: UIViewController {

    @IBOutlet weak var nameTextField: DesignableUITextField!
    @IBOutlet weak var emailTextField: DesignableUITextField!
    @IBOutlet weak var numberTextField: DesignableUITextField!
    @IBOutlet weak var passwordTextField: DesignableUITextField!
    @IBOutlet weak var confirmPasswordTextField: DesignableUITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == C.signupSegue {
                    let tabControl = segue.destination as! UITabBarController
                    let destinationVC1 = tabControl.viewControllers![0] as! MapViewController
                    destinationVC1.userEmail = emailTextField.text!
                    
                    let destinationVC2 = tabControl.viewControllers![1] as! FriendsNavigationViewController
                    let destinationVC3 = destinationVC2.topViewController as! FriendsViewController
                    destinationVC3.userEmail = emailTextField.text!
                }
    }
    

    @IBAction func signupPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text {
            
            if isValidEmail(email) {
                if isValidPassword(password) {
                    if confirmPassword == password {
                        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                            if let e = error {
                                print(e)
                            }
                            else {
                                
                                let uuid = UUID().uuidString
                                let passwordMD5 = self.passwordTextField.text!.md5()
                                
                                let userData = [
                                    "uuid": uuid,
                                    "name": self.nameTextField.text!,
                                    "email": self.emailTextField.text!,
                                    "password": passwordMD5,
                                    "number": self.numberTextField.text!]
                                
                                C.Db.db.collection("users").document(uuid).setData(userData)
                                
                                let user = CurrentUser(context: self.context)
                                
                                user.name = self.nameTextField.text!
                                user.mail = self.emailTextField.text!
                                user.number = self.numberTextField.text!
                                user.uuid = uuid
                                
                                self.saveUser()

                                self.performSegue(withIdentifier: C.signupSegue, sender: self)
                            }
                        }
                    }
                    else {
                        let textField = TextFieldAnimation(textField: confirmPasswordTextField)
                        textField.textFieldAnimation()
                        confirmPasswordTextField.text = ""
                    }
                }
                else {
                    let textField = TextFieldAnimation(textField: passwordTextField)
                    textField.textFieldAnimation()
                    let textField2 = TextFieldAnimation(textField: confirmPasswordTextField)
                    textField2.textFieldAnimation()
                    passwordTextField.text = ""
                    confirmPasswordTextField.text = ""
                }
                
            }
            else {
                let textField = TextFieldAnimation(textField: emailTextField)
                textField.textFieldAnimation()
            }
            
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//
//        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//
//        //evaluate - belli koşullarda eşleşip eşleşmediğini kontrol
//        return emailPred.evaluate(with: email)
        return true
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^.*(?=.{8,})(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*\\d).*$"
        
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        
        return passwordPred.evaluate(with: password)
        
    }
    
    func saveUser() {
        do {
            try context.save()
        }
        catch {
            print("Error saving context \(error)")
        }
    }

}


