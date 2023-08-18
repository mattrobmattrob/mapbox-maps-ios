import UIKit

/// Shows 2D user location puck.
@_spi(Experimental)
public struct Puck2D: PrimitiveMapContent {
    private var configuration: Puck2DConfiguration
    private var bearing: PuckBearing?

    /// Creates 2D puck.
    public init(bearing: PuckBearing? = nil) {
        self.configuration = .makeDefault(showBearing: bearing != nil)
        self.bearing = bearing
    }

    /// The opacity of the entire location indicator.
    public func opacity(_ opacity: Double) -> Puck2D {
        copyAssigned(self, \.configuration.opacity, opacity)
    }

    /// Image to use as the top of the location indicator.
    public func topImage(_ topImage: UIImage?) -> Puck2D {
        copyAssigned(self, \.configuration.topImage, topImage)
    }

    /// Image to use as the middle of the location indicator.
    public func bearingImage(_ bearingImage: UIImage?) -> Puck2D {
        copyAssigned(self, \.configuration.bearingImage, bearingImage)
    }

    /// Image to use as the background of the location indicator.
    public func shadowImage(_ shadowImage: UIImage?) -> Puck2D {
        copyAssigned(self, \.configuration.shadowImage, shadowImage)
    }

    /// The size of the images, as a scale factor applied to the size of the specified image.
    public func scale(_ scale: Double) -> Puck2D {
        copyAssigned(self, \.configuration.scale, .constant(scale))
    }

    /// The size of the images, as a scale factor applied to the size of the specified image.
    public func scale(_ scale: Expression) -> Puck2D {
        copyAssigned(self, \.configuration.scale, .expression(scale))
    }

    /// Location puck pulsing configuration is pulsing on the map.
    public func pulsing(_ pulsing: Puck2DConfiguration.Pulsing?) -> Puck2D {
        copyAssigned(self, \.configuration.pulsing, pulsing)
    }

    /// Flag determining if the horizontal accuracy ring should be shown around the `Puck`. default value is false
    public func showsAccuracyRing(_ showsAccuracyRing: Bool) -> Puck2D {
        copyAssigned(self, \.configuration.showsAccuracyRing, showsAccuracyRing)
    }
    /// The color of the accuracy ring.
    public func accuracyRingColor(_ accuracyRingColor: UIColor) -> Puck2D {
        copyAssigned(self, \.configuration.accuracyRingColor, accuracyRingColor)
    }
    /// The color of the accuracy ring border.
    public func accuracyRingBorderColor(_ accuracyRingBorderColor: UIColor) -> Puck2D {
        copyAssigned(self, \.configuration.accuracyRingBorderColor, accuracyRingBorderColor)
    }

    func _visit(_ visitor: MapContentVisitor) {
        visitor.locationOptions = LocationOptions(
            puckType: .puck2D(configuration),
            puckBearing: bearing ?? .heading,
            puckBearingEnabled: bearing != nil)
    }
}