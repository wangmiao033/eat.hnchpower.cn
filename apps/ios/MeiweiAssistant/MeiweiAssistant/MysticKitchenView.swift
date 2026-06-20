import SwiftUI
import UIKit

private enum MysticMode: String, CaseIterable, Identifiable {
    case daily, mood, tarot, number, couple, sticks
    var id: String { rawValue }
    var title: String {
        switch self {
        case .daily: "今日食运"; case .mood: "心情开锅"; case .tarot: "塔罗菜牌"
        case .number: "幸运数字"; case .couple: "缘分合锅"; case .sticks: "五味灵签"
        }
    }
    var icon: String {
        switch self {
        case .daily: "sparkles"; case .mood: "circle.lefthalf.filled"; case .tarot: "moon.stars.fill"
        case .number: "number.circle.fill"; case .couple: "infinity"; case .sticks: "wand.and.stars"
        }
    }
    var subtitle: String {
        switch self {
        case .daily: "星座 × 生肖"; case .mood: "情绪 × 火候"; case .tarot: "翻牌 × 菜谱"
        case .number: "1–99"; case .couple: "双人 × 合拍"; case .sticks: "摇一摇"
        }
    }
}

private struct MysticResult: Identifiable {
    let id = UUID()
    let recipe: Recipe
    let score: Int
    let flavor: String
    let ingredient: String
    let message: String
}

struct MysticKitchenView: View {
    @EnvironmentObject private var growth: GrowthStore
    @State private var mode: MysticMode = .tarot
    @State private var mood = "疲惫"
    @State private var number = 27
    @State private var casting = false
    @State private var result: MysticResult?

