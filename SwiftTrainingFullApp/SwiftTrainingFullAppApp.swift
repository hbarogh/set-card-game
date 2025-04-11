import SwiftUI

@main
struct SwiftTrainingFullAppApp: App {
    @StateObject var game = EmojiCardGame()
    var body: some Scene {
        WindowGroup {
            StartPageView()
        }
    }
}
