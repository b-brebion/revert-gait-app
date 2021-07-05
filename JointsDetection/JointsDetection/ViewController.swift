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
    @IBOutlet weak var recordBtn: UIButton!
    
    var character: BodyTrackedEntity?
    let characterAnchor = AnchorEntity()
    
    let sphereAnchor = AnchorEntity()
    var jointSpheres = [Entity]()
    
    var recordState = false
    let pathDirectory = getDocumentsDirectory()
    var jsonArr = [[String: String]]()
    var jsonDict: [String: String] = [:]
    var recordIndex = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arView.session.delegate = self
        
        // If the iOS device doesn't support body tracking
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }

        // Run a body tracking configration
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
            
            // Update the position/orientation of the character anchor
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            let bodyOrientation = Transform(matrix: bodyAnchor.transform).rotation
            characterAnchor.position = bodyPosition
            characterAnchor.orientation = bodyOrientation
            
            if let character = character, character.jointNames.count == bodyAnchor.skeleton.jointModelTransforms.count {
                if jointSpheres.count == 0 {
                    // If the person is detected for the first time, create all the joints
                    for i in 0..<bodyAnchor.skeleton.jointModelTransforms.count {
                        let jointName = character.jointName(forPath: character.jointNames[i])
                        if let transform = bodyAnchor.skeleton.modelTransform(for: jointName) {
                            var jointRadius: Float = 0.03
                            var jointColor: UIColor = .green
                            
                            // Different appearance of the sphere on the screen depending on the joint
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
                            
                            // Placement, creation and display of the sphere on the screen
                            let position = bodyPosition + simd_make_float3(transform.columns.3)
                            let newSphere = CustomSphere(color: jointColor, radius: jointRadius)
                            newSphere.transform = Transform(scale: [1, 1, 1], rotation: bodyOrientation, translation: position)
                            sphereAnchor.addChild(newSphere, preservingWorldTransform: true)
                            jointSpheres.append(newSphere)
                        }
                    }
                } else {
                    // If the person has already been detected, and the joints need to be updated
                    jsonDict = [:]
                    
                    jsonDict["bodyPosition"] = bodyPosition.debugDescription
                    jsonDict["bodyOrientation"] = bodyOrientation.debugDescription
                    
                    for i in 0..<jointSpheres.count {
                        // Joint-by-joint update
                        let jointName = character.jointName(forPath: character.jointNames[i])
                        if let transform = bodyAnchor.skeleton.modelTransform(for: jointName) {
                            // See: https://developer.apple.com/forums/thread/132787
                            let position = bodyPosition + bodyOrientation.act(simd_make_float3(transform.columns.3))
                            jointSpheres[i].position = position
                            jointSpheres[i].orientation = bodyOrientation
                            
                            jsonDict[jointName.rawValue] = position.description
                        }
                    }
                    
                    // If recording is enabled, add the data of the various joints to the JSON array
                    if recordState {
                        jsonArr.append(jsonDict)
                    }
                }
            }
        }
    }
    
    @IBAction func recordData(_ sender: Any) {
        if recordState {
            // End of recording
            recordBtn.setTitle("Record", for: .normal)
            recordBtn.setTitleColor(UIColor.black, for: .normal)
            recordBtn.backgroundColor = UIColor.white
            
            // Allow the file name to match the date and time of the end of recording
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
            let date = Date()
            let dateString = dateFormatter.string(from: date) + ".json"
            
            try? FileManager().createDirectory(at: pathDirectory, withIntermediateDirectories: true)
            let filePath = pathDirectory.appendingPathComponent(dateString)
            
            // Save the JSON array in a file
            let json = try? JSONEncoder().encode(jsonArr)
            do {
                try json!.write(to: filePath)
            } catch {
                print("Failed to write JSON data: \(error.localizedDescription)")
            }
            
            // Alert pop-up window
            let alert = UIAlertController(title: "Recording completed", message: "A file has been created with the recording data (" + dateString + ")", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            recordState = false
        } else {
            // Start of recording
            recordBtn.setTitle("Stop recording", for: .normal)
            recordBtn.setTitleColor(UIColor.white, for: .normal)
            recordBtn.backgroundColor = UIColor(red: 255/255, green: 100/255, blue: 70/255, alpha: 1.0)

            recordIndex = 0
            recordState = true
        }
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

extension BodyTrackedEntity {
    // Get the joint name from the path
    func jointName(forPath path: String) -> ARSkeleton.JointName {
        let splitPath = path.split(separator: "/")
        return ARSkeleton.JointName(rawValue: String(splitPath[splitPath.count - 1]))
    }
}
