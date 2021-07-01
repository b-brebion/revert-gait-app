import UIKit
import RealityKit
import ARKit
import Combine

class CustomSphere: Entity, HasModel {
    required init(color: UIColor, radius: Float) {
        super.init()
        self.components[ModelComponent] = ModelComponent(
            mesh: .generateSphere(radius: radius),
            materials: [SimpleMaterial(color: color, isMetallic: false)]
        )
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}

class ViewController: UIViewController, ARSessionDelegate {

    @IBOutlet var arView: ARView!
    
    // The 3D character to display.
    var character: BodyTrackedEntity?
    let characterAnchor = AnchorEntity()
    
    let sphereAnchor = AnchorEntity()
    var jointSpheres = [Entity]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arView.session.delegate = self
        
        // If the iOS device doesn't support body tracking
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }

        // Run a body tracking configration.
        let configuration = ARBodyTrackingConfiguration()
        arView.session.run(configuration)
        
        arView.scene.addAnchor(characterAnchor)
        arView.scene.addAnchor(sphereAnchor)
        
        // Asynchronously load the 3D character.
        var cancellable: AnyCancellable? = nil
        cancellable = Entity.loadBodyTrackedAsync(named: "character/robot").sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: Unable to load model: \(error.localizedDescription)")
                }
                cancellable?.cancel()
        }, receiveValue: { (character: Entity) in
            if let character = character as? BodyTrackedEntity {
                // Scale the character to human size
                character.scale = [1.0, 1.0, 1.0]
                self.character = character
                cancellable?.cancel()
            } else {
                print("Error: Unable to load model as BodyTrackedEntity")
            }
        })
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            
            // Update the position of the character anchor's position.
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            let bodyOrientation = Transform(matrix: bodyAnchor.transform).rotation
            characterAnchor.position = bodyPosition
            characterAnchor.orientation = bodyOrientation
            
            if let character = character, character.jointNames.count == bodyAnchor.skeleton.jointModelTransforms.count {
                if jointSpheres.count == 0 {
                    for i in 0..<bodyAnchor.skeleton.jointModelTransforms.count {
                        let jointName = character.jointName(forPath: character.jointNames[i])
                        if let transform = bodyAnchor.skeleton.modelTransform(for: jointName) {
                            var jointRadius: Float = 0.03
                            var jointColor: UIColor = .green
                            
                            switch jointName.rawValue {
                                case "neck_1_joint", "neck_2_joint", "neck_3_joint", "neck_4_joint", "head_joint", "left_shoulder_1_joint", "right_shoulder_1_joint":
                                    jointRadius *= 0.5
                                case "jaw_joint", "chin_joint", "left_eye_joint", "left_eyeLowerLid_joint", "left_eyeUpperLid_joint", "left_eyeball_joint", "nose_joint", "right_eye_joint", "right_eyeLowerLid_joint", "right_eyeUpperLid_joint", "right_eyeball_joint":
                                    jointRadius *= 0.2
                                    jointColor = .yellow
                                case _ where jointName.rawValue.hasPrefix("spine_"):
                                    jointRadius *= 0.75
                                case "left_hand_joint", "right_hand_joint":
                                    jointRadius *= 1
                                    jointColor = .green
                                case _ where jointName.rawValue.hasPrefix("left_hand") || jointName.rawValue.hasPrefix("right_hand"):
                                    jointRadius *= 0.25
                                    jointColor = .yellow
                                case _ where jointName.rawValue.hasPrefix("left_toes") || jointName.rawValue.hasPrefix("right_toes"):
                                    jointRadius *= 0.5
                                    jointColor = .yellow
                                default:
                                    jointRadius = 0.05
                                    jointColor = .green
                            }
                            
                            let position = bodyPosition + simd_make_float3(transform.columns.3)
                            let newSphere = CustomSphere(color: jointColor, radius: jointRadius)
                            newSphere.transform = Transform(scale: [1, 1, 1], rotation: bodyOrientation, translation: position)
                            sphereAnchor.addChild(newSphere, preservingWorldTransform: true)
                            jointSpheres.append(newSphere)
                        }
                    }
                } else {
                    let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
                    let bodyOrientation = Transform(matrix: bodyAnchor.transform).rotation
                    
                    for i in 0..<jointSpheres.count {
                        let jointName = character.jointName(forPath: character.jointNames[i])
                        if let transform = bodyAnchor.skeleton.modelTransform(for: jointName) {
                            let position = bodyPosition + bodyOrientation.act(simd_make_float3(transform.columns.3))
                            jointSpheres[i].position = position
                            jointSpheres[i].orientation = bodyOrientation
                        }
                    }
                }
            }
        }
    }
}

extension BodyTrackedEntity {
    func jointName(forPath path: String) -> ARSkeleton.JointName {
        let splitPath = path.split(separator: "/")
        return ARSkeleton.JointName(rawValue: String(splitPath[splitPath.count - 1]))
    }
}
