import Foundation
import Kitura
import KituraNet

class GithubRouter {
    
    private var handlers = [GithubEvent: RequestHandler]()
    
    typealias RequestHandler = (Any) throws -> ()
    
    func add<Handler: GithubEventHandler>(_ event: GithubEvent, eventHandler: Handler) {
        
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

        handlers[event] = requestHandler
    }
    
    func run(request: RouterRequest) throws {
        
        guard let eventName = request.headers["X-Github-Event"],
            let event = GithubEvent(rawValue: eventName) else {
                
            throw GithubError.badRequest
        }
        
        if case .ping = event {
            return
        }
        
        guard let body = try request.readString() else {
            
            throw GithubError.badRequest
        }
        
        guard let bodyData = body.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: bodyData, options: .mutableContainers) else {
                
            throw GithubError.badRequest
        }
        
        try handlers[event]?(json)
    }
    
}
