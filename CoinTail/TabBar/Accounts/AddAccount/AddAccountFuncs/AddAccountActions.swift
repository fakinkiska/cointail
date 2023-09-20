//
//  AddAccountActions.swift
//  CoinTail
//
//  Created by Eugene on 04.09.23.
//

import UIKit


extension AddAccountVC {
    
    @objc func saveAccountAction() {
        guard let amountText = accountAmountTF.text,
              let amount = Double(amountText),
              let nameText = accountNameTF.text,
              let currencyText = currencyButton.titleLabel?.text else {
            return
        }
        let isEditing = accountID != nil
        
        accountValidation(amount: amount, name: nameText, isEditingAccount: isEditing) { [weak self] amount, nameText in
            guard let strongSelf = self else { return }
            
            strongSelf.setCurrency(currencyCode: currencyText)
            let currency = strongSelf.currency
            
            let account = Account(
                id: isEditing ? strongSelf.accountID! : Accounts.shared.accountID,
                name: nameText,
                balance: amount,
                currency: currency
            )
            
            if !isEditing {
                Accounts.shared.accountID += 1
            }
            
            strongSelf.saveAccountButton.removeTarget(nil, action: nil, for: .allEvents)

            if let accountID = strongSelf.accountID {
                Accounts.shared.editAccount(for: accountID, replacingAccount: account)
            } else {
                Accounts.shared.addNewAccount(account)
            }
            
            strongSelf.navigationController?.popViewController(animated: true)
        }
    }
    
    // TODO: вынести алерты 
    @objc func removeAccount() {
        guard let id = accountID else { return }
        
        let confirmAction = UIAlertAction(title: "Confirm".localized(), style: .default) { [weak self] _ in
            Accounts.shared.deleteAccount(for: id)
            
            self?.navigationController?.popToRootViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel)
        
        let alertView = UIAlertController(title: "Delete operation".localized(), message: "Are you sure?".localized(), preferredStyle: .alert)
        
        alertView.addAction(confirmAction)
        alertView.addAction(cancelAction)

        self.present(alertView, animated: true)
    }
    
    @objc func changeCurrency() {
        currentIndex = Currencies.shared.getNextIndex(currentIndex: currentIndex)

        currencyButton.setTitle("\(Currencies.shared.currenciesToChoose()[currentIndex])", for: .normal)
    }
    
}
