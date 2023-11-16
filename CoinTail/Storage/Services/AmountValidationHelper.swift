//
//  AmountValidationHelper.swift
//  CoinTail
//
//  Created by Eugene on 04.10.23.
//

import UIKit


struct AmountValidationHelper {
    // range - размер строки, string - вводимое значение пользователем
    static func isValidInput(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Позволяет удалить символы в строке, если достигнута максимальная длина (8)
        guard !string.isEmpty else { return true }
        
        // Принимаемые значения для текстового поля Amount
        let allowedCharactersSet = CharacterSet(charactersIn: "1234567890.")
        let typedCharacterSet = CharacterSet(charactersIn: string)
        let allowedCharacters = allowedCharactersSet.isSuperset(of: typedCharacterSet)
        
        // Проверка на тип вводимого значения
        guard allowedCharactersSet.isSuperset(of: typedCharacterSet), let textFieldString = textField.text, let range = Range(range, in: textFieldString) else {
            return false
        }
        
        // Заменяет начальные нули в поле на вводимый текст
        if textField.text == "0" {
            textField.text = string
        }
        
        // Все введенные значения пользователем
        let allString = textFieldString.replacingCharacters(in: range, with: string)
        // Проверка на нули в начале строки
        if allString.starts(with: "0") { return false }
        
        // Количество цифр в строке
        let charactersCount = String(textFieldString).count
        
        return maxNumAfterComma(textFieldString: textFieldString)
        && maxDots(textFieldString: textFieldString, string: string)
        && allowedCharacters
        && charactersCount < 8
    }
    
    // Позволяет ставить не более 1 точки
    private static func maxDots(textFieldString: String, string: String) -> Bool {
        if string == "." {
            let countDots = textFieldString.components(separatedBy:".").count - 1

            if countDots == 0 {
                return true
            } else if countDots > 0 && string == "." {
                return false
            }
        }

        return true
    }

    // Позволяет ввести не более 2 цифр после точки
    private static func maxNumAfterComma(textFieldString: String) -> Bool {
        let amountFormatter = NumberFormatter()
        amountFormatter.maximumFractionDigits = 2
        amountFormatter.roundingMode = .up

        let floatSplit = textFieldString.split(separator: ".")

        if floatSplit.count > 1 {
            let numAfterComma = floatSplit[1]
            if numAfterComma.count > 1 {
                return false
            }
        }

        return true
    }
}
