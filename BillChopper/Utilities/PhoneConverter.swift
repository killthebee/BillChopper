import Foundation

class PhoneConverter {
    
    private let formatedIndexToRawForAddition = [
        0: 0,
        1: 0,
        2: 1,
        3: 2,
        4: 3,
        5: 3,
        6: 3,
        7: 4,
        8: 5,
        9: 6,
        10: 6,
        11: 7,
        12: 8,
        13: 8,
        14: 9,
    ]


    private let formatedIndexToRawForDecrease = [
        0: 0,
        1: 0,
        2: 1,
        3: 2,
        4: 2,
        5: 2,
        6: 3,
        7: 4,
        8: 5,
        9: 5,
        10: 6,
        11: 7,
        12: 7,
        13: 8,
        14: 9,
        15: 10,
    ]

    private let formatedIndexToRawForMultiDecrease = [
        0: 0,
        1: 0,
        2: 1,
        3: 2,
        4: 3,
        5: 3,
        6: 3,
        7: 4,
        8: 5,
        9: 6,
        10: 6,
        11: 7,
        12: 8,
        13: 8,
        14: 9,
        15: 10,
    ]
    
    private var oldNumber: String
    public var newNumber: String?
    private var range: NSRange
    private var num: String
    
    init(oldRawNumber: String, range: NSRange, num: String) {
        self.oldNumber = oldRawNumber
        self.range = range
        self.num = num
    }
    
    public func getNewRawNumber() -> String {
        let isAddition = range.length == 0
        let newRawNumber: String
        if isAddition {
            newRawNumber = addNum()
        } else if range.length == 1 {
            newRawNumber = deleteOneNum()
        } else {
            newRawNumber = deleteManyNums()
        }
        
        self.newNumber = formatRawNumber(newRawNumber: newRawNumber)
        return newRawNumber
    }
    
    private func addNum() -> String {
        let rawIndex = formatedIndexToRawForAddition[range.lowerBound]!
        let splitIndex = oldNumber.index(oldNumber.startIndex, offsetBy: rawIndex)
        let leftNumberPart = oldNumber[..<splitIndex]
        let rightNumberPart = oldNumber[splitIndex...]
        var newRawNumber = leftNumberPart + num + rightNumberPart
        if oldNumber.count == 10{
            newRawNumber.popLast()
        }
        return String(newRawNumber)
    }
    
    private func deleteOneNum() -> String {
        let firstRawIndex = formatedIndexToRawForDecrease[range.upperBound]!
        let firstIndex = oldNumber.index(oldNumber.startIndex, offsetBy: firstRawIndex)
        var leftNumberPart = oldNumber[..<firstIndex]
        leftNumberPart.popLast() // kek
        let rightNumberPart = oldNumber[firstIndex...]
        let newRawNumber = leftNumberPart + rightNumberPart
        return String(newRawNumber)
    }
    
    private func deleteManyNums() -> String {
        let firstRawIndex = formatedIndexToRawForMultiDecrease[range.lowerBound]!
        let secondRawIndex = formatedIndexToRawForMultiDecrease[range.upperBound]!
        let firstIndex = oldNumber.index(oldNumber.startIndex, offsetBy: firstRawIndex)
        let secondIndex = oldNumber.index(oldNumber.startIndex, offsetBy: secondRawIndex)
        let leftNumberPart = oldNumber[..<firstIndex]
        let rightNumberPart = oldNumber[secondIndex...]
        let newRawNumber = leftNumberPart + rightNumberPart
        return String(newRawNumber)
    }
}

func formatRawNumber(newRawNumber: String) -> String? {
    if newRawNumber.count == 0 { return nil }
    
    let firstPartIndexOffset = newRawNumber.count > 2 ? 3 : newRawNumber.count
    let firstPartIndex = newRawNumber.index(newRawNumber.startIndex, offsetBy: firstPartIndexOffset)
    var formatedNumber = "(" + newRawNumber[..<firstPartIndex]
    if newRawNumber.count > 2 {
        formatedNumber += ") "
    }
    if newRawNumber.count <= 3 {
        return formatedNumber
    }
    let secondPartIndexOffset = newRawNumber.count > 5 ? 6 : newRawNumber.count
    
    let secondPartIndex = newRawNumber.index(
        newRawNumber.startIndex, offsetBy: secondPartIndexOffset
    )
    formatedNumber += newRawNumber[firstPartIndex..<secondPartIndex]
    
    if formatedNumber.count == 9 {
        formatedNumber += " "
    }
    if newRawNumber.count <= 6 {
        return formatedNumber
    }
    let thirdPartIndexOffset = newRawNumber.count > 7 ? 8 : newRawNumber.count
    
    let thirdPartIndex = newRawNumber.index(
        newRawNumber.startIndex, offsetBy: thirdPartIndexOffset
    )
    formatedNumber += newRawNumber[secondPartIndex..<thirdPartIndex]
    if formatedNumber.count == 12 {
        formatedNumber += " "
    }
    if newRawNumber.count <= 8 {
        return formatedNumber
    }
    let fourthPartIndexOffset = newRawNumber.count > 9 ? 10 : newRawNumber.count
    
    let fourthPartIndex = newRawNumber.index(
        newRawNumber.startIndex, offsetBy: fourthPartIndexOffset
    )
    formatedNumber += newRawNumber[thirdPartIndex..<fourthPartIndex]
    
    return formatedNumber
}

func stripCodeAndPhone(number: String) -> (code: String, phone: String)? {
    if number.count < 11 {
        return nil
    }
    
    let startIndex = number.index(number.startIndex, offsetBy: 0)
    let midIndex = number.index(number.endIndex, offsetBy: -10)
    let endIndex = number.index(number.endIndex, offsetBy: 0)
    
    return (String(number[startIndex..<midIndex]), String(number[midIndex..<endIndex]))
}
