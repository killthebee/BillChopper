import UIKit

func generateAvater() -> String {
    return "dummy URL"
}

let customGreen: UIColor = UIColor(red: 0.2627, green: 0.5216, blue: 0.3451, alpha: 1.0)

func makeToolbar(barItems: [UIBarButtonItem]) -> UIToolbar {
    let toolbar = UIToolbar()
    toolbar.setItems(barItems, animated: true)
    toolbar.sizeToFit()
    
    return toolbar
}

func makeKeyboardDownButton() -> UIBarButtonItem{
    let menuBtn = UIButton(type: .custom)
    menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
    menuBtn.setImage(UIImage(named:"keyboardDown2"), for: .normal)

    let menuBarItem = UIBarButtonItem(customView: menuBtn)
    let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 30)
    currWidth?.isActive = true
    let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 30)
    currHeight?.isActive = true
    
    return menuBarItem
}

let flexSpace = UIBarButtonItem(
    barButtonSystemItem: .flexibleSpace,target: nil, action: nil
)

//func makeJson(obj: [String: Any]) -> Optional<Data>? {
//    do {
//        let jsonData = try JSONSerialization.data(withJSONObject: obj)
//        return jsonData
//    } catch {
//        print(error)
//    }
//    return nil
//}


func convertEventTypes(type: String) -> Int {
    // hardcode is the right way to write ones code!
    switch type {
    case "trip":
        return 1
    case "purchase":
        return 2
    case "party":
        return 3
    case "other":
        return 4
    default:
        return 4
    }
}

func reverseConvertEventTypes(type: Int16) -> String {
    switch type {
    case 1:
        return "tripIcon"
    case 2:
        return "purchaseIcon"
    case 3:
        return "partyIcon"
    case 4:
        return "otherIcon"
    default:
        return "otherIcon"
    }
}

func convertNumToMonth(_ num: Int) -> String {
    switch num {
    case 1:
        return "jan"
    case 2:
        return "feb"
    case 3:
        return "mar"
    case 4:
        return "apr"
    case 5:
        return "may"
    case 6:
        return "jun"
    case 7:
        return "jul"
    case 8:
        return "aug"
    case 9:
        return "sep"
    case 10:
        return "oct"
    case 11:
        return "nov"
    case 12:
        return "dec"
    default:
        return "jan"
    }
}


func isImageDefault(image: UIImage?) -> Bool {
    // TODO: increase list of default images
    return image == UIImage(named: "HombreDefault1")
}


func calculateSpendAmount(isBorrowed: Bool, _ totalAmount: Int16, _ split: [String:Int8], phone: String) -> Int16 {
    let percent = split[phone] ?? 0
    var splitIsEqual = true
    for (key, value) in split {
        if value != percent {
            splitIsEqual = false
        }
    }
    
    let floatResult: Float!
    if isBorrowed {
        if splitIsEqual {
            floatResult = Float(totalAmount) / Float(split.count)
        } else {
            floatResult = Float(totalAmount) * Float(percent) / Float(100)
        }
    } else {
        if splitIsEqual {
            floatResult = Float(totalAmount) * (Float(split.count - 1) / Float(split.count))
        } else {
            floatResult = Float(totalAmount) * Float(100 - percent) / Float(100)
        }
    }
    
    return Int16(floatResult)
}
