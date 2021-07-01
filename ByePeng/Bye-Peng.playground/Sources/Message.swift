import Foundation
import SwiftUI

// MARK: - Views

/// Main view to be displayed by Playground
public struct MainView: View {

    public init() {}

    public var body: some View {
        MessageListView(Message.readMessageJSON()!)
            .frame(width: 300, height: 600, alignment: .center)
    }
}

/// A list view containing all message views, just like a table view
struct MessageListView: View {

    private var messages: [Message]

    init(_ messages: [Message]) {
        self.messages = messages
    }

    var body: some View {
        List(self.messages, id: \.name) { message in
            MessageView(message)
        }
    }
}

/// View for a single message containing a title, a meesgae body, and the auther's name
struct MessageView: View {

    private var message: Message

    init(_ message: Message) {
        self.message = message
    }

    var body: some View {
        VStack(alignment: .leading,
               spacing: 10) {
            Text(self.message.title).bold()
            Text(self.message.body)
            Text(self.message.name).italic()
        }
    }
}

// MARK: - Models

struct Message: Decodable {

    // MARK: - Constants

    private enum Constants {
        static let messageFilename = "messages"
    }

    // MARK: - Properties

    let name: String
    let title: String
    let body: String

    // MARK: - Static Functions

    /// Read message.json and decode the content into an array of `Message`
    /// - Returns: An array of `Message`
    public static func readMessageJSON() -> [Message]? {
        guard let url = Bundle.main.url(forResource: Constants.messageFilename, withExtension: "json") else {
            print("Cannot find \(Constants.messageFilename).json")
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let messages = try decoder.decode([Message].self, from: data)
            print(messages)
            return messages
        } catch {
            print(error)
            return nil
        }
    }
}
