import Foundation
import Kitura
import KituraNet

let slackClient = SlackClient()

DispatchQueue.global().async {
    
    let githubRouter = GithubRouter()
    let router = Router()
    
    githubRouter.add(PullRequestReviewHandler())
    
    router.post("/hook") { request, response, next in
        
        do {
            try githubRouter.run(request: request)
            _ = response.send(status: .OK)
        } catch {
            _ = response.send(status: .badRequest)
        }
        
        next()
    }
    
    Kitura.addHTTPServer(onPort: 8090, with: router)
    
    Kitura.run()
}

DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
    slackClient.sendMessage(message: "hoge")
}

RunLoop.main.run()
