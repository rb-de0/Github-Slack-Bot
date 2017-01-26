import Foundation

class LGTMDetector {
    
    class func detect(from body: String) -> (lgtmImageURL: String, otherText: String)? {
        
        let text = body as NSString
        
        let regex = try! NSRegularExpression(pattern: "!\\[LGTM\\]\\(.*\\)", options: .caseInsensitive)
        
        guard let match = regex.matches(in: body, options: [], range: NSRange(location: 0, length: text.length)).first else {
            return nil
        }
        
        let lgtmText = text.substring(with: match.range)
        let otherText = text.replacingCharacters(in: match.range, with: "") + "\nLGTM"
        let urlLength = (lgtmText as NSString).length - 9
        let url = (lgtmText as NSString).substring(with: NSRange(location: 8, length: urlLength))
        
        return (url, otherText)
    }
}
