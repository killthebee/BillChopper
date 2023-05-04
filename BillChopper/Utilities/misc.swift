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
