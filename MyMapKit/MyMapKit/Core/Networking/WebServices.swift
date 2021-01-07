import Foundation

struct TrackingSession: Codable {
  let code: Int
    let message: String
    let data: InFoWS
}
struct InFoWS: Codable {
    let id: String
    let roomID: Int
}

struct Location: Codable {
  let latitude: Double
  let longitude: Double
}

struct MessageRoomForm: Codable {
  let from: String
  let to: String
}


let host = ip

final class WebServices {
  static let baseURL = "http://\(host)/"
  
  static let createURL = URL(string: baseURL + "create/")!
  static let updateURL = URL(string: baseURL + "update/")!
  static let closeURL = URL(string: baseURL + "close/")!
    // notify
      static func create(
      success: @escaping (TrackingSession) -> Void,
      failure: @escaping (Error) -> Void
      ) {
        let reqURL = URL(string: baseURL + "create/\(String(describing: currentUserID!))")
        var request = URLRequest(url: reqURL!) // createURL
      request.httpMethod = "POST"
      URLSession.shared.objectRequest(with: request, success: success, failure: failure)
    }
    
    // chat
    static func createChatWS(_ from: String, _ to: String,
    success: @escaping (TrackingSession) -> Void,
    failure: @escaping (Error) -> Void
    ) {
        do {
        let reqURL = URL(string: baseURL + "createChatWS/")
        let roomForm = MessageRoomForm(from: from, to: to)
    var request = URLRequest(url: reqURL!) // createURL
    request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(roomForm)
    URLSession.shared.objectRequest(with: request, success: success, failure: failure)
        } catch {
            
        }
  }
  
  static func update(
    _ message: DataMessage,
    for session: TrackingSession,
    completion: @escaping (Bool) -> Void
    ) {
    let url = updateURL.appendingPathComponent(session.data.id)
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    do {
      try request.addJSONBody(message)
    } catch {
      completion(false)
      return
    }
    
    URLSession.shared.dataRequest(
      with: request,
      success: { _ in completion(true) },
      failure: { _ in completion(false) }
    )
  }
  
  static func close(
    _ session: TrackingSession,
    completion: @escaping (Bool) -> Void
    ) {
    let url = closeURL.appendingPathComponent(String(session.data.id))
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    URLSession.shared.dataRequest(
      with: request,
      success: { _ in completion(true) },
      failure: { _ in completion(false) }
    )
  }
}

extension URLRequest {
  mutating func addJSONBody<C: Codable>(_ object: C) throws {
    let encoder = JSONEncoder()
    httpBody = try encoder.encode(object)
    setValue("application/json", forHTTPHeaderField: "Content-Type")
  }
}