    private let plum = Color(red: 0.11, green: 0.07, blue: 0.13)
    private let violet = Color(red: 0.48, green: 0.32, blue: 0.76)
    private let gold = Color(red: 0.91, green: 0.75, blue: 0.46)

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                header
                fortuneHero
                modeGrid
                ritualCard
                partyBridge
            }
            .padding(.bottom, 28)
        }
        .background(RadialGradient(colors: [violet.opacity(0.10), AppTheme.canvas], center: .topTrailing, startRadius: 0, endRadius: 360).ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .sheet(item: $result) { item in
            NavigationStack { resultView(item) }
                .presentationDetents([.large])
                .presentationCornerRadius(32)
                .presentationDragIndicator(.visible)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("MYSTIC KITCHEN · 周六").font(.caption2.weight(.heavy)).tracking(1.4).foregroundStyle(violet)
                Text("玄学厨房").font(.system(size: 34, weight: .bold)).tracking(-1.4)
            }
            Spacer()
            Image(systemName: "speaker.wave.2.fill")
                .frame(width: 42, height: 42).background(.white.opacity(0.78), in: Circle())
        }
        .padding(.horizontal, 20).padding(.top, 10)
    }

    private var fortuneHero: some View {
        VStack(spacing: 12) {
            HStack {
                Label("今日食运已更新", systemImage: "sparkles")
                    .font(.caption2.bold()).foregroundStyle(gold)
                    .padding(.horizontal, 11).padding(.vertical, 8)
                    .background(.white.opacity(0.06), in: Capsule())
                Spacer()
                Text("♏ 天蝎 · 🐴 马 ›").font(.caption2).foregroundStyle(.white.opacity(0.48))
            }
            ZStack(alignment: .bottom) {
                ZStack {
                    Circle().stroke(.white.opacity(0.07)).frame(width: 180, height: 180)
                    Circle().stroke(gold.opacity(0.25), style: StrokeStyle(lineWidth: 1, dash: [3,5])).frame(width: 145, height: 145)
                    VStack(spacing: 5) {
                        Text("88").font(.system(size: 34, weight: .bold))
                        Text("今日食运").font(.system(size: 9)).tracking(1.2).foregroundStyle(.white.opacity(0.64))
                    }
                    .frame(width: 98, height: 98)
                    .background(RadialGradient(colors: [Color.purple.opacity(0.76), Color(red: 0.24, green: 0.12, blue: 0.30)], center: .topLeading, startRadius: 0, endRadius: 85), in: Circle())
                    .shadow(color: violet.opacity(0.48), radius: 24)
                }.frame(height: 195)
                VStack(spacing: 4) {
                    Text("宜开火，忌继续纠结").font(.subheadline.bold())
                    Text("今晚的好运藏在一口热锅里").font(.caption2).foregroundStyle(.white.opacity(0.48))
                }
            }
            HStack(spacing: 7) {
                heroStat("幸运味型","酸辣"); heroStat("幸运食材","番茄"); heroStat("最佳开火","19:20")
            }
        }
        .padding(17).foregroundStyle(.white)
        .background(LinearGradient(colors: [plum, Color(red: 0.20, green: 0.10, blue: 0.23)], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 31))
        .shadow(color: plum.opacity(0.24), radius: 30, y: 17)
        .padding(.horizontal, 17)
    }

    private func heroStat(_ label: String, _ value: String) -> some View {
        VStack(spacing: 5) {
            Text(label).font(.system(size: 9)).foregroundStyle(.white.opacity(0.42))
            Text(value).font(.caption.bold()).foregroundStyle(gold)
        }.frame(maxWidth: .infinity).padding(.vertical, 10).background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 16))
    }

    private var modeGrid: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack { Text("今晚玩哪一种？").font(.title3.bold()); Spacer(); Text("每次都落到一道真菜谱").font(.caption2).foregroundStyle(AppTheme.secondary) }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 9), count: 3), spacing: 9) {
                ForEach(MysticMode.allCases) { item in
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) { mode = item }
                    } label: {
                        VStack(alignment: .leading, spacing: 7) {
                            Image(systemName: item.icon).foregroundStyle(mode == item ? gold : violet)
                            Text(item.title).font(.caption.bold())
                            Text(item.subtitle).font(.system(size: 9)).foregroundStyle(mode == item ? .white.opacity(0.45) : AppTheme.secondary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 87, alignment: .leading).padding(11)
                        .foregroundStyle(mode == item ? .white : AppTheme.ink)
                        .background(mode == item ? AnyShapeStyle(LinearGradient(colors: [plum, Color(red: 0.22, green: 0.12, blue: 0.25)], startPoint: .topLeading, endPoint: .bottomTrailing)) : AnyShapeStyle(Color.white), in: RoundedRectangle(cornerRadius: 20))
                    }.buttonStyle(.plain)
                }
            }
        }.padding(.horizontal, 17).padding(.top, 8)
    }

    private var ritualCard: some View {
        VStack(spacing: 11) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(mode.title.uppercased()).font(.caption2.weight(.heavy)).tracking(1.2).foregroundStyle(violet)
                    Text(ritualTitle).font(.title3.bold())
                    Text("娱乐归娱乐，最后会给你一份真正能下锅的菜谱。").font(.caption2).foregroundStyle(AppTheme.secondary)
                }
                Spacer()
                Text(String(format: "%02d", MysticMode.allCases.firstIndex(of: mode)! + 1)).font(.system(size: 30, weight: .black)).foregroundStyle(AppTheme.ink.opacity(0.08))
            }
            ritualVisual.frame(maxWidth: .infinity).frame(height: 185)
                .background(RadialGradient(colors: [violet.opacity(0.11), Color(red: 0.98, green: 0.97, blue: 0.99)], center: .center, startRadius: 0, endRadius: 180), in: RoundedRectangle(cornerRadius: 22))
            Button(action: cast) {
                Label(casting ? "天机读取中…" : actionTitle, systemImage: "wand.and.stars")
                    .frame(maxWidth: .infinity).frame(height: 51)
            }
            .font(.subheadline.bold()).foregroundStyle(.white)
            .background(LinearGradient(colors: [plum, Color(red: 0.23, green: 0.13, blue: 0.26)], startPoint: .leading, endPoint: .trailing), in: RoundedRectangle(cornerRadius: 17))
            .buttonStyle(.plain).disabled(casting)
            Text("玄学内容仅作娱乐；过敏、忌口与营养要求按真实信息优先").font(.system(size: 8)).foregroundStyle(.secondary)
        }
        .padding(17).background(.white, in: RoundedRectangle(cornerRadius: 29))
        .shadow(color: .black.opacity(0.08), radius: 24, y: 12).padding(.horizontal, 17)
    }

    private var ritualTitle: String {
        switch mode {
        case .daily: "读取你今天的食运"; case .mood: "现在是哪种心情？"; case .tarot: "抽一张今晚的菜牌"
        case .number: "选一个脑中数字"; case .couple: "测测你们今晚合哪一锅"; case .sticks: "摇出今晚的五味签"
        }
    }
    private var actionTitle: String {
        switch mode {
        case .daily: "读取今日食运"; case .mood: "用心情开一锅"; case .tarot: "抽一张今晚的菜牌"
        case .number: "用这个数字占一餐"; case .couple: "看看今晚合哪一锅"; case .sticks: "摇出今晚的五味签"
        }
    }

    @ViewBuilder private var ritualVisual: some View {
        switch mode {
        case .tarot:
            ZStack {
                tarotCard.rotationEffect(.degrees(-17)).offset(x: -54, y: 12)
                tarotCard.offset(y: casting ? -12 : 0).zIndex(2)
                tarotCard.rotationEffect(.degrees(17)).offset(x: 54, y: 12)
            }
        case .mood:
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(58)), count: 3), spacing: 13) {
                ForEach([("开心","😊"),("疲惫","😴"),("焦虑","😵‍💫"),("想家","🥺"),("兴奋","🤩"),("平静","😌")], id: \.0) { item in
                    Button { mood = item.0 } label: {
                        Text(item.1).font(.title2).frame(width: 54, height: 54).background(.white, in: Circle())
                            .overlay(Circle().stroke(mood == item.0 ? violet : Color.black.opacity(0.05), lineWidth: mood == item.0 ? 2 : 1))
                    }.buttonStyle(.plain)
                }
            }
        case .number:
            VStack(spacing: 9) {
                Text(String(format: "%02d", number)).font(.system(size: 42, weight: .black)).foregroundStyle(Color(red: 0.27, green: 0.15, blue: 0.33))
                    .frame(width: 124, height: 124).background(AngularGradient(colors: [plum, violet, gold, plum], center: .center), in: Circle()).overlay(Circle().stroke(.white, lineWidth: 8))
                HStack { Button("−"){number=max(1,number-1)}; Button("↻"){number=Int.random(in: 1...99)}; Button("+"){number=min(99,number+1)} }.buttonStyle(.bordered)
            }
        case .daily:
            Image(systemName: "sparkles").font(.system(size: 74)).foregroundStyle(violet)
        case .couple:
            HStack(spacing: 48) {
                Text("我").frame(width: 66, height: 66).background(.white, in: Circle())
                Image(systemName: "heart.fill").foregroundStyle(.pink)
                Text("TA").frame(width: 66, height: 66).background(.white, in: Circle())
            }
        case .sticks:
            Image(systemName: "wand.and.stars").font(.system(size: 72)).foregroundStyle(violet).rotationEffect(.degrees(casting ? 12 : -8))
        }
    }

    private var tarotCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 13).fill(LinearGradient(colors: [plum, Color(red: 0.29, green: 0.15, blue: 0.33)], startPoint: .topLeading, endPoint: .bottomTrailing))
            RoundedRectangle(cornerRadius: 9).stroke(gold.opacity(0.55)).padding(6)
            Text("☾").font(.system(size: 25)).foregroundStyle(gold)
        }.frame(width: 70, height: 119).shadow(color: .black.opacity(0.22), radius: 14, y: 8)
    }

    private var partyBridge: some View {
        NavigationLink { PartyGameView() } label: {
            HStack(spacing: 12) {
                Image(systemName: "die.face.5.fill").foregroundStyle(gold).frame(width: 43, height: 43).background(plum, in: RoundedRectangle(cornerRadius: 15))
                VStack(alignment: .leading, spacing: 4) {
                    Text("算出吃什么，再去饭局分工").font(.caption.bold())
                    Text("接着决定谁做饭、谁洗碗，结果不接受场外申诉。").font(.caption2).foregroundStyle(AppTheme.secondary)
                }
                Spacer(); Image(systemName: "chevron.right").font(.caption.bold())
            }.padding(14).background(AppTheme.sand.opacity(0.72), in: RoundedRectangle(cornerRadius: 22))
        }.buttonStyle(.plain).padding(.horizontal, 17)
    }

    private func cast() {
        guard !casting else { return }
        casting = true
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
            let recipe: Recipe
            switch mode {
            case .daily, .mood: recipe = SampleData.recipes.first(where: {$0.id == "tomato-egg"}) ?? SampleData.recipes[0]
            case .tarot: recipe = SampleData.recipes.first(where: {$0.id == "mapo-tofu"}) ?? SampleData.recipes[0]
            case .number: recipe = SampleData.recipes[number % SampleData.recipes.count]
            case .couple: recipe = SampleData.recipes.first(where: {$0.id == "mushroom-chicken"}) ?? SampleData.recipes[0]
            case .sticks: recipe = SampleData.recipes.randomElement()!
            }
            casting = false
            growth.recordMysticCast()
            result = MysticResult(recipe: recipe, score: recipe.id == "tomato-egg" ? 95 : 92, flavor: recipe.tags.first ?? "家常", ingredient: recipe.ingredients.first?.name ?? "时令食材", message: "今晚宜少纠结，多开火。让一道真正能完成的菜，替今天收个好尾。")
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }

    private func resultView(_ item: MysticResult) -> some View {
        ScrollView {
            VStack(spacing: 13) {
                FoodArtwork(style: item.recipe.artwork).frame(height: 235).clipShape(RoundedRectangle(cornerRadius: 25))
                Text(item.recipe.name).font(.title.bold()).frame(maxWidth: .infinity, alignment: .leading)
                Text("食运 \(item.score) · \(item.flavor) · 幸运食材 \(item.ingredient)").font(.caption).foregroundStyle(AppTheme.secondary).frame(maxWidth: .infinity, alignment: .leading)
                Text(item.message).font(.subheadline).foregroundStyle(AppTheme.secondary).padding(15).background(violet.opacity(0.10), in: RoundedRectangle(cornerRadius: 20))
                VStack(alignment: .leading, spacing: 10) {
                    HStack { Text("今晚料理挑战").font(.headline); Spacer(); Text("完成 +20 烟火值").font(.caption2).foregroundStyle(violet) }
                    ForEach(item.recipe.steps.prefix(3)) { step in HStack(alignment: .top) { Text("\(step.id)").font(.caption.bold()).foregroundStyle(violet); Text(step.text).font(.caption) } }
                }.padding(15).background(.white, in: RoundedRectangle(cornerRadius: 20))
                NavigationLink { RecipeDetailView(recipe: item.recipe) } label: { Text("接受天命 · 开始做饭").frame(maxWidth: .infinity) }.buttonStyle(PrimaryButtonStyle())
                Text("玄学仅供娱乐，菜谱与忌口信息认真负责").font(.caption2).foregroundStyle(AppTheme.secondary)
            }.padding(17)
        }.background(AppTheme.canvas.ignoresSafeArea()).navigationTitle("今晚命定菜").navigationBarTitleDisplayMode(.inline)
    }
}
