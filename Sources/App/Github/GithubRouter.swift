import Foundation
import Kitura
import KituraNet

class GithubRouter {
    
    private var handlers = [String: RequestHandler]()
    
    typealias RequestHandler = (Any) throws -> ()
    
    func add<Handler: GithubEventHandler>(_ eventHandler: Handler) {
        
        let requestHandler: RequestHandler = { json in
            
            do {
                
                let event = try eventHandler.decode(json: json)

                guard let action = GithubEventAction(rawValue: event.action) else {
                    throw GithubError.badRequest
                }
                
                switch action {
                case .created:
                    eventHandler.onCreated(event: event)
                case .submitted:
                    eventHandler.onSubmitted(event: event)
                case .opened:
                    eventHandler.onOpened(event: event)
                }
                
            } catch {
                print(error)
                throw GithubError.badRequest
            }
        }

        handlers[eventHandler.name] = requestHandler
    }
    
    func run(request: RouterRequest) throws {
        
        guard let eventName = request.headers["X-Github-Event"] else {
                
            throw GithubError.badRequest
        }
        
        if eventName == "ping" {
            return
        }
        
        guard let body = try request.readString() else {
            
            throw GithubError.badRequest
        }
        
        guard let bodyData = body.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: bodyData, options: .mutableContainers) else {
                
            throw GithubError.badRequest
        }
        
        try handlers[eventName]?(json)
    }
    
}
