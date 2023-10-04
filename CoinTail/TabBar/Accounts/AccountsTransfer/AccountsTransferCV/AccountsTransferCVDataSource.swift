//
//  AccountsTransferCVDataSource.swift
//  CoinTail
//
//  Created by Eugene on 07.09.23.
//

import UIKit


extension AccountsTransferVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accountsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AccountCell.id,
            for: indexPath
        ) as? AccountCell else {
            return UICollectionViewCell()
        }
        
        let accountData: Account = accountsArr[indexPath.row]
        
        cell.amountLabel.text = "\(accountData.startBalance)"
        cell.nameLabel.text = accountData.name
        
        return cell
    }
    
}
