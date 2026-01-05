import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

public enum CropDirection {
    case left
    case right
    case top
    case bottom
}

public extension NativeImage {
    /// Adds a radial blur to an image.
    func blurred(_ radius: Double = 15.0) -> NativeImage {
        let context = CIContext()
        let filter = CIFilter.gaussianBlur()
        filter.inputImage = CIImage(image: self)
        filter.radius = Float(radius)
        
        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return self }
        
        return NativeImage(cgImage: cgImage)
    }
    
    /// Adds a pixelated filter an image.
    func pixelate(_ scale: Int = 16) -> NativeImage {
        return self
    }
    
    /// Crops an image from a given direction.
    func crop(from direction: CropDirection, _ fraction: CGFloat = 0.5) -> NativeImage {
        switch direction {
        case .left: return cropFromLeft(fraction)
        case .right: return cropFromRight(fraction)
        case .bottom: return cropFromBottom(fraction)
        case .top: return cropFromTop(fraction)
        }
    }
    
    private func cropFromLeft(_ fraction: CGFloat) -> NativeImage {
        guard fraction > 0.0 && fraction <= 1.0,
              let cgImage = self.cgImage else { return self }
        
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let cropWidth = width * fraction
        
        let cropRect = CGRect(
            x: width - cropWidth,
            y: 0,
            width: cropWidth,
            height: height
        )
        
        guard let croppedCGImage = cgImage.cropping(to: cropRect) else { return self }
        
        return NativeImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
    }
    
    private func cropFromRight(_ fraction: CGFloat) -> NativeImage {
        guard fraction > 0.0 && fraction <= 1.0,
              let cgImage = self.cgImage else { return self }
        
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let cropWidth = width * fraction
        
        let cropRect = CGRect(
            x: 0,
            y: 0,
            width: cropWidth,
            height: height
        )
        
        guard let croppedCGImage = cgImage.cropping(to: cropRect) else { return self }
        
        return NativeImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
    }
    
    private func cropFromBottom(_ fraction: CGFloat) -> NativeImage {
        guard fraction > 0.0 && fraction <= 1.0,
              let cgImage = self.cgImage else { return self }
        
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let cropHeight = height * fraction
        
        let cropRect = CGRect(
            x: 0,
            y: height - cropHeight,
            width: width,
            height: cropHeight
        )
        
        guard let croppedCGImage = cgImage.cropping(to: cropRect) else { return self }
        
        return NativeImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
    }
    
    private func cropFromTop(_ fraction: CGFloat) -> NativeImage {
        guard fraction > 0.0 && fraction <= 1.0,
              let cgImage = self.cgImage else { return self }
        
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let cropHeight = height * fraction
        
        let cropRect = CGRect(
            x: 0,
            y: 0,
            width: width,
            height: cropHeight
        )
        
        guard let croppedCGImage = cgImage.cropping(to: cropRect) else { return self }
        
        return NativeImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
    }
}
