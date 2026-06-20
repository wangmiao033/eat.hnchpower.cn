import SwiftUI

struct PartyGameView: View {
    @EnvironmentObject private var growth: GrowthStore
    @State private var dieValue = 5
    @State private var targetDieValue = 5
    @State private var rollToken = 0
    @State private var isRolling = false
    @State private var selectedRecipe: Recipe?
    @State private var participants = PartyGameView.initialParticipants()
    @State private var assignments: [(role: String, person: String, symbol: String)] = []
    @State private var isShuffling = false

    private var candidates: [Recipe] {
        (1...6).map { SharedDataStore.shared.recipeForDiceFace($0) }
    }

    private static func initialParticipants() -> [String] {
        let shared = Array(SharedDataStore.shared.defaultPartyParticipantNames.prefix(2))
        return shared.count >= 2 ? shared : ["我", "搭子"]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading, spacing: 6) {
                    Label("TWO DECISIONS, ONE DINNER", systemImage: "person.2.fill")
                        .font(.caption2.weight(.heavy))
                        .tracking(0.8)
                        .foregroundStyle(AppTheme.accent)
                    Text("今晚，开个局")
                        .font(.system(size: 34, weight: .bold))
                    Text("先决定吃什么，再把厨房里的活公平分掉。")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondary)
                }
                .padding(.horizontal, 4)

                diceCard
                roleCard
                finaleCard

                Text("下一步还能这样玩")
                    .font(.title3.bold())
                    .padding(.top, 4)

                HStack(spacing: 10) {
                    miniGame(symbol: "mouth.fill", title: "口味对决", subtitle: "投票找出共同接受的辣度与菜系")
                    miniGame(symbol: "timer", title: "火候接力", subtitle: "每完成一步，把手机传给下一位")
                }
            }
            .padding(18)
        }
        .background(
            RadialGradient(colors: [AppTheme.accent.opacity(0.13), .clear], center: .topTrailing, startRadius: 20, endRadius: 240)
                .background(AppTheme.canvas)
                .ignoresSafeArea()
        )
        .toolbar(.hidden, for: .navigationBar)
    }

    private var diceCard: some View {
        VStack(spacing: 15) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("01 · 食谱骰子")
                        .font(.caption2.weight(.heavy))
                        .tracking(1.2)
                        .foregroundStyle(Color(red: 0.94, green: 0.59, blue: 0.42))
                    Text("把晚餐交给运气").font(.title3.bold())
                    Text("六面实体骰子，对应六道今天适合你的菜。")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.55))
                }
                Spacer()
                Text("01")
                    .font(.system(size: 32, weight: .black))
                    .foregroundStyle(.white.opacity(0.12))
            }

            TrueSixSidedRecipeDiceView(
                targetValue: targetDieValue,
                rollToken: rollToken,
                onTap: rollDice,
                onRollComplete: finishDiceRoll
            )
            .frame(height: 202)
            .accessibilityLabel("一体式六面实体食谱骰子，当前点数 \(dieValue)")
            .accessibilityHint("轻点掷骰子，左右拖动可观察六个面")

            HStack(spacing: 12) {
                Group {
                    if let selectedRecipe {
                        FoodArtwork(style: selectedRecipe.artwork)
                    } else {
                        AppTheme.sand
                    }
                }
                .frame(width: 52, height: 52)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text("骰子选中")
                        .font(.caption2.weight(.heavy))
                        .tracking(1.1)
                        .foregroundStyle(.white.opacity(0.42))
                    Text(selectedRecipe?.name ?? "等待开奖")
                        .font(.subheadline.bold())
                    Text(selectedRecipe.map { "\($0.timeMinutes) 分钟 · \($0.tags.first ?? $0.difficulty)" } ?? "掷一次就有答案")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.55))
                }
                Spacer()
            }
            .padding(12)
            .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 19, style: .continuous))

            Button {
                rollDice()
            } label: {
                Label(isRolling ? "骰子滚动中…" : (selectedRecipe == nil ? "掷出今晚的菜" : "再掷一次"), systemImage: "die.face.5")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PartyLightButtonStyle())
            .disabled(isRolling)
        }
        .foregroundStyle(.white)
        .padding(18)
        .background(
            LinearGradient(colors: [AppTheme.ink, Color(red: 0.20, green: 0.19, blue: 0.17)], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 29, style: .continuous)
        )
        .shadow(color: .black.opacity(0.20), radius: 30, y: 16)
    }

    private var roleCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("02 · 厨房分工")
                        .font(.caption2.weight(.heavy))
                        .tracking(1.2)
                        .foregroundStyle(AppTheme.accent)
                    Text("谁掌勺，谁收尾").font(.title3.bold())
                    Text("两人抽主厨与洗碗；多人自动增加帮厨和采购。")
                        .font(.caption)
                        .foregroundStyle(AppTheme.secondary)
                }
                Spacer()
                Text("02")
                    .font(.system(size: 32, weight: .black))
                    .foregroundStyle(AppTheme.ink.opacity(0.09))
            }

            HStack(spacing: 8) {
                ForEach(participants, id: \.self) { person in
                    Label(person, systemImage: "circle.fill")
                        .font(.caption.bold())
                        .foregroundStyle(AppTheme.ink)
                        .labelStyle(.titleAndIcon)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 9)
                        .background(Color.black.opacity(0.045), in: Capsule())
                }
                if participants.count < 4 {
                    Button {
                        let pool = SharedDataStore.shared.defaultPartyParticipantNames
                        let fallback = ["朋友", "家人", "搭子", "同事"]
                        participants.append(pool[safe: participants.count] ?? fallback[safe: participants.count - 2] ?? "新成员")
                        assignments = []
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 34, height: 34)
                            .background(AppTheme.accent.opacity(0.12), in: Circle())
                    }
                    .buttonStyle(.plain)
                }
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 9) {
                ForEach(Array(roleDefinitions.prefix(participants.count).enumerated()), id: \.offset) { index, role in
                    let person = assignments.indices.contains(index) ? assignments[index].person : "待抽取"
                    VStack(alignment: .leading, spacing: 8) {
                        Text(role.symbol).font(.title3)
                        Text(role.role.uppercased())
                            .font(.caption2.weight(.heavy))
                            .tracking(0.8)
                            .foregroundStyle(AppTheme.secondary)
                        Text(person).font(.headline)
                    }
                    .frame(maxWidth: .infinity, minHeight: 92, alignment: .leading)
                    .padding(13)
                    .background(role.color, in: RoundedRectangle(cornerRadius: 19, style: .continuous))
                    .scaleEffect(isShuffling ? 0.97 : 1)
                }
            }

            Button {
                assignRoles()
            } label: {
                Label(isShuffling ? "正在洗牌…" : (assignments.isEmpty ? "抽签分工" : "不服，再抽一次"), systemImage: "shuffle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(isShuffling)
        }
        .padding(18)
        .background(.white, in: RoundedRectangle(cornerRadius: 29, style: .continuous))
        .shadow(color: .black.opacity(0.07), radius: 24, y: 12)
    }

    private var finaleCard: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 5) {
                Text("结果已定，一起开做").font(.headline)
                Text(selectedRecipe != nil && !assignments.isEmpty ? "\(selectedRecipe?.name ?? "") · 分工完成" : "完成上面两步后进入菜谱")
                    .font(.caption2)
                    .foregroundStyle(AppTheme.secondary)
            }
            Spacer()

            if let selectedRecipe, !assignments.isEmpty {
                NavigationLink("开始做") {
                    RecipeDetailView(recipe: selectedRecipe)
                }
                .font(.caption.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 15)
                .frame(height: 43)
                .background(AppTheme.ink, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            } else {
                Text("尚未完成")
                    .font(.caption.bold())
                    .foregroundStyle(AppTheme.secondary)
                    .padding(.horizontal, 15)
                    .frame(height: 43)
                    .background(Color.black.opacity(0.06), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .padding(17)
        .background(AppTheme.sand.opacity(0.65), in: RoundedRectangle(cornerRadius: 27, style: .continuous))
    }

    private func miniGame(symbol: String, title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: symbol).font(.title3)
            Text(title).font(.caption.bold())
            Text(subtitle).font(.caption2).foregroundStyle(AppTheme.secondary).lineLimit(3)
        }
        .frame(maxWidth: .infinity, minHeight: 92, alignment: .topLeading)
        .padding(14)
        .background(.white.opacity(0.65), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func rollDice() {
        guard !isRolling, candidates.count >= 6 else { return }
        isRolling = true
        targetDieValue = Int.random(in: 1...6)
        rollToken += 1
    }

    private func finishDiceRoll() {
        dieValue = targetDieValue
        selectedRecipe = candidates[targetDieValue - 1]
        isRolling = false
        growth.recordDiceRoll()
    }

    private func assignRoles() {
        isShuffling = true
        assignments = []
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            let shuffled = participants.shuffled()
            assignments = Array(roleDefinitions.prefix(participants.count).enumerated()).map { index, role in
                (role: role.role, person: shuffled[index], symbol: role.symbol)
            }
            isShuffling = false
            growth.recordPartyAssignment()
        }
    }

    private var roleDefinitions: [(role: String, symbol: String, color: Color)] {
        let colors = [
            Color(red: 0.95, green: 0.89, blue: 0.85),
            Color(red: 0.89, green: 0.93, blue: 0.86),
            Color(red: 0.91, green: 0.89, blue: 0.94),
            Color(red: 0.94, green: 0.91, blue: 0.84)
        ]
        let roles = SharedDataStore.shared.partyRoles
        guard !roles.isEmpty else {
            return [
                ("主厨", "🍳", colors[0]),
                ("洗碗", "💧", colors[1]),
                ("帮厨", "🔪", colors[2]),
                ("采购", "🧺", colors[3])
            ]
        }
        return roles.enumerated().map { index, role in
            (role.label, role.icon, colors[safe: index] ?? AppTheme.sand)
        }
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

private struct PartyLightButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.bold())
            .foregroundStyle(AppTheme.ink)
            .frame(height: 50)
            .background(.white, in: RoundedRectangle(cornerRadius: 17, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}
