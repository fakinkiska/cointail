//
//  HomeDateCell.swift.swift
//  CoinTail
//
//  Created by Eugene on 12.06.23.
//

import UIKit
import EasyPeasy


final class HomeDateCell: UICollectionViewCell {
    
    static let id = "HomeDateCell"
    
    let periods: [String] = ["All the time", "Year", "Half year", "3 months", "Month", "Week"]
    
    let dateCV: UICollectionView = {
        let dateLayout: UICollectionViewFlowLayout = {
            var layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 12
            layout.minimumInteritemSpacing = 12
            return layout
        }()

        let cv = UICollectionView(frame: .zero, collectionViewLayout: dateLayout)
        cv.register(DateCVCell.self, forCellWithReuseIdentifier: DateCVCell.id)
        cv.scrollIndicatorInsets = .zero
        cv.backgroundColor = .clear
        
        cv.allowsMultipleSelection = false
        cv.showsHorizontalScrollIndicator = false
        cv.isScrollEnabled = true
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        
        dateCV.delegate = self
        dateCV.dataSource = self
        
        contentView.addSubview(dateCV)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        dateCV.easy.layout(Edges())
    }
    
    // Размер по всей ширине экрана
    static func size() -> CGSize {
        return .init(
            width: UIScreen.main.bounds.width,
            height: 32
        )
    }
}
