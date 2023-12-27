//
//  AddAccountCVDataSource.swift
//  CoinTail
//
//  Created by Eugene on 31.10.23.
//

import UIKit


extension AddAccountVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    // Заполнение ячеек по их id.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AddAccountCell.id,
            for: indexPath
        ) as? AddAccountCell else {
            return UICollectionViewCell()
        }
        
        cell.addAccountCellDelegate = self
                        
        switch indexPath.row {
        case 0:
            cell.cornerRadiusTop(radius: 12)
            if accountID != nil {
                cell.accountNameTF.text = accountName
            }
            
            cell.menuLabel.isHidden = true
            cell.accountNameTF.isHidden = false
            cell.accountAmountTF.isHidden = true
            cell.currencyLabel.isHidden = true
            cell.chevronImageView.isHidden = true
            cell.onOffToggle.isHidden = true
            cell.isSeparatorLineHidden(false)
        case 1:
            if accountID != nil {
                cell.accountAmountTF.text = accountAmount
            }
            
            cell.menuLabel.isHidden = true
            cell.accountAmountTF.isHidden = false
            cell.accountNameTF.isHidden = true
            cell.currencyLabel.isHidden = true
            cell.chevronImageView.isHidden = true
            cell.onOffToggle.isHidden = true
            cell.isSeparatorLineHidden(false)
        case 2:
            cell.cornerRadiusBottom(radius: 12)
            cell.menuLabel.text = "Currency".localized()
            cell.currencyLabel.text = selectedCurrency
            
            cell.accountNameTF.isHidden = true
            cell.accountAmountTF.isHidden = true
            cell.menuLabel.isHidden = false
            cell.currencyLabel.isHidden = false
            cell.chevronImageView.isHidden = false
            cell.onOffToggle.isHidden = true
            cell.isSeparatorLineHidden(true)
        default:
            return cell
        }
                    
        return cell
    }
    
}