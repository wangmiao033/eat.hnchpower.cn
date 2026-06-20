import SwiftUI

struct TitleHallView: View {
    @EnvironmentObject private var growth: GrowthStore

    private let hiddenColumns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                currentIdentityCard
                qualityLegend
                mainTitleSection
                hiddenTitleSection
            }
            .padding(18)
        }
        .background(AppTheme.canvas.ignoresSafeArea())
        .navigationTitle("称号殿堂")
        .navigationBarTitleDisplayMode(.large)
    }

    private var currentIdentityCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("CURRENT KITCHEN IDENTITY")
                .font(.caption2.weight(.heavy))
                .tracking(1.8)
                .foregroundStyle(.white.opacity(0.45))

            HStack(spacing: 8) {
                Circle()
                    .fill(growth.currentMainTitle.quality.primaryColor)
                    .frame(width: 8, height: 8)
                    .shadow(color: growth.currentMainTitle.quality.primaryColor, radius: 8)
                Text("\(growth.currentMainTitle.quality.rawValue) · \(growth.currentMainTitle.title)")
                    .font(.title2.bold())
            }

            if let hidden = growth.displayedHiddenTitle {
                Label("展示称号 · \(hidden.title)", systemImage: "sparkles")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color(red: 0.95, green: 0.77, blue: 0.49))
                    .padding(.horizontal, 11)
                    .padding(.vertical, 8)
                    .background(.white.opacity(0.08), in: Capsule())
            }

            VStack(spacing: 8) {
                HStack {
                    Text("\(growth.recipeCompletionCount) 道菜").font(.caption.bold())
                    Spacer()
                    if let next = growth.nextMainTitle {
                        Text("下一称号 \(next.title)")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.48))
                    }
                }
                ProgressView(value: growth.mainProgress)
                    .tint(AppTheme.accent)
            }
        }
        .foregroundStyle(.white)
        .padding(20)
        .background(
            LinearGradient(
                colors: [AppTheme.ink, Color(red: 0.18, green: 0.17, blue: 0.15)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 29, style: .continuous)
        )
        .shadow(color: .black.opacity(0.20), radius: 30, y: 16)
    }

    private var qualityLegend: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(TitleQuality.allCases) { quality in
                    HStack(spacing: 6) {
                        Circle().fill(quality.primaryColor).frame(width: 7, height: 7)
                        Text(quality.rawValue).font(.caption2.bold())
                    }
                    .padding(.horizontal, 11)
                    .padding(.vertical, 8)
                    .background(.white, in: Capsule())
                    .overlay(Capsule().stroke(.black.opacity(0.05)))
                }
            }
        }
    }

    private var mainTitleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("主线称号").font(.title3.bold())
                Spacer()
                Text("\(growth.recipeCompletionCount) / 5000 道")
                    .font(.caption2)
                    .foregroundStyle(AppTheme.secondary)
            }

            ForEach(growth.visibleMainTitles()) { definition in
                mainTitleRow(definition)
            }
        }
    }

    private func mainTitleRow(_ definition: MainTitleDefinition) -> some View {
        let isCurrent = definition.id == growth.currentMainTitle.id
        let isUnlocked = growth.recipeCompletionCount >= definition.requiredRecipeCount

        return HStack(spacing: 13) {
            Image(systemName: "sparkles")
                .foregroundStyle(definition.quality.primaryColor)
                .frame(width: 44, height: 44)
                .background(definition.quality.surfaceColor, in: RoundedRectangle(cornerRadius: 15, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text("\(definition.quality.rawValue)品质 · \(definition.requiredRecipeCount) 道菜")
                    .font(.caption2)
                    .foregroundStyle(AppTheme.secondary)
                Text(definition.title).font(.subheadline.bold())
            }

            Spacer()
            Text(isUnlocked ? "已达成" : "还差 \(definition.requiredRecipeCount - growth.recipeCompletionCount)")
                .font(.caption2.bold())
                .foregroundStyle(isCurrent ? AppTheme.accent : AppTheme.secondary)
        }
        .padding(14)
        .background(isCurrent ? Color(red: 0.98, green: 0.94, blue: 0.91) : .white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(isCurrent ? AppTheme.accent.opacity(0.25) : .black.opacity(0.05))
        }
        .opacity(isUnlocked || isCurrent ? 1 : 0.62)
    }

    private var hiddenTitleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("隐藏称号").font(.title3.bold())
                Spacer()
                Text("\(growth.unlockedHiddenTitleIDs.count) / \(TitleCatalog.hidden.count)")
                    .font(.caption2)
                    .foregroundStyle(AppTheme.secondary)
            }

            LazyVGrid(columns: hiddenColumns, spacing: 10) {
                ForEach(TitleCatalog.hidden) { definition in
                    hiddenTitleCard(definition)
                }
            }
        }
    }

    private func hiddenTitleCard(_ definition: HiddenTitleDefinition) -> some View {
        let isUnlocked = growth.unlockedHiddenTitleIDs.contains(definition.id)
        let isEquipped = growth.displayHiddenTitleID == definition.id

        return Button {
            if isUnlocked { growth.equipHiddenTitle(id: definition.id) }
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: isUnlocked ? definition.symbol : "questionmark")
                        .foregroundStyle(isUnlocked ? AppTheme.accent : .secondary)
                        .frame(width: 38, height: 38)
                        .background(Color.black.opacity(0.045), in: RoundedRectangle(cornerRadius: 13, style: .continuous))
                    Spacer()
                    if isEquipped {
                        Text("展示中")
                            .font(.caption2.bold())
                            .foregroundStyle(AppTheme.accent)
                    }
                }

                Text(isUnlocked ? definition.title : "隐藏称号：？？？")
                    .font(.caption.bold())
                    .foregroundStyle(AppTheme.ink)

                Text(isUnlocked ? "\(definition.category) · 点击展示" : definition.hint)
                    .font(.caption2)
                    .foregroundStyle(AppTheme.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, minHeight: 128, alignment: .topLeading)
            .padding(14)
            .background(isUnlocked ? .white : .white.opacity(0.55))
            .clipShape(RoundedRectangle(cornerRadius: 21, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 21, style: .continuous)
                    .stroke(isEquipped ? AppTheme.accent : .black.opacity(0.06), style: StrokeStyle(lineWidth: isEquipped ? 1.5 : 1, dash: isUnlocked ? [] : [5]))
            }
        }
        .buttonStyle(.plain)
        .disabled(!isUnlocked)
    }
}
