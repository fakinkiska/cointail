//
//  SelectCategoryVC.swift
//  CoinTail
//
//  Created by Eugene on 15.06.23.
//

import UIKit
import EasyPeasy


class SelectCategoryVC: BasicVC {
    
    weak var categoryDelegate: SendСategoryData? // Переменная делегата, связывающая протокол с собой. Передает категорию из таблицы с категориями в текст кнопки
    
    var selectCategoryCV: UICollectionView = {
        let layout: UICollectionViewFlowLayout = {
            var layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 48
            layout.minimumInteritemSpacing = 1
            layout.itemSize = CGSize(width: 70, height: 70)
            return layout
        }()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(SelectCategoryCVCell.self, forCellWithReuseIdentifier: SelectCategoryCVCell.id)
        
        cv.allowsMultipleSelection = false
        cv.showsVerticalScrollIndicator = false
        
        return cv
    }()
        
    let newCategoryButton = UIButton(
        name: "+",
        background: .white,
        textColor: .black
    )
            
    var addOperationVCSegmentType: String?
    var addOperationVCSegment: RecordType {
        RecordType(rawValue: addOperationVCSegmentType ?? "Income") ?? .income
    }
    
    // Получаем тип операции из AddOperationVC для отображения категорий
    public required init(segmentTitle: String) {
        self.addOperationVCSegmentType = segmentTitle
        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select category"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        newCategoryButton.removeTarget(nil, action: nil, for: .allEvents)

        selectCategoryCV.delegate = self // Реагирование на события
        selectCategoryCV.dataSource = self // Здесь подаются данные
        
        self.view.addSubview(newCategoryButton)
        self.view.addSubview(selectCategoryCV)
        
        selectCategoryCV.easy.layout([
            Top(90),
            Bottom(70).to(newCategoryButton, .bottom),
            Left(32),
            Right(32)
        ])
        
        newCategoryButton.easy.layout([
            Bottom(20).to(self.view.safeAreaLayoutGuide, .bottom),
            Right(20).to(self.view.safeAreaLayoutGuide, .right),
            Height(64),
            Width(64)
        ])
            
        newCategoryButton.addTarget(self, action: #selector(addNewCategoryAction), for: .touchUpInside)
    }
    
}