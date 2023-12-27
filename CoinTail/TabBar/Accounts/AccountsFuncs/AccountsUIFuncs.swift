//
//  AccountsUIFuncs.swift
//  CoinTail
//
//  Created by Eugene on 04.09.23.
//

import UIKit
import EasyPeasy


extension AccountsVC {

    func accountsSubviews() {
        self.view.addSubview(customNavBar)
        self.view.addSubview(accountsCV)
        self.view.addSubview(transferButton)
        self.view.addSubview(historyButton)
        
        customNavBar.easy.layout([
            Height(96),
            Top().to(self.view.safeAreaLayoutGuide, .top),
            Left(),
            Right()
        ])
        
        historyButton.easy.layout([
            Height(52),
            Left(16),
            Right(16),
            CenterX(),
            Bottom(24).to(self.view.safeAreaLayoutGuide, .bottom)
        ])
        
        transferButton.easy.layout([
            Height(52),
            Left(16),
            Right(16),
            CenterX(),
            Bottom(16).to(historyButton, .top)
        ])
        
        accountsCV.easy.layout([
            Top().to(customNavBar, .bottom),
            CenterX(),
            Left(16),
            Right(16),
            Bottom(24).to(transferButton, .top)
        ])
    }
    
    func isAccountEmpty() {
        let isEmpty = accounts.isEmpty
        
        accountsImageView.isHidden = !isEmpty
        noAccountsLabel.isHidden = !isEmpty
        accountsDescriptionLabel.isHidden = !isEmpty
        addAccountButton.isHidden = !isEmpty
        emptyDataView.isHidden = !isEmpty
        
        transferButton.isHidden = isEmpty
        historyButton.isHidden = isEmpty
        accountsCV.isHidden = isEmpty
    }
    
}