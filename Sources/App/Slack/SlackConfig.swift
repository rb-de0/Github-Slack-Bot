import Foundation
import Himotoki

struct SlackConfig: Decodable {
    
    let apiToken: String
    let channel: String
    
    // optional
    let botName: String?
    let iconURL: String?
    
    static func decode(_ e: Extractor) throws -> SlackConfig {
        
        return try SlackConfig(
            apiToken: e <| "apiToken",
            channel: e <| "channel",
            botName: e <|? "botName",
            iconURL: e <|? "iconURL"
        )
    }
    
    static func load() -> SlackConfig {
        
        let fileManager = FileManager()
        
        guard let projectPath = #file.components(separatedBy: "Sources/App/Slack/SlackConfig").first else {
            fatalError("Illigal Error")
        }
        
        let configFilePath = projectPath + "/Config/config.json"
        
        if fileManager.fileExists(atPath: configFilePath),
            let data = NSData(contentsOfFile: configFilePath) {
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers)
                let config = try decodeValue(jsonObject) as SlackConfig
                return config
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        
        fatalError("Config FilePath Error")
    }
    
}
