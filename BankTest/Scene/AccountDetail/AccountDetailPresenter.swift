//
//  AccountDetailPresenter.swift
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

protocol AccountDetailPresentationLogic{
  func presentSomething(response: AccountDetail.Load.Response)
}

class AccountDetailPresenter: AccountDetailPresentationLogic{
  weak var viewController: AccountDetailDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: AccountDetail.Load.Response){
    
    var list = [LancamentoConvert]()
    
    for result in response.statement.statementList!{
        let currencyFormateer = NumberFormatter()
        currencyFormateer.locale = Locale(identifier: "pt-br")
        currencyFormateer.numberStyle = .currency
        let price = currencyFormateer.string(from: NSNumber(value: result.value))!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let showDate = dateFormatter.date(from: result.date)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: showDate!)
        list.append(LancamentoConvert.init(title: result.title, desc: result.desc, date: date, value: price))
    }
    
    
    let viewModel = AccountDetail.Load.ViewModel(statement: list)
    viewController?.displaySomething(viewModel: viewModel)
  }
}
