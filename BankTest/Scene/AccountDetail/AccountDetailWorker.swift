//
//  AccountDetailWorker.swift
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

class AccountDetailWorker{
  func doGetData(userId: String, completionHandler: @escaping (_ result: Lancamento)-> Void){
    let api = API()
    api.getStatement(userId: userId) { (result) in
        completionHandler(result)
    }
    
  }
}
