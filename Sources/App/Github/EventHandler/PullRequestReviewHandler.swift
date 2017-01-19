import Himotoki
import SlackKit

class PullRequestReviewHandler: GithubEventHandler {
    
    var name: String {
        return "pull_request_review"
    }
    
    struct PullRequestReviewEvent: GithubEventObject, Decodable {
        
        let action: String
        let body: String
        let pullRequestTitle: String
        let pullRequestNumber: Int
        let pullRequestURL: String
        let reviewerName: String
        let repositoryName: String
        
        static func decode(_ e: Extractor) throws -> PullRequestReviewEvent {
            return try PullRequestReviewEvent(
                action: e <| "action",
                body: e <| ["review", "body"],
                pullRequestTitle: e <| ["pull_request", "title"],
                pullRequestNumber: e <| ["pull_request", "number"],
                pullRequestURL: e <| ["pull_request", "html_url"],
                reviewerName: e <| ["review", "user", "login"],
                repositoryName: e <| ["repository", "full_name"]
            )
        }
    }
    
    func onSubmitted(event: PullRequestReviewEvent) {
        
        let pullRequestName = "#\(event.pullRequestNumber): \(event.pullRequestTitle)"
        let pullRequestLink = "<\(event.pullRequestURL)|\(pullRequestName)>"
        let pretext = "[\(event.repositoryName)] New review by \(event.reviewerName) on pull request \(pullRequestLink)"
        let lgtmInfo = LGTMDetector.detect(from: event.body)
        
        let attachment = Attachment(fallback: pretext,
                                    title: "",
                                    colorHex: AttachmentColor.good.rawValue,
                                    pretext: pretext,
                                    text: lgtmInfo?.otherText ?? event.body,
                                    imageURL: lgtmInfo?.lgtmImageURL)
        
        slackClient.sendMessage(message: "", attachments: [attachment])
    }
}
