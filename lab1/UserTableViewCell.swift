import UIKit

class UserTableViewCell: UITableViewCell, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var SurnameLabel: UILabel!
    
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var PatronymicTextField: UITextField!
    
    @IBOutlet weak var LoginTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var DateTextField: UITextField!
    
    @IBOutlet weak var SexTextField: UITextField!
    
    @IBOutlet var DescriptionTextView: UITextView!
    
    @IBOutlet var PasswordLabel: UILabel!
        
    @IBOutlet var DescriptionLabel: UILabel!
    
    @IBOutlet var ImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        DescriptionTextView.delegate = self
        
        ImageView.layer.borderColor = UIColor.blue.cgColor
        ImageView.layer.borderWidth = 3

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    func setUserProperties(user: User){
        NameLabel.text = user.name
        SurnameLabel.text = user.surname
        PatronymicTextField.text = user.patronymic
        LoginTextField.text = user.login
        PasswordTextField.text = user.password
        DateTextField.text = user.birthdate
        SexTextField.text = user.sex
        DescriptionTextView.text = user.description
        ImageView.image = UIImage(data: user.imgData)
    }

    @IBAction func SaveButton(_ sender: UIButton) {
        
        var validationCompleted: Bool
        validationCompleted = true
        
        if (DescriptionTextView.text.count < 10){
            DescriptionTextView.layer.borderWidth = 1.0
            DescriptionTextView.layer.borderColor = UIColor.red.cgColor
            DescriptionLabel.text = "Description required more than 10 symbols"
            DescriptionLabel.isHidden = false
            validationCompleted = false
        }
        
        
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "(?=.*[0-9])((?=.*[a-z])|(?=.*[A-Z]))[a-zA-Z0-9]{6,15}")
        
        if ((PasswordTextField.text?.count)! < 6){
            PasswordTextField.text = ""
            PasswordTextField.layer.borderWidth = 1.0
            PasswordTextField.layer.borderColor = UIColor.red.cgColor
            PasswordLabel.text = "Password is not correct"
            PasswordLabel.isHidden = false
            validationCompleted = false
        }
        else{
            if !(passwordRegex.evaluate(with: PasswordTextField.text)){
                PasswordTextField.text = ""
                PasswordTextField.layer.borderWidth = 1.0
                PasswordTextField.layer.borderColor = UIColor.red.cgColor
                PasswordLabel.text = "Password is not correct"
                PasswordLabel.isHidden = false
                validationCompleted = false
            }
        }
        
        
        if (validationCompleted){
            
            let imgData:Data = UIImagePNGRepresentation(ImageView.image!)! as Data
            GlobalVariable.users[GlobalVariable.selectedUserIndex].imgData = imgData
            GlobalVariable.users[GlobalVariable.selectedUserIndex].patronymic = PatronymicTextField.text
            GlobalVariable.users[GlobalVariable.selectedUserIndex].password = PasswordTextField.text
            GlobalVariable.users[GlobalVariable.selectedUserIndex].description = DescriptionTextView.text
            
            let alerCameraController = UIAlertController(title: "Saved", message: "Data has been saved", preferredStyle: UIAlertControllerStyle.alert)
            
            alerCameraController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
            }))
            GlobalVariable.userProfilesController.present(alerCameraController, animated: true, completion: nil)
        }
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderWidth = 0
        textView.layer.borderColor = UIColor.white.cgColor
        DescriptionLabel.isHidden = true
    }
    
    
    @IBAction func PasswordTextFieldEditingBegin(_ sender: UITextField) {
        PasswordTextField.layer.borderWidth = 0
        PasswordTextField.layer.borderColor = UIColor.white.cgColor
        PasswordLabel.isHidden = true
    }
    
    
    @IBAction func SelectImageButton(_ sender: UIButton) {
        let imagecontroller = UIImagePickerController()
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let usersProfilesViewController = storyboard.instantiateViewController(withIdentifier: "UsersProfilesViewController") as! UsersProfilesViewController
        
//        imagecontroller.delegate = usersProfilesViewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        
        imagecontroller.delegate = self
        let alertController = UIAlertController(title: nil, message: "Choose a source", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Library", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
            
            imagecontroller.sourceType = UIImagePickerControllerSourceType.photoLibrary
            GlobalVariable.userProfilesController.present(imagecontroller, animated: true, completion: nil)
        }))
        
        
        alertController.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
                imagecontroller.sourceType = UIImagePickerControllerSourceType.camera
                GlobalVariable.userProfilesController.present(imagecontroller, animated: true, completion: nil)
            }
            else{
                
                let alerCameraController = UIAlertController(title: "Error", message: "Camera is not available", preferredStyle: UIAlertControllerStyle.alert)
                
                alerCameraController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
                }))
                GlobalVariable.userProfilesController.present(alerCameraController, animated: true, completion: nil)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action:UIAlertAction) in
            
        }))
        
        GlobalVariable.userProfilesController.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        ImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let usersProfilesViewController = storyboard.instantiateViewController(withIdentifier: "UsersProfilesViewController") as! UsersProfilesViewController
        
        GlobalVariable.userProfilesController.dismiss(animated: true, completion: nil)
    }
    
}
