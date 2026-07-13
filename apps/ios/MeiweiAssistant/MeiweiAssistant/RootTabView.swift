import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var growth: GrowthStore
    @State private var selection: AppTab = .today

    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                NavigationStack { TodayView() }
                    .tabItem { Label("今日", systemImage: "house") }.tag(AppTab.today)
                NavigationStack { PartyGameView() }
                    .tabItem { Label("饭局", systemImage: "die.face.5") }.tag(AppTab.party)
                NavigationStack { MysticKitchenView() }
                    .tabItem { Label("玄学", systemImage: "moon.stars") }.tag(AppTab.mystic)
                NavigationStack { LibraryView() }
                    .tabItem { Label("菜谱", systemImage: "book.closed") }.tag(AppTab.library)
                NavigationStack { ProfileView() }
                    .tabItem { Label("我的", systemImage: "person") }.tag(AppTab.profile)
            }
            .tint(AppTheme.ink)
            .preferredColorScheme(.light)

            if let unlock = growth.activeUnlock {
                TitleUnlockOverlay(presentation: unlock) {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.84)) {
                        growth.dismissActiveUnlock()
                    }
                }.zIndex(100)
            }
        }
    }
}
