import Foundation

class LGTMDetector {
    
    class func detect(from body: String) -> (lgtmImageURL: String, otherText: String)? {
        
        let regex = try! NSRegularExpression(pattern: "!\\[LGTM\\]\\(.*\\)", options: .caseInsensitive)
        
        guard let match = regex.matches(in: body, options: [], range: NSRange(location: 0, length: body.characters.count)).first else {
            return nil
        }
        
        let start = body.index(body.startIndex, offsetBy: match.range.location)
        let end = body.index(body.startIndex, offsetBy: match.range.length + match.range.location)
        
        let lgtmText = body[start..<end]
        let otherText = body.replacingCharacters(in: start..<end, with: "") + "\nLGTM"
        
        let urlStart = lgtmText.index(lgtmText.startIndex, offsetBy: 8)
        let urlEnd = lgtmText.index(lgtmText.endIndex, offsetBy: -1)
        let url = lgtmText[urlStart..<urlEnd]
        
        return (url, otherText)
    }
}
