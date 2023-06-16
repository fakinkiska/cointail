//
//  DateDataSource.swift
//  CoinTail
//
//  Created by Eugene on 12.06.23.
//

import UIKit


extension HomeDateCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return periods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DateCVCell.id,
            for: indexPath
        ) as? DateCVCell else {
            fatalError("Unable to dequeue DateCVCell.")
        }
        
        cell.periodLabel.text = periods[indexPath.row]
        
        return cell
    }
    
    // Отступ слева и справа от экрана
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func scrollToSelectedCell(indexPath: IndexPath) {
        dateCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    // Определение размера ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return DateCVCell.size(data: periods[indexPath.row])
    }
    
}