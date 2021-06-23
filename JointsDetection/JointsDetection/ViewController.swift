import UIKit
import RealityKit
import ARKit
import Combine

var bodySkeleton: BodySkeleton?
var bodySkeletonAnchor = AnchorEntity()

class BodySkeleton: Entity {
    var joints: [String: Entity] = [:] // jointNames mapped to jointEntities
    
    required init(for bodyAnchor: ARBodyAnchor) {
        super.init()
        
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            var jointRadius: Float = 0.03
            var jointColor: UIColor = .green
            
            switch jointName {
                case "neck_1_joint", "neck_2_joint", "neck_3_joint", "neck_4_joint", "head_joint", "left_shoulder_1_joint", "right_shoulder_1_joint":
                    jointRadius *= 0.5
                case "jaw_joint", "chin_joint", "left_eye_joint", "left_eyeLowerLid_joint", "left_eyeUpperLid_joint", "left_eyeball_joint", "nose_joint", "right_eye_joint", "right_eyeLowerLid_joint", "right_eyeUpperLid_joint", "right_eyeball_joint":
                    jointRadius *= 0.2
                    jointColor = .yellow
                case _ where jointName.hasPrefix("spine_"):
                    jointRadius *= 0.75
                case "left_hand_joint", "right_hand_joint":
                    jointRadius *= 1
                    jointColor = .green
                case _ where jointName.hasPrefix("left_hand") || jointName.hasPrefix("right_hand"):
                    jointRadius *= 0.25
                    jointColor = .yellow
                case _ where jointName.hasPrefix("left_toes") || jointName.hasPrefix("right_toes"):
                    jointRadius *= 0.5
                    jointColor = .yellow
                default:
                    jointRadius = 0.05
                    jointColor = .green
            }
            
            let jointEntity = makeJoint(radius: jointRadius, color: jointColor)
            joints[jointName] = jointEntity
            self.addChild(jointEntity)
        }
        
        self.update(with: bodyAnchor)
    }
    
    required init() {
        fatalError("init() have not been implemented")
    }
    
    func makeJoint(radius: Float, color: UIColor) -> Entity {
        let mesh = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: color, roughness: 0.8, isMetallic: false)
        
        return ModelEntity(mesh: mesh, materials: [material])
    }
    
    func update(with bodyAnchor: ARBodyAnchor) {
        let rootPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            if let jointEntity = joints[jointName], let jointTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: jointName)) {
                let jointOffset = simd_make_float3(jointTransform.columns.3)
                jointEntity.position = rootPosition + jointOffset
                jointEntity.orientation = Transform(matrix: jointTransform).rotation
            }
        }
    }
}

class ViewController: UIViewController, ARSessionDelegate {

    @IBOutlet var arView: ARView!
    
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
        
        arView.scene.addAnchor(bodySkeletonAnchor)
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
            
            if let skeleton = bodySkeleton {
                // Body skeleton already exists, update pose of all joints
                skeleton.update(with: bodyAnchor)
            } else {
                // Seeing body for the first time, create bodySkeleton
                let skeleton = BodySkeleton(for: bodyAnchor)
                bodySkeleton = skeleton
                bodySkeletonAnchor.addChild(skeleton)
            }
        }
    }
}
