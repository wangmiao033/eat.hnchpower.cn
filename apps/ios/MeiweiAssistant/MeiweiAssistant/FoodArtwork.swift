import SwiftUI

struct FoodArtwork: View {
    let style: ArtworkStyle

    private var background: [Color] {
        switch style {
        case .tomatoEgg: return [Color(red: 0.34, green: 0.18, blue: 0.14), Color(red: 0.70, green: 0.34, blue: 0.24)]
        case .shrimpBroccoli: return [Color(red: 0.25, green: 0.35, blue: 0.25), Color(red: 0.58, green: 0.67, blue: 0.47)]
        case .mushroomChicken: return [Color(red: 0.29, green: 0.22, blue: 0.17), Color(red: 0.66, green: 0.47, blue: 0.34)]
        case .mapoTofu: return [Color(red: 0.45, green: 0.14, blue: 0.13), Color(red: 0.79, green: 0.34, blue: 0.22)]
        case .beefPotato: return [Color(red: 0.23, green: 0.16, blue: 0.14), Color(red: 0.50, green: 0.33, blue: 0.29)]
        case .noodles: return [Color(red: 0.39, green: 0.30, blue: 0.22), Color(red: 0.72, green: 0.60, blue: 0.40)]
        }
    }

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                LinearGradient(colors: background, startPoint: .topLeading, endPoint: .bottomTrailing)
                Circle()
                    .fill(.white.opacity(0.08))
                    .frame(width: size.width * 0.48)
                    .offset(x: -size.width * 0.39, y: -size.height * 0.32)
                Circle()
                    .fill(.black.opacity(0.06))
                    .frame(width: size.width * 0.58)
                    .offset(x: size.width * 0.42, y: size.height * 0.38)

                ZStack {
                    Ellipse().fill(Color(red: 0.93, green: 0.90, blue: 0.84))
                    Ellipse().fill(Color(red: 1.0, green: 0.98, blue: 0.94)).padding(size.width * 0.055)
                    foodPieces(in: size)
                }
                .frame(width: size.width * 0.62, height: size.height * 0.58)
                .shadow(color: .black.opacity(0.24), radius: 18, y: 12)
            }
        }
        .clipped()
    }

    @ViewBuilder
    private func foodPieces(in size: CGSize) -> some View {
        switch style {
        case .tomatoEgg:
            ZStack {
                blob(.red, x: -34, y: -6, rotation: -14)
                blob(.orange, x: 2, y: -23, rotation: 9)
                blob(.red, x: 33, y: -4, rotation: 17)
                blob(.orange, x: -13, y: 27, rotation: -7)
                blob(Color(red: 0.95, green: 0.67, blue: 0.18), x: 31, y: 28, rotation: 12)
                garnish(x: -17, y: -25, rotation: 42)
                garnish(x: 21, y: 2, rotation: 66)
            }
        case .shrimpBroccoli:
            ZStack {
                ForEach(Array([(-32.0, -12.0), (2.0, -23.0), (34.0, -5.0), (-15.0, 25.0), (25.0, 27.0)].enumerated()), id: \.offset) { _, point in
                    Circle().fill(Color(red: 0.31, green: 0.55, blue: 0.29)).frame(width: 44, height: 44).offset(x: point.0, y: point.1)
                }
                Capsule().trim(from: 0.08, to: 0.78).stroke(Color(red: 0.94, green: 0.52, blue: 0.42), style: StrokeStyle(lineWidth: 14, lineCap: .round)).frame(width: 54, height: 38).rotationEffect(.degrees(24)).offset(x: -18, y: 12)
                Capsule().trim(from: 0.08, to: 0.78).stroke(Color(red: 0.94, green: 0.52, blue: 0.42), style: StrokeStyle(lineWidth: 14, lineCap: .round)).frame(width: 54, height: 38).rotationEffect(.degrees(-20)).offset(x: 25, y: -7)
            }
        case .mushroomChicken:
            ZStack {
                blob(Color(red: 0.84, green: 0.62, blue: 0.39), x: -28, y: 2, rotation: -11)
                blob(Color(red: 0.88, green: 0.67, blue: 0.45), x: 14, y: -21, rotation: 12)
                blob(Color(red: 0.82, green: 0.57, blue: 0.35), x: 25, y: 25, rotation: -5)
                mushroom(x: -5, y: 18, rotation: 15)
                mushroom(x: -24, y: -24, rotation: -18)
                garnish(x: 20, y: -19, rotation: -28)
            }
        default:
            ZStack {
                blob(Color(red: 0.79, green: 0.54, blue: 0.29), x: -28, y: -8, rotation: -12)
                blob(Color(red: 0.72, green: 0.38, blue: 0.25), x: 10, y: -20, rotation: 8)
                blob(Color(red: 0.86, green: 0.67, blue: 0.38), x: 27, y: 20, rotation: 18)
                blob(Color(red: 0.62, green: 0.29, blue: 0.20), x: -13, y: 25, rotation: -5)
            }
        }
    }

    private func blob(_ color: Color, x: CGFloat, y: CGFloat, rotation: Double) -> some View {
        Capsule(style: .continuous)
            .fill(color)
            .frame(width: 62, height: 48)
            .rotationEffect(.degrees(rotation))
            .offset(x: x, y: y)
    }

    private func garnish(x: CGFloat, y: CGFloat, rotation: Double) -> some View {
        Capsule().fill(Color(red: 0.27, green: 0.56, blue: 0.29)).frame(width: 5, height: 22).rotationEffect(.degrees(rotation)).offset(x: x, y: y)
    }

    private func mushroom(x: CGFloat, y: CGFloat, rotation: Double) -> some View {
        VStack(spacing: -3) {
            Capsule().fill(Color(red: 0.42, green: 0.29, blue: 0.20)).frame(width: 34, height: 19)
            RoundedRectangle(cornerRadius: 4).fill(Color(red: 0.80, green: 0.70, blue: 0.58)).frame(width: 10, height: 22)
        }
        .rotationEffect(.degrees(rotation))
        .offset(x: x, y: y)
    }
}
