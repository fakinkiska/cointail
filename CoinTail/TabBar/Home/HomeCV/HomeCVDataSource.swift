//
//  HomeCVDataSource.swift
//  CoinTail
//
//  Created by Eugene on 22.05.23.
//

import UIKit


extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CategoryIsHiddenDelegate, ArrowTapDelegate, SendCategoryCellDelegate, PushVC {
    
    func categoryIsHidden(isHidden: Bool) {
        categoryIsHidden = isHidden
        homeGlobalCV.reloadData()
    }
    
    func arrowTap(isLeft: Bool) {
        currentStep += isLeft ? 1 : -1
        filterMonths()
    }
    
    func sendCategory(category: Category) {
        categorySort = categorySort == category ? nil : category
                
        filterMonths()
    }
    
    // Переход на контроллер для редактирования операции
    func pushVC(record: Record) {
        self.navigationItem.rightBarButtonItem?.target = nil
                
        let vc = AddOperationVC(operationID: record.id)
        vc.hidesBottomBarWhenPushed = true // Спрятать TabBar
        
        navigationController?.pushViewController(vc, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [self] in
            categorySort = nil
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    // Возвращается id ячейки по секции
    private func cellIdentifier(for indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0:
            return HomeDateCell.id
        case 1:
            return HomeCategoryCell.id
        case 2:
            return HomeOperationCell.id
        default:
            fatalError("no section")
        }
    }

    // Заполнение ячеек по их id.
    // Каждой ячейке соответствует свой массив, данные которого берутся из HomeVC
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch cellIdentifier(for: indexPath) {
        case HomeDateCell.id:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeDateCell.id,
                for: indexPath
            ) as? HomeDateCell else {
                fatalError("Unable to dequeue HomeSelectedDateCell.")
            }
            
            cell.periodDelegate = self
            
            cell.period = period
                        
            return cell
        case HomeCategoryCell.id:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeCategoryCell.id,
                for: indexPath
            ) as? HomeCategoryCell else { fatalError("Unable to dequeue HomeCategoryCell.")
            }
            
            let records = Records.shared.getRecords(for: period, type: homeSegment, step: currentStep, category: categorySort)
            
            cell.categoryisHiddenDelegate = self
            cell.arrowTapDelegate = self
            cell.sendCategoryDelegate = self
            
            cell.chartsUpdate(homeSegment, records: records)
            
            cell.categoriesArrCellData = HomeCategoryCell.packBins(data: categoriesArr).1
            
            cell.amountForPeriodLabel.text = "\(Records.shared.getAmount(for: period, type: homeSegment, step: currentStep, category: categorySort))"
            cell.periodLabel.text = getPeriodLabel(step: currentStep)
            cell.category = categorySort
            
            let rightArrowIsHidden = currentStep == 0 || period == .allTheTime
            let leftArrowIsHidden = lastStep(for: Records.shared.total, category: categorySort) == currentStep || period == .allTheTime
            
            cell.arrowIsHidden(left: leftArrowIsHidden, right: rightArrowIsHidden)
                                    
            return cell
        case HomeOperationCell.id:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeOperationCell.id,
                for: indexPath
            ) as? HomeOperationCell else { fatalError("Unable to dequeue HomeOperationCell.")
            }

            cell.monthSectionsCellData = monthSections
            cell.pushVCDelegate = self

            return cell
        default:
            fatalError("no section")
        }
    }
    
    // Отступы по краям ячеек
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch cellIdentifier(for: IndexPath(row: 0, section: section)) {
        case HomeDateCell.id:
            return .init(top: 0, left: 0, bottom: 16, right: 0)
        case HomeCategoryCell.id:
            return .init(top: 0, left: 0, bottom: 16, right: 0)
        case HomeOperationCell.id:
            return .init(top: 0, left: 0, bottom: 0, right: 0)
        default:
            fatalError("no section")
        }
    }
    
    // Динамические размеры ячеек
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch cellIdentifier(for: indexPath) {
        case HomeDateCell.id:
            return HomeDateCell.size()
        case HomeCategoryCell.id:
            return HomeCategoryCell.size(categoryIsHidden: categoryIsHidden, data: HomeCategoryCell.packBins(data: categoriesArr).0)
        case HomeOperationCell.id:
            return HomeOperationCell.size(data: monthSections)
        default:
            fatalError("no section")
        }
    }
    
    private func lastStep(for records: [Record], category: Category? = nil) -> Int {
        var records = records
        
        if let category = category {
            records = records.filter { $0.category == category }
        }
        
        records.sort { l, r in
            return l.date < r.date
        }
        
        guard let date = records.first?.date else { return 0 }

        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        let lastMonth = Calendar.current.component(.month, from: date)
        let lastYear = Calendar.current.component(.year, from: date)
                
        switch period {
        case .allTheTime:
            return 0
        case .year:
            return currentYear - lastYear
        case .quarter:
            let currentQuarter = (Int.norm(hi: currentYear, lo: currentMonth - 1, base: 12).nlo + 1) / 3
            let quarterCount = (currentYear - lastYear) * 4 + currentQuarter
                        
            return quarterCount
        case .month:
            let monthCount = currentMonth - lastMonth + (currentYear - lastYear) * 12
                        
            return monthCount
        }
    }
    
    private func getPeriodLabel(step: Int = 0) -> String {
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
                
        switch period {
        case .allTheTime:
            return "All the time"
        case .year:
            return "Year \(currentYear - step)"
        case .quarter:
            let year = Int.norm(hi: currentYear, lo: currentMonth - 1 - step * 3, base: 12).nhi
            let desiredMonth = Int.norm(hi: currentYear, lo: currentMonth - 1 - step * 3, base: 12).nlo + 1
            let desiredQuarter = desiredMonth / 3
            
            return "Year \(year), Quarter \(desiredQuarter)"
        case .month:
            let year = Int.norm(hi: currentYear, lo: currentMonth - 1 - step, base: 12).nhi
            let desiredMonth = Int.norm(hi: currentYear, lo: currentMonth - 1 - step, base: 12).nlo + 1
            
            return "Year \(year), Month \(desiredMonth)"
        }
    }
    
}