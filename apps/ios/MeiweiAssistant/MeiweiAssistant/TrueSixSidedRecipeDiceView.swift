import SwiftUI
import SceneKit
import UIKit
import simd

/// A true D6 for “美味助手”.
///
/// Geometry rules:
/// - One rounded solid mesh, not six flat cards.
/// - Six physical faces with actual recessed pip cavities.
/// - Opposite pairs are 1–6, 2–5 and 3–4.
/// - Neutral orientation shows 5 on top, 3 in front and 6 on the right.
struct TrueSixSidedRecipeDiceView: UIViewRepresentable {
    let targetValue: Int
    let rollToken: Int
    var onTap: () -> Void
    var onRollComplete: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onTap: onTap, onRollComplete: onRollComplete)
    }

    func makeUIView(context: Context) -> SCNView {
        context.coordinator.makeSceneView()
    }

    func updateUIView(_ view: SCNView, context: Context) {
        context.coordinator.onTap = onTap
        context.coordinator.onRollComplete = onRollComplete

        guard context.coordinator.lastRollToken != rollToken else { return }
        context.coordinator.lastRollToken = rollToken
        context.coordinator.roll(to: targetValue)
    }

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var onTap: () -> Void
        var onRollComplete: () -> Void
        var lastRollToken = 0

        private let scene = SCNScene()
        private let die = SCNNode()
        private weak var sceneView: SCNView?
        private var isRolling = false
        private var panStartOrientation = simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0))

        init(onTap: @escaping () -> Void, onRollComplete: @escaping () -> Void) {
            self.onTap = onTap
            self.onRollComplete = onRollComplete
        }

        func makeSceneView() -> SCNView {
            configureScene()

            let view = SCNView(frame: .zero)
            view.scene = scene
            view.backgroundColor = .clear
            view.isOpaque = false
            view.antialiasingMode = .multisampling4X
            view.preferredFramesPerSecond = 60
            view.rendersContinuously = true
            view.autoenablesDefaultLighting = false
            view.allowsCameraControl = false

            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            view.addGestureRecognizer(tap)

            let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            pan.maximumNumberOfTouches = 1
            pan.delegate = self
            view.addGestureRecognizer(pan)

            sceneView = view
            return view
        }

        private func configureScene() {
            scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
            die.childNodes.forEach { $0.removeFromParentNode() }

            let model = loadTrueD6Model()
            model.name = "TrueD6Mesh"
            model.scale = SCNVector3(1.08, 1.08, 1.08)
            die.addChildNode(model)
            die.position = SCNVector3(0, 0.02, 0)
            die.simdOrientation = landingOrientation(for: 5, yaw: -0.10)
            scene.rootNode.addChildNode(die)

            addCamera()
            addLights()
            addFloor()
        }

        private func loadTrueD6Model() -> SCNNode {
            guard let modelScene = SCNScene(named: "Assets.scnassets/TrueD6.obj") else {
                assertionFailure("Add TrueD6.obj and TrueD6.mtl to Assets.scnassets")
                return proceduralFallback()
            }

            let container = SCNNode()
            for child in modelScene.rootNode.childNodes {
                container.addChildNode(child.clone())
            }

            container.enumerateChildNodes { node, _ in
                node.castsShadow = true
                guard let geometry = node.geometry else { return }

                for material in geometry.materials {
                    material.lightingModel = .physicallyBased
                    material.isDoubleSided = false

                    if material.name?.localizedCaseInsensitiveContains("GlossBlackPips") == true {
                        material.diffuse.contents = UIColor(white: 0.025, alpha: 1)
                        material.roughness.contents = 0.17
                        material.metalness.contents = 0.03
                        material.clearCoat.contents = 0.32
                        material.clearCoatRoughness.contents = 0.14
                    } else {
                        material.diffuse.contents = UIColor(
                            red: 0.95,
                            green: 0.88,
                            blue: 0.71,
                            alpha: 1
                        )
                        material.roughness.contents = 0.24
                        material.metalness.contents = 0.0
                        material.clearCoat.contents = 0.46
                        material.clearCoatRoughness.contents = 0.18
                    }
                }
            }

            return container
        }

        /// Only used when the OBJ asset has not yet been added to the Xcode target.
        /// The production path should always use the supplied solid mesh.
        private func proceduralFallback() -> SCNNode {
            let box = SCNBox(width: 1.64, height: 1.64, length: 1.64, chamferRadius: 0.18)
            box.chamferSegmentCount = 12

            let material = SCNMaterial()
            material.lightingModel = .physicallyBased
            material.diffuse.contents = UIColor(red: 0.95, green: 0.88, blue: 0.71, alpha: 1)
            material.roughness.contents = 0.24
            material.clearCoat.contents = 0.45
            box.materials = [material]

            return SCNNode(geometry: box)
        }

        private func addCamera() {
            let camera = SCNCamera()
            camera.fieldOfView = 34
            camera.zNear = 0.1
            camera.zFar = 50
            camera.wantsHDR = true
            camera.bloomIntensity = 0.08

            let node = SCNNode()
            node.camera = camera
            node.position = SCNVector3(3.0, 2.45, 4.15)
            node.look(at: SCNVector3(0, 0.02, 0))
            scene.rootNode.addChildNode(node)
        }

        private func addLights() {
            let ambient = SCNLight()
            ambient.type = .ambient
            ambient.intensity = 360
            ambient.color = UIColor(red: 0.77, green: 0.70, blue: 0.58, alpha: 1)
            let ambientNode = SCNNode()
            ambientNode.light = ambient
            scene.rootNode.addChildNode(ambientNode)

            let key = SCNLight()
            key.type = .omni
            key.intensity = 1_150
            key.color = UIColor(red: 1.0, green: 0.91, blue: 0.75, alpha: 1)
            key.castsShadow = true
            key.shadowRadius = 16
            key.shadowSampleCount = 32
            key.shadowColor = UIColor.black.withAlphaComponent(0.30)
            let keyNode = SCNNode()
            keyNode.light = key
            keyNode.position = SCNVector3(-3.6, 5.3, 4.4)
            scene.rootNode.addChildNode(keyNode)

            let fill = SCNLight()
            fill.type = .omni
            fill.intensity = 440
            fill.color = UIColor(red: 0.82, green: 0.88, blue: 1.0, alpha: 1)
            let fillNode = SCNNode()
            fillNode.light = fill
            fillNode.position = SCNVector3(4.0, 1.2, 3.0)
            scene.rootNode.addChildNode(fillNode)

            let rim = SCNLight()
            rim.type = .omni
            rim.intensity = 390
            rim.color = UIColor(red: 1.0, green: 0.60, blue: 0.30, alpha: 1)
            let rimNode = SCNNode()
            rimNode.light = rim
            rimNode.position = SCNVector3(-2.5, 0.4, -3.2)
            scene.rootNode.addChildNode(rimNode)
        }

        private func addFloor() {
            let floor = SCNFloor()
            floor.reflectivity = 0.05
            floor.reflectionFalloffEnd = 3.5

            let material = SCNMaterial()
            material.lightingModel = .physicallyBased
            material.diffuse.contents = UIColor(red: 0.90, green: 0.70, blue: 0.36, alpha: 1)
            material.roughness.contents = 0.54
            floor.materials = [material]

            let node = SCNNode(geometry: floor)
            node.position.y = -0.91
            node.castsShadow = false
            scene.rootNode.addChildNode(node)
        }

        @objc private func handleTap() {
            guard !isRolling else { return }
            onTap()
        }

        @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
            guard !isRolling, let view = recognizer.view else { return }

            switch recognizer.state {
            case .began:
                panStartOrientation = die.simdOrientation
            case .changed:
                let translation = recognizer.translation(in: view)
                let yaw = simd_quatf(
                    angle: Float(translation.x) * 0.0105,
                    axis: SIMD3<Float>(0, 1, 0)
                )
                let pitch = simd_quatf(
                    angle: Float(translation.y) * 0.0105,
                    axis: SIMD3<Float>(1, 0, 0)
                )
                die.simdOrientation = simd_normalize(yaw * pitch * panStartOrientation)
            default:
                break
            }
        }

        func roll(to rawValue: Int) {
            guard !isRolling else { return }
            isRolling = true

            let value = min(6, max(1, rawValue))
            let start = die.simdOrientation
            let target = landingOrientation(for: value, yaw: Float.random(in: -0.20 ... 0.20))
            let axis = simd_normalize(
                SIMD3<Float>(
                    Float.random(in: 0.48 ... 0.80),
                    1.0,
                    Float.random(in: 0.32 ... 0.66)
                )
            )

            UIImpactFeedbackGenerator(style: .medium).impactOccurred()

            var settleStart: simd_quatf?
            let duration: TimeInterval = 1.48
            let action = SCNAction.customAction(duration: duration) { [weak self] node, elapsed in
                guard self != nil else { return }
                let t = min(1, max(0, Float(elapsed / duration)))

                if t < 0.73 {
                    let spinAngle = t * (Float.pi * 9.4)
                    let wobbleAngle = sin(t * Float.pi * 5) * 0.16
                    let wobble = simd_quatf(angle: wobbleAngle, axis: SIMD3<Float>(0, 0, 1))
                    let primaryBounce = sin((t / 0.90) * Float.pi) * 0.54
                    let secondaryBounce = abs(sin(t * Float.pi * 6)) * 0.05 * (1 - t)

                    node.simdOrientation = simd_normalize(wobble * simd_quatf(angle: spinAngle, axis: axis) * start)
                    node.position.y = primaryBounce + secondaryBounce
                } else {
                    if settleStart == nil {
                        settleStart = node.presentation.simdOrientation
                    }
                    let local = (t - 0.73) / 0.27
                    let eased = 1 - pow(1 - local, 4)
                    let settleBounce = max(0, sin((1 - local) * Float.pi * 2.2) * 0.045 * (1 - local))

                    node.simdOrientation = simd_slerp(settleStart ?? start, target, eased)
                    node.position.y = settleBounce
                }
            }

            die.runAction(action, forKey: "trueD6.roll") { [weak self] in
                guard let self else { return }
                self.die.simdOrientation = target
                self.die.position.y = 0.02
                self.isRolling = false

                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                self.onRollComplete()
            }
        }

        /// Face layout in the supplied model:
        /// +Y=5, -Y=2, +Z=3, -Z=4, +X=6, -X=1.
        /// Thus every opposite pair sums to seven.
        private func landingOrientation(for value: Int, yaw: Float) -> simd_quatf {
            let base: simd_quatf

            switch value {
            case 1:
                base = simd_quatf(angle: -.pi / 2, axis: SIMD3<Float>(0, 0, 1))
            case 2:
                base = simd_quatf(angle: .pi, axis: SIMD3<Float>(1, 0, 0))
            case 3:
                base = simd_quatf(angle: -.pi / 2, axis: SIMD3<Float>(1, 0, 0))
            case 4:
                base = simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(1, 0, 0))
            case 6:
                base = simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, 0, 1))
            default: // 5
                base = simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0))
            }

            let heading = simd_quatf(angle: yaw, axis: SIMD3<Float>(0, 1, 0))
            return simd_normalize(heading * base)
        }
    }
}
