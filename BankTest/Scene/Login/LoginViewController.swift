    //
    //  LoginViewController.swift
    //  BankTest
    //
    //  Created by Jaber Vieira Da Silva Shamali on 05/04/21.
    //  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
    //
    //  This file was generated by the Clean Swift Xcode Templates so
    //  you can apply clean architecture to your iOS and Mac projects,
    //  see http://clean-swift.com
    //

    import UIKit

protocol LoginDisplayLogic: class{
    func displaySomething(viewModel: Login.Something.ViewModel)
    func displayDetail(viewModel: Login.Logged.ViewModel)

}

class LoginViewController: UIViewController, LoginDisplayLogic{
        
    var interactor: LoginBusinessLogic?
    var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?
    
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var userView: UIView!
    @IBOutlet var passView: UIView!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    
    @IBAction func loginActBtn(_ sender: Any) {
        
        guard let data1 = userField.text else {
            return
        }
        guard let data2 = passField.text else {
            return
        }
        
        let user = data1.isValidCPF || data1.isValidCPFNumber || data1.isValidEmail
        
        let pass = data2.isValidPass
        
        if user == pass{
            doLogin(login: data1)
        } else {
            showAlert()
        }
        
    }
    
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder){
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup(){
    let viewController = self
    let interactor = LoginInteractor()
    let presenter = LoginPresenter()
    let router = LoginRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad(){
    super.viewDidLoad()
    loadLayoutConfig()
    lastLogin()
//    doSomething()
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
//    func doSomething(){
//    let request = Login.Something.Request()
//    interactor?.doSomething(request: request)
//    }
    
    func doLogin(login:String){
        let request = Login.Something.Request(login: login)
        interactor?.doLogin(request: request)
    }
  
    func displaySomething(viewModel: Login.Something.ViewModel){
    //nameTextField.text = viewModel.name
    }
    
    func displayDetail(viewModel: Login.Logged.ViewModel) {
        passField.text = ""
        router?.routeToDetail(segue: nil)
    }
    
    func showAlert(){
        
        let alert = UIAlertController(title: "Aviso", message: "Usuário/Senha incorreto", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadLayoutConfig(){
        self.userView.layer.cornerRadius = 4
        self.userView.layer.borderWidth = 1
        self.userView.layer.borderColor = UIColor(red: 0.86, green: 0.89, blue: 0.93, alpha: 1.00).cgColor
        
        self.passView.layer.cornerRadius = 4
        self.passView.layer.borderWidth = 1
        self.passView.layer.borderColor = UIColor.gray.cgColor
        self.passView.layer.borderColor = UIColor(red: 0.86, green: 0.89, blue: 0.93, alpha: 1.00).cgColor
        
        self.loginBtn.layer.cornerRadius = 4
    }
    
    func lastLogin(){
        guard let lastUser = UserDefaults.standard.string(forKey: CacheKeys.lastLogin.rawValue)
        else {return}
        
        self.userField.text = lastUser
    }
    
}
    
extension String{
    var isValidEmail: Bool {
            NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
        
    var isValidCPFNumber: Bool{
            NSPredicate(format: "SELF MATCHES %@", "[0-9]{11}").evaluate(with: self)
    }
    
    var isValidCPF: Bool{
            NSPredicate(format: "SELF MATCHES %@", "[0-9]{3}.[0-9]{3}.[0-9]{3}-[0-9]{2}").evaluate(with: self)
    }
    
    var isValidPass:Bool{
        NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$").evaluate(with: self)
    }
}
