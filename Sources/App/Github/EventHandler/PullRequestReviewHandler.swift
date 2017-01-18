import Himotoki

class PullRequestReviewHandler: GithubEventHandler {
    
    var name: String {
        return "pull_request_review"
    }
    
    struct PullRequestReviewEvent: GithubEventObject, Decodable {
        
        let action: String
        let body: String
        let pullRequestNumber: Int
        let pullRequestURL: String
        let reviewUserName: String
        let repositoryName: String
        
        static func decode(_ e: Extractor) throws -> PullRequestReviewEvent {
            return try PullRequestReviewEvent(
                action: e <| "action",
                body: e <| ["review", "body"],
                pullRequestNumber: e <| ["pull_request", "number"],
                pullRequestURL: e <| ["pull_request", "html_url"],
                reviewUserName: e <| ["review", "user", "login"],
                repositoryName: e <| ["repository", "full_name"]
            )
        }
    }
    
    func onSubmitted(event: PullRequestReviewEvent) {
        // some
    }
}
