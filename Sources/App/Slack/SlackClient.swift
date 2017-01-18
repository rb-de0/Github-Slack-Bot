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
