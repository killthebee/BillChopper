import UIKit


func generateAvater() -> String {
    return "dummy URL"
}


func basicLable() -> UILabel{
    return UILabel()
}


class CustomTextField: UITextField {
    
    public var sidePadding: CGFloat = 10
    public var topPadding: CGFloat = 8

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: bounds.origin.x + self.sidePadding,
            y: bounds.origin.y + self.topPadding,
            width: bounds.size.width - self.sidePadding * 2,
            height: bounds.size.height - self.topPadding * 2
        )
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
}


// TODO: Make a class out of these funcs
// Looks like there are must be bugs bnut I can't find any

let formatedIndexToRawForAddition = [
    0: 0,
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


let formatedIndexToRawForDecrease = [
    0: 0,
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

let formatedIndexToRawForMultiDecrease = [
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


func formatRawNumber(newRawNumber: String) -> String? {
    if newRawNumber.count == 0 { return nil }
    
    let firstPartIndexOffes = newRawNumber.count > 2 ? 3 : newRawNumber.count
    let firstPartIndex = newRawNumber.index(newRawNumber.startIndex, offsetBy: firstPartIndexOffes)
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


func getNewNumberText(from rawNumber: String, range: NSRange, num: String) -> String? {
    
    return formatRawNumber(newRawNumber: rawNumber)
}

func getNewRawNumber(from oldNumber: String, range: NSRange, num: String) -> String {
    let isAddition = range.length == 0
    let newRawNumber: String
    if isAddition {
        newRawNumber = addNum(from: oldNumber, range: range, num: num)
    } else if range.length == 1{
        newRawNumber = deleteOneNum(from: oldNumber, range: range, num: num)
    } else {
        newRawNumber = deleteManyNums(from: oldNumber, range: range, num: num)
    }
    
    return newRawNumber
}


func addNum(from oldNumber: String, range: NSRange, num: String) -> String {
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

func deleteOneNum(from oldNumber: String, range: NSRange, num: String) -> String {
    let firstRawIndex = formatedIndexToRawForDecrease[range.upperBound]!
    let firstIndex = oldNumber.index(oldNumber.startIndex, offsetBy: firstRawIndex)
    var leftNumberPart = oldNumber[..<firstIndex]
    leftNumberPart.popLast() // kek
    let rightNumberPart = oldNumber[firstIndex...]
    var newRawNumber = leftNumberPart + rightNumberPart
    return String(newRawNumber)
}


func deleteManyNums(from oldNumber: String, range: NSRange, num: String) -> String {
    let firstRawIndex = formatedIndexToRawForMultiDecrease[range.lowerBound]!
    let secondRawIndex = formatedIndexToRawForMultiDecrease[range.upperBound]!
    let firstIndex = oldNumber.index(oldNumber.startIndex, offsetBy: firstRawIndex)
    let secondIndex = oldNumber.index(oldNumber.startIndex, offsetBy: secondRawIndex)
    var leftNumberPart = oldNumber[..<firstIndex]
    let rightNumberPart = oldNumber[secondIndex...]
    var newRawNumber = leftNumberPart + rightNumberPart
    return String(newRawNumber)
}
