import SwiftUI
@_spi(Experimental) import MapboxMaps

@available(iOS 14.0, *)
struct StandardStyleImportExample: View {
    @State private var lightPreset: StandardLightPreset? = .night
    @State private var theme: StandardTheme? = .default
    @State private var showLabels = true
    @State private var panelHeight: CGFloat = 0
    @State private var showRealEstate = true
    @State private var show3DObjects = true
    @State private var selectedPriceLabel: InteractiveFeature?

    var body: some View {
        Map(initialViewport: .camera(center: .init(latitude: 40.72, longitude: -73.99), zoom: 11, pitch: 45)) {
            if showRealEstate {
                /// When real estate is enabled, we import it's style JSON as a separate fragment.
                /// This enables the greater encapsulation and allows to reload the basemap without reloading of the fragment.
                let importId = "real-estate-fragment"
                StyleImport(id: importId, uri: StyleURI(url: styleURL)!)

                /// The contents of the imported style are private. However if it defines the a featureset,
                /// you can add an interaction handler to it.
                /// See `fragment-realestate-NY.json` for more information.
                TapInteraction(.featureset("hotels-price", importId: importId)) { priceLabel, _ in
                    /// Select a price label when it's clicked
                    selectedPriceLabel = priceLabel
                    return true
                }

                TapInteraction { _ in
                    /// When the user taps the map outside of the price labels, deselect the latest selected label.
                    selectedPriceLabel = nil
                    return true
                }

                if let selectedPriceLabel {
                    /// When there's a selected price label, we use it to set a feature state.
                    /// The active state is implemented in `fragment-realestate-NY.json` and changes the label color to red.
                    FeatureState(selectedPriceLabel, state: ["active": true])
                }
            }

            /// Defines a custom layer and source to draw the border line.
            NYNJBorder()
        }
        .mapStyle(.standard(
            theme: theme,
            lightPreset: lightPreset,
            showPointOfInterestLabels: showLabels,
            showTransitLabels: showLabels,
            showPlaceLabels: showLabels,
            showRoadLabels: showLabels,
            show3dObjects: show3DObjects))
        .additionalSafeAreaInsets(.bottom, panelHeight)
        .ignoresSafeArea()
        .safeOverlay(alignment: .bottom) {
            settingsPanel.onChangeOfSize { panelHeight = $0.height }
        }
    }

    @ViewBuilder
    var settingsPanel: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Theme")
                Picker("Theme", selection: $theme) {
                    Text("Default").tag(Optional(StandardTheme.default))
                    Text("Faded").tag(Optional(StandardTheme.faded))
                    Text("Monochrome").tag(Optional(StandardTheme.monochrome))
                }.pickerStyle(.segmented)
            }
            HStack {
                Text("Light")
                Picker("Light preset", selection: $lightPreset) {
                    Text("Dawn").tag(Optional(StandardLightPreset.dawn))
                    Text("Day").tag(Optional(StandardLightPreset.day))
                    Text("Dusk").tag(Optional(StandardLightPreset.dusk))
                    Text("Night").tag(Optional(StandardLightPreset.night))
                    Text("None").tag(Optional<StandardLightPreset>.none)
                }.pickerStyle(.segmented)
            }
            Toggle("Labels", isOn: $showLabels)
            Toggle("Show Real Estate", isOn: $showRealEstate)
            Toggle("Show 3D Objects", isOn: $show3DObjects)
        }
        .padding(10)
        .floating(RoundedRectangle(cornerRadius: 10))
        .limitPaneWidth()
    }
}

@available(iOS 13.0, *)
private struct NYNJBorder: MapContent {
    var body: some MapContent {
        GeoJSONSource(id: "border")
            .data(.geometry(.lineString(LineString([
                CLLocationCoordinate2D(latitude: 40.913503418907936, longitude: -73.91912400100642),
                CLLocationCoordinate2D(latitude: 40.82943110786286, longitude: -73.9615887363045),
                CLLocationCoordinate2D(latitude: 40.75461056309348, longitude: -74.01409059085539),
                CLLocationCoordinate2D(latitude: 40.69522028220487, longitude: -74.02798814058939),
                CLLocationCoordinate2D(latitude: 40.65188756398558, longitude: -74.05655532615407),
                CLLocationCoordinate2D(latitude: 40.64339339389301, longitude: -74.13916853846217),
            ]))))

        LineLayer(id: "border", source: "border")
            .lineColor(.orange)
            .lineWidth(8)
            .slot(.bottom)
    }
}

private extension InteractiveFeature {
    var price: String? {
        guard case .number(let price) = properties?["price"] else {
            return nil
        }
        return "$ \(price)"
    }
}

private let styleURL = Bundle.main.url(forResource: "fragment-realestate-NY", withExtension: "json")!

@available(iOS 14.0, *)
struct StandardStyleImportExample_Previews: PreviewProvider {
    static var previews: some View {
        StandardStyleImportExample()
    }
}
