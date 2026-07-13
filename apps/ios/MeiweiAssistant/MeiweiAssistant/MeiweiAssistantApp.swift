import SwiftUI

@main
struct MeiweiAssistantApp: App {
    @StateObject private var growth = GrowthStore()
    @StateObject private var shoppingList = ShoppingListStore()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(growth)
                .environmentObject(shoppingList)
        }
    }
}
