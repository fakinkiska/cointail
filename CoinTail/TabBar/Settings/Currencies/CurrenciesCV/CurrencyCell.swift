//
//  CurrencyCell.swift
//  CoinTail
//
//  Created by Eugene on 12.09.23.
//

import UIKit
import EasyPeasy


protocol GetCurrencyIndex: AnyObject {
    func sendCurrency(_ currency: Currency)
}

final class CurrencyCell: UICollectionViewCell {
    
    static let id = "CurrencyCell"
    
    weak var currencyDelegate: GetCurrencyIndex?
    
    var currency: Currency?
    
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "arrowColor")
        
        return view
    }()
    
    let currencyNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont(name: "SFProText-Regular", size: 17)
        
        return label
    }()
    
    let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont(name: "SFProText-Regular", size: 17)
        
        return label
    }()
    
    let favouriteButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "checkMark")
        
        return button
    }()
    
    let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(named: "checkMark")
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "checkmark")
        imageView.isHidden = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
                
        addSubview(backView)
        
        backView.addSubview(checkmarkImageView)
        backView.addSubview(favouriteButton)
        backView.addSubview(currencyCodeLabel)
        backView.addSubview(currencyNameLabel)
        backView.addSubview(separatorView)
        
        favouriteButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backView.easy.layout(Edges())
        
        favouriteButton.easy.layout([
            Height(20),
            Width(20),
            Left(16),
            CenterY()
        ])
        
        let currencyCodeWidth = currencyCodeLabel.sizeThatFits(.zero).width
        currencyCodeLabel.easy.layout([
            Left(8).to(favouriteButton, .right),
            Width(currencyCodeWidth),
            CenterY()
        ])
        
        currencyNameLabel.easy.layout([
            Right(8).to(checkmarkImageView, .left),
            Left(8).to(currencyCodeLabel, .right),
            CenterY()
        ])
        
        separatorView.easy.layout([
            Bottom(),
            Right(),
            Left().to(currencyCodeLabel, .left),
            Height(0.5)
        ])
        
        checkmarkImageView.easy.layout([
            Height(20),
            Width(20),
            Right(16),
            CenterY()
        ])
    }
    
    func isFavourite(currency: Currency, array: [Currency]) {
        if Currencies.shared.hasCurrency(currency, array: array) {
            favouriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favouriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    func isSeparatorLineHidden(_ isHidden: Bool) {
        separatorView.isHidden = isHidden
    }
    
    static func size() -> CGSize {
        return .init(
            width: UIScreen.main.bounds.width - 16 - 16,
            height: 44
        )
    }
    
    @objc func favouriteButtonPressed(_ sender: UIButton) {
        guard let currency = currency else { return }
        
        currencyDelegate?.sendCurrency(currency)
    }
    
}
