import Foundation
import CoreImage
import Cocoa
import Vision


var joiner = " "

func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
    let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
            return cgImage
        }
    return nil
}

func recognizeTextHandler(request: VNRequest, error: Error?) {
    guard let observations =
        request.results as? [VNRecognizedTextObservation] else {
            return
        }
    let recognizedStrings = observations.compactMap { observation in
        // Return the string of the top VNRecognizedText instance.
        return observation.topCandidates(1).first?.string
    }

    // Process the recognized strings.
    let joined = recognizedStrings.joined(separator: joiner)
        print(joined)

        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(joined, forType: .string)

}

func detectText(fileName : URL) -> [CIFeature]? {
    if let ciImage = CIImage(contentsOf: fileName){
        guard let img = convertCIImageToCGImage(inputImage: ciImage) else { return nil}

        let requestHandler = VNImageRequestHandler(cgImage: img)

            // Create a new request to recognize text.
            let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
            request.recognitionLanguages = recognitionLanguages


            do {
                // Perform the text-recognition request.
                try requestHandler.perform([request])
            } catch {
                print("Unable to perform the requests: \(error).")
            }
    }
    return nil
}


func captureRegion(destination: NSURL) {
    let destinationPath = destination.path! as String

        let task = Process()
        task.launchPath = "/usr/sbin/screencapture"
        task.arguments = ["-i", "-r", destinationPath]
        task.launch()
        task.waitUntilExit()
}

var recognitionLanguages = ["en-US"]

try captureRegion(destination: NSURL(fileURLWithPath: "/tmp/ocr.png"))

var filePath="/tmp/ocr.png"
let fileManager = FileManager.default

// Check if file exists
if fileManager.fileExists(atPath: filePath) {
    // Delete file
    if let features = detectText(fileName : URL(fileURLWithPath: "/tmp/ocr.png")), !features.isEmpty{}
    try fileManager.removeItem(atPath: filePath)
}

exit(EXIT_SUCCESS)
