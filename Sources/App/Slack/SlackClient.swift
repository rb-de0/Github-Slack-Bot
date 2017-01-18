import SlackKit

class SlackClient {
    
    private let config: SlackConfig
    private let slackKit: SlackKit
    private weak var slackClient: Client?
    
    init() {
        config = SlackConfig.load()
        slackKit = SlackKit(withAPIToken: config.apiToken)
        slackKit.onClientInitalization = {[weak self] slackClient in
            self?.slackClient = slackClient
            self?.slackClient?.messageEventsDelegate = self
        }
    }
    
    func sendMessage(message: String, attachments: [Attachment] = []) {
        slackClient?.webAPI.sendMessage(channel: config.channel,
                                        text: message,
                                        username: config.botName,
                                        attachments: attachments,
                                        iconURL: config.iconURL,
                                        success: nil,
                                        failure: nil)
    }
}

extension SlackClient: MessageEventsDelegate {
    
    func sent(_ message: Message, client: Client) {}
    
    func received(_ message: Message, client: Client) {}
    
    func changed(_ message: Message, client: Client) {}
    
    func deleted(_ message: Message?, client: Client) {}
}
