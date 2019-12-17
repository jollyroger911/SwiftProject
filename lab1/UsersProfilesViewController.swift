import UIKit

class UsersProfilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var UsersTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GlobalVariable.userProfilesController = self
        GlobalVariable.selectedUserIndex = 0
    
        //        userArray = User.getUsers()!
        //        userArray.append(User(name: "aaaaa", surname: "bbbbb", patronymic: "cccccc", imgurl: "ddddd", login: "fffff", password: "ggggg", birthdate: "hhhh", sex: "iiii", description: "jjjj"))
        //        userArray.append(User(name: "aaaaa", surname: "bbbbb", patronymic: "cccccc", imgurl: "ddddd", login: "fffff", password: "ggggg", birthdate: "hhhh", sex: "iiii", description: "jjjj"))
        //        User.save(UsersArray: userArray)
        //
        //        userArray = User.getUsers()!
    

        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalVariable.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        
        if (indexPath.row == 0){
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.red.cgColor
        }
        else{
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.black.cgColor
        }

        
        cell.setUserProperties(user: GlobalVariable.users[indexPath.row])
        //cell.textLabel?.text = userArray[indexPath.row].name
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        tableView.beginUpdates()
        GlobalVariable.selectedUserIndex = indexPath.row
        tableView.endUpdates()
        //tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.row == GlobalVariable.selectedUserIndex
        {
            return 340
        }else{
            return 50
        }
        
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.row != 0){
            return true
        }
        else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            GlobalVariable.users.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            //tableView.reloadData()
        }
    }
    
    @IBAction func pushRegisterViewControllerAddAction(_ sender: Any) {
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    
    
    @IBAction func SignOutButton(_ sender: UIButton) {
        
        //let MainPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "UsersProfilesViewController") as! UsersProfilesViewController
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
