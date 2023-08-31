//
//  Int.swift
//  CoinTail
//
//  Created by Eugene on 19.06.23.
//

import Foundation


extension Int {
    
    // Функция выполняет нормализацию двух целых чисел с заданной базой.
    // Нормализация гарантирует, что значение `lo` остается в диапазоне [0, base-1], одновременно корректируя значение `hi`. Если `lo` отрицательно, оно переносится в положительный диапазон [0, base-1] путем вычитания кратных `base` из `hi`
    // Если `lo` превышает или равно `base`, оно сдвигается обратно в диапазон [0, base-1] путем добавления кратных `base` к `hi`.
    
    //  - hi: Высокая часть значения.
    //  - lo: Низкая часть значения.
    //  - base: Основание для нормализации.
    static func norm(hi: Int, lo: Int, base: Int) -> (nhi: Int, nlo: Int) {
        var hi = hi
        var lo = lo
        
        if lo < 0 {
            let n = (-lo - 1) / base + 1
            hi -= n
            lo += n * base
        }
        if lo >= base {
            let n = lo / base
            hi += n
            lo -= n * base
        }
        
        // Возвращает: Кортеж `(nhi, nlo)` с нормализованными значениями `hi` и `lo`.
        return (hi, lo)
    }
    
}
