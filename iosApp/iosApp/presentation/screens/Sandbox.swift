import SwiftUI
import CoreLocation

struct Sandbox: View {

    @State private var uiDto: UIDto = UIDto (altitude: 0.0,
                                             presicionAltitude: 0.0,
                                             latitude: 0.0,
                                             longitude: 0.0,
                                             presicionLocation: 0.0,
                                             floor: 0)
    @State private var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @State private var managerDelegate: LocationDelegate?
    private let locationManager = CLLocationManager()

    // Helper delegate to bridge CLLocationManager callbacks into SwiftUI state
    final class LocationDelegate: NSObject, CLLocationManagerDelegate {
        var onAltitudeUpdate: ((UIDto) -> Void)?

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let last = locations.last else { return }
            
            let dto = UIDto(
                altitude: last.altitude,
                presicionAltitude: last.verticalAccuracy,
                latitude: last.coordinate.latitude,
                longitude: last.coordinate.longitude,
                presicionLocation: last.horizontalAccuracy,
                floor: last.floor?.level ?? 0
            )
            DispatchQueue.main.async { [weak self] in
                self?.onAltitudeUpdate?(dto)
            }
        }

        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            // No-op here; the view manages starting updates. Could be used to react to status changes if desired.
        }
    }

    var body: some View {
        
        
        VStack(alignment: .leading) {
            Text ("Location Demo")
                .font(.largeTitle)
                .padding([.leading], 16)
            Text("Your altitude is")
                .font(.headline)
                .padding([.leading, .top], 16)
            Text("\(uiDto.altitude) meters")
                .font(.title)
                .padding([.leading], 16)
            Text ("Your altitude accuracy is")
                .font(.headline)
                .padding([.leading, .top], 16)
            Text ("\(uiDto.presicionAltitude) meters")
                .font(.title)
                .padding([.leading], 16)
            if (uiDto.presicionAltitude >= 30) {
                Text ("When this value is 30 this is not provided by GPS")
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .padding([.leading], 16)
            }
            Text ("Your location is at")
                .font(.headline)
                .padding([.leading, .top], 16)
            Text ("\(uiDto.latitude) lat \n\(uiDto.longitude) long")
                .font(.title)
                .padding([.leading], 16)
            Text ("Your location accuracy is")
                .font(.headline)
                .multilineTextAlignment(.leading)
                .padding([.leading, .top], 16)
            Text ("\(uiDto.presicionLocation) meters")
                .font(.title)
                .padding([.leading], 16)
            Text ("Your current floor")
                .font(.headline)
                .multilineTextAlignment(.leading)
                .padding([.leading, .top], 16)
            Text ("\(uiDto.floor)")
                .font(.title)
                .padding([.leading], 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        .padding()
        .onAppear {
            // Set up delegate and start receiving updates
            let delegate = LocationDelegate()
            delegate.onAltitudeUpdate = { dto in
                self.uiDto = dto
            }
            self.locationManager.delegate = delegate
            self.managerDelegate = delegate // retain the delegate

            // Request authorization and start updates
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()

            // If a cached location exists, use it immediately
            if let last = self.locationManager.location {
                self.uiDto = UIDto(
                    altitude: last.altitude,
                    presicionAltitude: last.verticalAccuracy,
                    latitude: last.coordinate.latitude,
                    longitude: last.coordinate.longitude,
                    presicionLocation: last.horizontalAccuracy,
                    floor: last.floor?.level ?? 0
                )
            }
        }
        .onDisappear {
            self.locationManager.stopUpdatingLocation()
          }
    }
}


#Preview("Español") {
    Sandbox()
        .environment(\.locale, Locale(identifier: "es"))
}

struct UIDto: Equatable, Hashable, Codable {
    let altitude: Double
    let presicionAltitude: Double
    let latitude: Double
    let longitude: Double
    let presicionLocation: Double
    let floor: Int
}
