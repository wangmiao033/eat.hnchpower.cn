import SwiftUI

struct ShoppingListView: View {
    @EnvironmentObject private var shoppingList: ShoppingListStore
    @State private var showingClearAll = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header

                if shoppingList.items.isEmpty {
                    emptyState
                } else {
                    actionBar

                    ForEach(shoppingList.groupedItems, id: \.category) { group in
                        section(title: group.category, items: group.items)
                    }
                }
            }
            .padding(18)
            .padding(.bottom, 28)
        }
        .background(AppTheme.canvas.ignoresSafeArea())
        .navigationTitle("采购清单")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("清空采购清单？", isPresented: $showingClearAll, titleVisibility: .visible) {
            Button("清空全部", role: .destructive) { shoppingList.clearAll() }
            Button("取消", role: .cancel) { }
        } message: {
            Text("这会删除所有待买和已买食材。")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("SHOPPING LIST")
                        .font(.caption2.weight(.heavy))
                        .foregroundStyle(AppTheme.accent)
                    Text("按菜谱自动算好要买什么")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(AppTheme.ink)
                    Text("从菜谱详情加入后，会自动按人数折算、合并重复食材，买菜时直接勾选。")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondary)
                        .lineSpacing(4)
                }
                Spacer()
                Image(systemName: "cart.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 54, height: 54)
                    .background(AppTheme.accent, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }

            HStack(spacing: 10) {
                summaryPill("\(shoppingList.pendingCount)", "待买")
                summaryPill("\(shoppingList.checkedCount)", "已买")
                summaryPill("\(shoppingList.items.count)", "总项")
            }
        }
        .padding(18)
        .meiweiCard()
    }

    private var emptyState: some View {
        VStack(spacing: 13) {
            Image(systemName: "cart.badge.plus")
                .font(.system(size: 38, weight: .semibold))
                .foregroundStyle(AppTheme.accent)
                .frame(width: 80, height: 80)
                .background(AppTheme.accent.opacity(0.12), in: Circle())
            Text("还没有要买的食材")
                .font(.headline)
            Text("打开一道菜谱，点“加入采购清单”，这里就会生成可勾选的买菜清单。")
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .meiweiCard()
    }

    private var actionBar: some View {
        HStack(spacing: 10) {
            Button {
                shoppingList.clearChecked()
            } label: {
                Label("清除已买", systemImage: "checkmark.circle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(SecondaryButtonStyle())
            .disabled(shoppingList.checkedCount == 0)

            Button(role: .destructive) {
                showingClearAll = true
            } label: {
                Label("清空", systemImage: "trash")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(SecondaryButtonStyle())
        }
    }

    private func section(title: String, items: [ShoppingListItem]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text("\(items.count) 项")
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 6)

            ForEach(items) { item in
                Button {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.85)) {
                        shoppingList.toggle(item)
                    }
                } label: {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundStyle(item.isChecked ? AppTheme.accent : AppTheme.secondary.opacity(0.65))
                            .padding(.top, 2)

                        VStack(alignment: .leading, spacing: 5) {
                            Text(item.name)
                                .font(.subheadline.bold())
                                .foregroundStyle(item.isChecked ? AppTheme.secondary : AppTheme.ink)
                                .strikethrough(item.isChecked, color: AppTheme.secondary)
                            Text(item.recipeNames.joined(separator: "、"))
                                .font(.caption2)
                                .foregroundStyle(AppTheme.secondary)
                                .lineLimit(1)
                        }

                        Spacer(minLength: 12)

                        Text(item.displayAmount)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(item.isChecked ? AppTheme.secondary : AppTheme.accent)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                            .background(AppTheme.sand.opacity(0.72), in: Capsule())
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .buttonStyle(.plain)

                if item.id != items.last?.id {
                    Divider().padding(.leading, 52).opacity(0.45)
                }
            }
        }
        .background(.white, in: RoundedRectangle(cornerRadius: 23, style: .continuous))
    }

    private func summaryPill(_ value: String, _ title: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.bold())
                .foregroundStyle(AppTheme.ink)
            Text(title)
                .font(.caption2)
                .foregroundStyle(AppTheme.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(AppTheme.sand.opacity(0.58), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
