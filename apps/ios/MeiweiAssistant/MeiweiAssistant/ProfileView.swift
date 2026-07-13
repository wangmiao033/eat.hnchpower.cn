import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var growth: GrowthStore
    @State private var recommendationTime = Date.now
    @State private var notificationsEnabled = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("成长与偏好")
                        .font(.caption)
                        .foregroundStyle(AppTheme.secondary)
                    Text("我的")
                        .font(.system(size: 34, weight: .bold))
                }

                growthCard

                NavigationLink {
                    TitleHallView()
                } label: {
                    HStack(spacing: 13) {
                        Image(systemName: "trophy.fill")
                            .foregroundStyle(Color(red: 0.94, green: 0.75, blue: 0.42))
                            .frame(width: 48, height: 48)
                            .background(AppTheme.ink, in: RoundedRectangle(cornerRadius: 17, style: .continuous))

                        VStack(alignment: .leading, spacing: 5) {
                            Text("进入称号殿堂")
                                .font(.subheadline.bold())
                                .foregroundStyle(AppTheme.ink)
                            Text("查看主线等级、隐藏线索与品质收藏")
                                .font(.caption2)
                                .foregroundStyle(AppTheme.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption.bold())
                            .foregroundStyle(.tertiary)
                    }
                    .padding(16)
                    .background(AppTheme.sand.opacity(0.58), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                }
                .buttonStyle(.plain)

                recentHonors

                VStack(spacing: 0) {
                    setting("饮食偏好", value: "清淡、少油")
                    Divider().opacity(0.5)
                    setting("常用口味", value: "家常、下饭")
                    Divider().opacity(0.5)
                    setting("采购偏好", value: "按菜谱整理")
                }
                .padding(.horizontal, 16)
                .background(.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))

                VStack(spacing: 0) {
                    Toggle("每日推荐提醒", isOn: $notificationsEnabled)
                        .font(.subheadline)
                        .padding(.vertical, 15)
                    Divider().opacity(0.5)
                    DatePicker("推荐时间", selection: $recommendationTime, displayedComponents: .hourAndMinute)
                        .font(.subheadline)
                        .padding(.vertical, 12)
                }
                .padding(.horizontal, 16)
                .background(.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))

                VStack(spacing: 0) {
                    setting("数据与隐私", value: "")
                    Divider().opacity(0.5)
                    NavigationLink {
                        AISettingsView()
                    } label: {
                        setting("高级设置", value: "AI 服务配置")
                    }
                    .buttonStyle(.plain)
                    Divider().opacity(0.5)
                    setting("关于美味助手", value: "1.0.0")
                }
                .padding(.horizontal, 16)
                .background(.white, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            }
            .padding(18)
        }
        .background(AppTheme.canvas.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }

    private var growthCard: some View {
        VStack(spacing: 17) {
            HStack(spacing: 14) {
                Text("味")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .frame(width: 64, height: 64)
                    .background(
                        LinearGradient(colors: [Color.orange, AppTheme.accent], startPoint: .topLeading, endPoint: .bottomTrailing),
                        in: RoundedRectangle(cornerRadius: 22, style: .continuous)
                    )

                VStack(alignment: .leading, spacing: 6) {
                    Text("当前等级称号")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.48))
                    HStack(spacing: 7) {
                        Circle()
                            .fill(growth.currentMainTitle.quality.primaryColor)
                            .frame(width: 7, height: 7)
                            .shadow(color: growth.currentMainTitle.quality.primaryColor, radius: 8)
                        Text("\(growth.currentMainTitle.quality.rawValue) · \(growth.currentMainTitle.title)")
                            .font(.headline)
                    }
                    if let hidden = growth.displayedHiddenTitle {
                        Label("展示称号 · \(hidden.title)", systemImage: "sparkles")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.70))
                            .padding(.horizontal, 9)
                            .padding(.vertical, 6)
                            .background(.white.opacity(0.09), in: Capsule())
                    }
                }
                Spacer()
            }

            VStack(spacing: 8) {
                HStack {
                    if let next = growth.nextMainTitle {
                        Text("距离 \(next.title) 还差 \(next.requiredRecipeCount - growth.recipeCompletionCount) 道")
                            .font(.caption.bold())
                    } else {
                        Text("已抵达最高称号").font(.caption.bold())
                    }
                    Spacer()
                    Text(growth.nextMainTitle.map { "\(growth.recipeCompletionCount) / \($0.requiredRecipeCount)" } ?? "5000 / 5000")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.45))
                }
                ProgressView(value: growth.mainProgress)
                    .tint(Color(red: 0.95, green: 0.64, blue: 0.36))
            }

            HStack(spacing: 8) {
                growthStat("\(growth.recipeCompletionCount)", label: "完成菜谱")
                growthStat("\(growth.cookingStreakDays)", label: "连续天数")
                growthStat("\(growth.unlockedHiddenTitleIDs.count)", label: "隐藏称号")
            }
        }
        .foregroundStyle(.white)
        .padding(20)
        .background(
            LinearGradient(
                colors: [AppTheme.ink, Color(red: 0.20, green: 0.18, blue: 0.15)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 30, style: .continuous)
        )
        .shadow(color: .black.opacity(0.20), radius: 30, y: 16)
    }

    private var recentHonors: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack {
                Text("最近荣誉").font(.title3.bold())
                Spacer()
                Text("\(growth.unlockedHiddenTitleIDs.count) 个已解锁")
                    .font(.caption2)
                    .foregroundStyle(AppTheme.secondary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(TitleCatalog.hidden.prefix(3)) { title in
                        let unlocked = growth.unlockedHiddenTitleIDs.contains(title.id)
                        VStack(alignment: .leading, spacing: 8) {
                            Image(systemName: unlocked ? title.symbol : "questionmark")
                                .foregroundStyle(unlocked ? AppTheme.accent : .secondary)
                                .frame(width: 36, height: 36)
                                .background(AppTheme.sand.opacity(0.68), in: RoundedRectangle(cornerRadius: 13, style: .continuous))
                            Text(unlocked ? title.title : "隐藏称号")
                                .font(.caption.bold())
                            Text(unlocked ? title.category : title.hint)
                                .font(.caption2)
                                .foregroundStyle(AppTheme.secondary)
                                .lineLimit(2)
                        }
                        .frame(width: 136, height: 118, alignment: .topLeading)
                        .padding(14)
                        .background(.white, in: RoundedRectangle(cornerRadius: 21, style: .continuous))
                    }
                }
            }
        }
    }

    private func growthStat(_ value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.headline)
            Text(label).font(.caption2).foregroundStyle(.white.opacity(0.48))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 11)
        .background(.white.opacity(0.07), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
    }

    private func setting(_ title: String, value: String) -> some View {
        HStack {
            Text(title).font(.subheadline)
            Spacer()
            Text(value).font(.caption).foregroundStyle(AppTheme.secondary)
            Image(systemName: "chevron.right").font(.caption).foregroundStyle(.tertiary)
        }
        .padding(.vertical, 17)
    }
}
