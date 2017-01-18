import Himotoki

protocol GithubEventHandler {
    
    associatedtype Event: GithubEventObject, Decodable
    
    var name: String { get }
    
    func decode(json: Any) throws -> Event
    
    func onCreated(event: Event)
    func onSubmitted(event: Event)
    func onOpened(event: Event)
}

extension GithubEventHandler {
    func onCreated(event: Event) {}
    func onSubmitted(event: Event) {}
    func onOpened(event: Event) {}
}

extension GithubEventHandler {
    
    func decode(json: Any) throws -> Event {
        return try decodeValue(json) as Event
    }
}
