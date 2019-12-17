import UIKit

struct GlobalVariable {
    static var users: [User] = []
    static var userProfilesController: UsersProfilesViewController = UsersProfilesViewController()
    static var selectedUserIndex = -1
}

class User: Codable{
    var name: String?
    var surname: String?
    var patronymic: String?
    
    var login: String?
    var password: String?
    var birthdate: String?
    var sex: String?
    var description: String?
    var imgData: Data
    
    init(name: String, surname: String, patronymic: String, login: String, password: String, birthdate: String, sex: String, description: String, imgData: Data){
    
        self.name = name
        self.surname = surname
        self.patronymic = patronymic
        self.login = login
        self.password = password
        self.birthdate = birthdate
        self.sex = sex
        self.description = description
        self.imgData = imgData
    }
    
    public static func save(UsersArray: [User]){
        
        let usersData = try! JSONEncoder().encode(UsersArray)
        UserDefaults.standard.set(usersData, forKey: "users")
    }
    
    public static func getUsers() -> [User]?{
        let userData = UserDefaults.standard.data(forKey: "users")
        if (userData == nil){
            return []
        }
        let userArray = try! JSONDecoder().decode([User].self, from: userData!)
        return userArray
    }
}
