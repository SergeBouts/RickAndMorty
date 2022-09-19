import Accelerate
import CoreImage
import UIKit

extension UIImage {

    static let sharedResizeImageContext = CIContext(options: [.useSoftwareRenderer: false])

    func resizedImage(scale: CGFloat, aspectRatio: CGFloat? = 1.0) -> UIImage? {

        guard let cgImage = self.cgImage else {
            return nil
        }

        let image = CIImage(cgImage: cgImage)

        let filter = CIFilter(name: "CILanczosScaleTransform")
        filter?.setValue(image, forKey: kCIInputImageKey)
        filter?.setValue(scale, forKey: kCIInputScaleKey)
        filter?.setValue(aspectRatio, forKey: kCIInputAspectRatioKey)

        guard let outputCIImage = filter?.outputImage,
              let outputCGImage = UIImage.sharedResizeImageContext.createCGImage(
                outputCIImage,
                from: outputCIImage.extent)
        else {
            return nil
        }

        return UIImage(cgImage: outputCGImage)
    }
}
