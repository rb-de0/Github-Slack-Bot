import Kitura
import KituraNet

let githubRouter = GithubRouter()

githubRouter.add(PullRequestReviewHandler())

let router = Router()

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
