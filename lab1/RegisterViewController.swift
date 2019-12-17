import UIKit

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate{

    @IBOutlet private weak var NameLabel: UILabel!
    
    @IBOutlet private weak var SurnameLabel: UILabel!
    
    @IBOutlet private weak var LoginLabel: UILabel!
    
    @IBOutlet private weak var PasswordLabel: UILabel!
    
    @IBOutlet private weak var DateLabel: UILabel!
    
    @IBOutlet private weak var SexLabel: UILabel!
    
    @IBOutlet private weak var DescriptionLabel: UILabel!
    
    @IBOutlet private var ImageView: UIImageView!
    
    @IBOutlet private weak var DateTextField: UITextField!
    
    @IBOutlet private weak var SexTextField: UITextField!
    
    @IBOutlet private var DescriptionTextView: UITextView!
    
    @IBOutlet private weak var PasswordTextField: UITextField!
    
    @IBOutlet private weak var PatronymicTextField: UITextField!
    
    @IBOutlet private weak var LoginTextField: UITextField!
    
    @IBOutlet private weak var SurnameTextField: UITextField!
    
    @IBOutlet private weak var NameTextField: UITextField!
    
    private var datepicker: UIDatePicker?
    
    private var sexpicker: UIPickerView?
    
    private let sexSource = ["Male", "Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ImageView.layer.borderColor = UIColor.blue.cgColor
        ImageView.layer.borderWidth = 3
        ImageView.layer.cornerRadius = 10
        ImageView.image = UIImage(named: "ImagePlaceholder")
        
        //datepicker
        let calendar = Calendar(identifier: .gregorian)
        
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        
        components.year = -10
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        
        components.year = -100
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        
        datepicker = UIDatePicker()
        datepicker?.minimumDate = minDate
        datepicker?.maximumDate = maxDate
        datepicker?.datePickerMode = .date
        datepicker?.addTarget(self, action: #selector(self.dateChanged(datepicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        DateTextField.inputView = datepicker
        
        
        //sexpicker
        sexpicker = UIPickerView()
        
        sexpicker?.center = view.center
        sexpicker?.delegate = self
        sexpicker?.dataSource = self
        
        SexTextField.inputView = sexpicker
        
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.Validation))
        self.navigationItem.rightBarButtonItem = saveButton
        
        DescriptionTextView.delegate = self
        
        
    }


    @objc func dateChanged(datepicker:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        DateTextField.text = dateFormatter.string(from: datepicker.date)
    }
    
    @objc func viewTapped(gestureRecognizer :UIGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc func Validation(){
        
        var validationCompleted: Bool
        validationCompleted = true
        
        if (DescriptionTextView.text.count < 10){
            DescriptionTextView.layer.borderWidth = 1.0
            DescriptionTextView.layer.borderColor = UIColor.red.cgColor
            DescriptionLabel.text = "Description required more than 10 symbols"
            DescriptionLabel.isHidden = false
            validationCompleted = false
        }

        if (SexTextField.text?.isEmpty ?? true){
            OnValidationError(texfield: SexTextField, label: SexLabel, msg: "Enter your sex")
            validationCompleted = false
        }
        
        if (DateTextField.text?.isEmpty ?? true){
            OnValidationError(texfield: DateTextField, label: DateLabel, msg: "Enter your birth date")
            validationCompleted = false
        }
        
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "(?=.*[0-9])((?=.*[a-z])|(?=.*[A-Z]))[a-zA-Z0-9]{6,15}")

        if ((PasswordTextField.text?.count)! < 6){
            OnValidationError(texfield: PasswordTextField, label: PasswordLabel, msg: "Password must be 6-15 symbols")
            validationCompleted = false
        }
        else{
            if !(passwordRegex.evaluate(with: PasswordTextField.text)){
                OnValidationError(texfield: PasswordTextField, label: PasswordLabel, msg: "Password requires at least 1 digit, small or capital letter")
                validationCompleted = false
            }
        }
        
        let loginRegex = NSPredicate(format: "SELF MATCHES %@", "[a-zA-Z0-9]{3,20}")
        
        if ((LoginTextField.text?.count)! < 3){
            OnValidationError(texfield: LoginTextField, label: LoginLabel, msg: "Login must be 3-20 symbols")
            validationCompleted = false
        }
        else{
            if !(loginRegex.evaluate(with: LoginTextField.text)){
                OnValidationError(texfield: LoginTextField, label: LoginLabel, msg: "Login requires symbols from range A-Z, a-z, 0-9")
                validationCompleted = false
            }
        }
        
        let surnameRegex = NSPredicate(format: "SELF MATCHES %@", "[a-zA-Z']{2,20}")
        
        if ((SurnameTextField.text?.count)! < 2){
            OnValidationError(texfield: SurnameTextField, label: SurnameLabel, msg: "2-20 symbols")
            validationCompleted = false
        }
        else{
            if !(surnameRegex.evaluate(with: SurnameTextField.text)){
                OnValidationError(texfield: SurnameTextField, label: SurnameLabel, msg: "Symbols range A-Z, a-z")
                validationCompleted = false
            }
        }
        
        let nameRegex = NSPredicate(format: "SELF MATCHES %@", "[a-zA-Z]{2,15}")
        
        if ((NameTextField.text?.count)! < 2){
            OnValidationError(texfield: NameTextField, label: NameLabel, msg: "2-20 symbols")
            validationCompleted = false
        }
        else{
            if !(nameRegex.evaluate(with: NameTextField.text)){
                OnValidationError(texfield: NameTextField, label: NameLabel, msg: "Symbols range A-Z, a-z")
                validationCompleted = false
            }
        }
        
        
        
        if (validationCompleted){
            
            //User.save(UsersArray: userArray)
            
            let imgData:Data = UIImagePNGRepresentation(ImageView.image!)! as Data
            GlobalVariable.users.insert(User(name: NameTextField.text!, surname: SurnameTextField.text!, patronymic: PatronymicTextField.text!, login: LoginTextField.text!, password: PasswordTextField.text!, birthdate: DateTextField.text!, sex: SexTextField.text!, description: DescriptionTextView.text!, imgData : imgData), at: 0)
            
//            GlobalVariable.users.append(User(name: NameTextField.text!, surname: SurnameTextField.text!, patronymic: PatronymicTextField.text!, login: LoginTextField.text!, password: PasswordTextField.text!, birthdate: DateTextField.text!, sex: SexTextField.text!, description: DescriptionTextView.text!, imgData : imgData))
            //userArray.append(User(name: "aaaaa", surname: "bbbbb", patronymic: "cccccc", imgurl: "ddddd", login: "fffff", password: "ggggg", birthdate: "hhhh", sex: "iiii", description: "jjjj", imgData : imgData))
            
            let usersProfilesViewController = self.storyboard?.instantiateViewController(withIdentifier: "UsersProfilesViewController") as! UsersProfilesViewController
            
            self.navigationController?.pushViewController(usersProfilesViewController, animated: true)
        }

    }
    
    @IBAction func DateTextFieldEditingBegin(_ sender: UITextField) {
        TextFieldEditingBegin(texfield:DateTextField, label:DateLabel)
    }
    
    
    @IBAction func SexTextFieldEditingBegin(_ sender: UITextField) {
        TextFieldEditingBegin(texfield:SexTextField, label:SexLabel)
    }
    
    @IBAction func PasswordTextFieldEditingBegin(_ sender: UITextField) {
        TextFieldEditingBegin(texfield:PasswordTextField, label:PasswordLabel)
    }
    
    
    @IBAction func LoginTextFieldEditingBegin(_ sender: Any) {
        TextFieldEditingBegin(texfield:LoginTextField, label:LoginLabel)
    }
    
    
    @IBAction func SurnameTextFieldEditingBegin(_ sender: Any) {
        TextFieldEditingBegin(texfield:SurnameTextField, label:SurnameLabel)
    }
    
    
    @IBAction func NameTextFieldEditingBegin(_ sender: Any) {
        TextFieldEditingBegin(texfield:NameTextField, label:NameLabel)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderWidth = 0
        textView.layer.borderColor = UIColor.white.cgColor
        DescriptionLabel.isHidden = true
    }
    
    func OnValidationError(texfield: UITextField, label: UILabel, msg: String){
        texfield.text = ""
        texfield.layer.borderWidth = 1.0
        texfield.layer.borderColor = UIColor.red.cgColor
        label.text = msg
        label.isHidden = false
    }
    
    func TextFieldEditingBegin(texfield: UITextField, label: UILabel){
        texfield.layer.borderWidth = 0
        texfield.layer.borderColor = UIColor.white.cgColor
        label.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sexSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sexSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        SexTextField.text = sexSource[row]
    }

    @IBAction func SelectImageButton(_ sender: Any) {
        
        
        let imagecontroller = UIImagePickerController()
        imagecontroller.delegate = self
        
        let alertController = UIAlertController(title: nil, message: "Choose a source", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Library", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
            
            imagecontroller.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagecontroller, animated: true, completion: nil)
        }))
        
        
        alertController.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
                imagecontroller.sourceType = UIImagePickerControllerSourceType.camera
                self.present(imagecontroller, animated: true, completion: nil)
            }
            else{
                
                let alerCameraController = UIAlertController(title: "Error", message: "Camera is not available", preferredStyle: UIAlertControllerStyle.alert)
                
                alerCameraController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
                }))
                self.present(alerCameraController, animated: true, completion: nil)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action:UIAlertAction) in

        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        ImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismiss(animated: true, completion: nil)
    }

}
