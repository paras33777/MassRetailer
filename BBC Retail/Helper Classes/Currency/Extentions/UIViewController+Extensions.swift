import UIKit

extension UIViewController {
    
    var alertController: UIAlertController? {
        guard let alert = UIApplication.topViewControllerr() as? UIAlertController else { return nil }
        return alert
    }
}
//MARK: DATE EXTENSION
extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    func convertDateFormat(inputDate: String) -> String {

         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

         let oldDate = olDateFormatter.date(from: inputDate)

         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "dd MMM, yyyy || HH:mm:ss"

         return convertDateFormatter.string(from: oldDate!)
    }
    
    func convertDatetoFormat(inputDate: String,formate: String) -> String {

         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

         let oldDate = olDateFormatter.date(from: inputDate)

         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "formate"

         return convertDateFormatter.string(from: oldDate!)
    }
    
    
}
extension UITextField {
//
   
    func isValidEmailAddress() -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z_%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,6}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = self.text.leoSafe() as NSString
            let results = regex.matches(in: self.text.leoSafe(), range: NSRange(location: 0, length: nsString.length))
            if results.count == 0{
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    func isEmptyy() -> Bool {
        return self.text!.trimmingCharacters(in: .whitespacesAndNewlines).count == 0
    }
    func isValidPassword(password: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        debugPrint(passwordRegex)
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
//    func isValidPassword() -> Bool {
//        let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
//        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
//
//        return passwordValidation.evaluate(with: self)
//    }
    
    func isValidGST() -> Bool {
        var returnValue = true
        let gstRegEx = "[0-9]{2}[a-z]{4}([a-z]{1}|[0-9]{1}).[0-9]{3}[a-z]([a-z]|[0-9]){3}"
        do {
            let regex = try NSRegularExpression(pattern: gstRegEx)
            let nsString = self.text.leoSafe() as NSString
            let results = regex.matches(in: self.text.leoSafe(), range: NSRange(location: 0, length: nsString.length))
            if results.count == 0{
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
}

extension Optional where Wrapped == String {
    func leoSafe(defaultValue : String? = "") -> String {
        
        guard let strongSelf = self else {
            return defaultValue!
        }
        
        return strongSelf.isEmpty ? defaultValue! : strongSelf
    }
}
