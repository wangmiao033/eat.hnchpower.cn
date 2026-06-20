import SwiftUI

@main
struct MeiweiAssistantApp: App {
    @StateObject private var growth = GrowthStore()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(growth)
        }
    }
}
