import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MainPageViewController: UIViewController {

    
    @IBOutlet weak var OrLabel: UILabel!
    
    @IBOutlet weak var PasswordTF: UITextField!
    
    @IBOutlet weak var LoginTF: UITextField!
    
    @IBOutlet var LoginErrorLabel: UILabel!
    
    @IBOutlet var PasswordErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GlobalVariable.users = User.getUsers()!

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func SignInButton(_ sender: UIButton) {
        var loginPresents: Bool = false
        var passwordPresents: Bool = false
        
        var i: Int = 0
        Auth.auth().signIn(withEmail: LoginTF.text!, password: PasswordTF.text!){
            (user, error) in if error == nil{
                self.performSegue(withIdentifier: "GoHome", sender: self)
            }
        }
        for user in GlobalVariable.users {

            if (user.login == LoginTF.text){

                loginPresents = true
                if (user.password == PasswordTF.text){

                    passwordPresents = true
                    if (GlobalVariable.users.count > 1){
                        let currentUser = GlobalVariable.users[0]
                        GlobalVariable.users[0] = GlobalVariable.users[i]
                        GlobalVariable.users[i] = currentUser
                    }

                    PasswordTF.text = ""
                    LoginTF.text = ""
                    let usersProfilesViewController = self.storyboard?.instantiateViewController(withIdentifier: "UsersProfilesViewController") as! UsersProfilesViewController
                    self.navigationController?.pushViewController(usersProfilesViewController, animated: true)
                }
            }
            i += 1
       }
        if (!loginPresents){
            LoginTF.text = ""
            LoginTF.layer.borderWidth = 1.0
            LoginTF.layer.borderColor = UIColor.red.cgColor
            LoginErrorLabel.text = "Login is not correct"
            LoginErrorLabel.isHidden = false
        }

        if (!passwordPresents){
            PasswordTF.text = ""
            PasswordTF.layer.borderWidth = 1.0
            PasswordTF.layer.borderColor = UIColor.red.cgColor
            PasswordErrorLabel.text = "Password is not correct"
            PasswordErrorLabel.isHidden = false
        }

        
//        let usersProfilesViewController = self.storyboard?.instantiateViewController(withIdentifier: "UsersProfilesViewController") as! UsersProfilesViewController
//        self.navigationController?.pushViewController(usersProfilesViewController, animated: true)
        
    }
    
    @IBAction func LoginTextFieldEditingBegin(_ sender: Any) {
        LoginTF.layer.borderWidth = 0
        LoginTF.layer.borderColor = UIColor.white.cgColor
        LoginErrorLabel.isHidden = true
    }
    
    
    
    @IBAction func PasswordTextFieldEditingBegin(_ sender: UITextField) {
        PasswordTF.layer.borderWidth = 0
        PasswordTF.layer.borderColor = UIColor.white.cgColor
        PasswordErrorLabel.isHidden = true
    }
    
}
