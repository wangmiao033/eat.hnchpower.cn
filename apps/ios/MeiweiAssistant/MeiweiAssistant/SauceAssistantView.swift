import SwiftUI

struct SauceAssistantView: View {
    @State private var spicy = 3.0
    @State private var sweet = 2.0
    @State private var sour = 2.0
    @State private var useCase = "拌面"
    @State private var generated = false

    private let useCases = ["拌面", "蘸料", "炒菜", "烧烤", "火锅"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("SAUCE LAB").font(.caption2.weight(.heavy)).tracking(1.3).foregroundStyle(AppTheme.accent)
                    Text("酱料助手").font(.system(size: 34, weight: .bold))
                    Text("把辣、甜、酸和使用场景调成一份你的专属比例。")
                        .font(.subheadline).foregroundStyle(AppTheme.secondary)
                }

                VStack(alignment: .leading, spacing: 17) {
                    flavorSlider("辣度", value: $spicy, symbol: "flame.fill")
                    flavorSlider("甜度", value: $sweet, symbol: "cube.fill")
                    flavorSlider("酸度", value: $sour, symbol: "drop.fill")
                    VStack(alignment: .leading, spacing: 9) {
                        Text("用在哪里").font(.subheadline.bold())
                        FlowLayout(spacing: 8) {
                            ForEach(useCases, id: \.self) { item in
                                Button(item) { useCase = item }
                                    .font(.caption.bold()).padding(.horizontal, 12).padding(.vertical, 9)
                                    .background(useCase == item ? AppTheme.ink : Color.black.opacity(0.05), in: Capsule())
                                    .foregroundStyle(useCase == item ? .white : AppTheme.ink)
                            }.buttonStyle(.plain)
                        }
                    }
                    Button {
                        withAnimation(.snappy) { generated = true }
                    } label: {
                        Label("调出我的酱汁", systemImage: "wand.and.stars").frame(maxWidth: .infinity)
                    }.buttonStyle(PrimaryButtonStyle())
                }.padding(18).meiweiCard()

                if generated {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("香辣酸甜万能汁").font(.title2.bold())
                        Text("适合 · \(useCase)").font(.caption.bold()).foregroundStyle(AppTheme.accent)
                        HStack(spacing: 8) {
                            metric("辣", Int(spicy)); metric("甜", Int(sweet)); metric("酸", Int(sour))
                        }
                        Divider().opacity(0.5)
                        ingredient("生抽", "2 汤匙")
                        ingredient("香醋", "\(max(1, Int(sour))) 茶匙")
                        ingredient("糖", "\(max(1, Int(sweet))) 茶匙")
                        ingredient("辣椒油", "\(max(1, Int(spicy))) 茶匙")
                        ingredient("蒜末与熟芝麻", "适量")
                        Text("先将糖用少量温水化开，再加入其余调味料搅匀；静置 5 分钟后使用。")
                            .font(.subheadline).foregroundStyle(AppTheme.secondary).lineSpacing(4)
                    }.padding(18).meiweiCard().transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }.padding(18)
        }
        .background(AppTheme.canvas.ignoresSafeArea())
        .navigationTitle("酱料助手").navigationBarTitleDisplayMode(.inline)
    }

    private func flavorSlider(_ title: String, value: Binding<Double>, symbol: String) -> some View {
        VStack(spacing: 8) {
            HStack { Label(title, systemImage: symbol).font(.subheadline.bold()); Spacer(); Text("\(Int(value.wrappedValue)) / 5").font(.caption).foregroundStyle(AppTheme.secondary) }
            Slider(value: value, in: 1...5, step: 1).tint(AppTheme.accent)
        }
    }
    private func metric(_ title: String, _ value: Int) -> some View {
        VStack(spacing: 4) { Text("\(value)").font(.headline); Text(title).font(.caption2).foregroundStyle(AppTheme.secondary) }
            .frame(maxWidth: .infinity).padding(.vertical, 12).background(AppTheme.sand.opacity(0.58), in: RoundedRectangle(cornerRadius: 15))
    }
    private func ingredient(_ name: String, _ amount: String) -> some View {
        HStack { Text(name).font(.subheadline); Spacer(); Text(amount).font(.caption).foregroundStyle(AppTheme.secondary) }
    }
}
