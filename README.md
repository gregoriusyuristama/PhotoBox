# GeoBooth (originally PhotoBox)
Geobooth is an app that has 3 main features :

1. **Location Based Collection**, a feature that enhances conventional collections and albums by adding a location attribute. User only allowed take a photo when their position is in the location region of the collection they've made.
2. **Map View**, the user can also revisit their collection by viewing a map that displays every user's collection that they've created.
3. **Photo Booth**, to give the most exciting photo collection experience. The GeoBooth also provides users with some photo booth filters to give them a personal experience when taking photos.

## Code Breakdown
### Location Based Collection

The first thing I'll explain is how to save a longitude and latitude for an album before I explain how I check the location of the user in the collection region.

So, the user's view when they add the album is like this: 

<img src="https://github.com/gregoriusyuristama/PhotoBox/assets/102383943/16377734-02c3-41f1-9722-25437b7bb3f1" height="400"/>

Users will be prompted to input their album name and can see their location in the mini MapView. After the user creates the album, it will be displayed on the homepage like this: 


<img src="https://github.com/gregoriusyuristama/PhotoBox/assets/102383943/83bac661-a11f-4a89-924d-7746235f23f3" height="400"/>


How do I save the album name and location to CoreData is as follows:

AddAlbumView.swift

```swift
struct AddAlbumView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var locationDataManager = LocationDataManager()
    
    @State private var name = ""
    
    var body: some View {
        Form{
            Section{
                TextField(Prompt.AddAlbum.addAlbumNameHint, text: $name)
                MKMapViewRepresentable(userTrackingMode: .constant(.follow))
                    .environmentObject(MapViewContainer())
                    .frame(height: 300)
                HStack{
                    Spacer()
                    Button(Prompt.AddAlbum.addAlbumActionText){
                        AlbumDataController().addAlbum(name: name, latitude: Double((locationDataManager.locationManager.location?.coordinate.latitude.description)!)!, longitude: Double((locationDataManager.locationManager.location?.coordinate.longitude.description)!)!, context: managedObjContext)
                        dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
}
```

TextField component will capture the text inputted by the user, the MKMapViewRepresentable will display the mini MapView, and the last is the button to save the album name and location to CoreData.

The AlbumDataController class saves it to CoreData as follows:


AlbumDataController.swift

```swift
private func save(context: NSManagedObjectContext){
    do {
        try context.save()
        print("Data Saved!! Woohoo")
    } catch {
        print("Could not save the data...")
    }
}
    
func addAlbum(name: String, latitude: Double, longitude: Double, context: NSManagedObjectContext){
    let album = Album(context: context)
    album.idAlbum = UUID()
    album.albumName = name
    album.latitude = latitude
    album.longitude = longitude
    
    save(context: context)
}
```

The Save function above instructs the app to save it to CoreData. And the addAlbum function above captures the name, latitude, and longitude that have already been captured on the view before. 

Now let's take a look at the AlbumView. The view of location-based collection of GeoBooth is shown as follows: 

<!-- ![simulator_screenshot_A9DD5015-4932-4C55-B033-060EABE276F5](https://github.com/gregoriusyuristama/PhotoBox/assets/102383943/579c2068-51e4-4188-9330-afa844abf960) -->

<img src="https://github.com/gregoriusyuristama/PhotoBox/assets/102383943/579c2068-51e4-4188-9330-afa844abf960" height="400"/>

In the upper right corner there is a camera icon that can only be clicked when the user is within the location region of the collection they've made. If the user is outside the region, the app will display a view like this: 


<img src="https://github.com/gregoriusyuristama/PhotoBox/assets/102383943/8a12b0c6-b51a-4895-82c3-08b17c08b1de" height="400"/>
<img src="https://github.com/gregoriusyuristama/PhotoBox/assets/102383943/999ac8eb-9372-46f7-90eb-a60e450fcf6d" height="400"/>

<!-- ![IMG_1DCC151CEA1E-1](https://github.com/gregoriusyuristama/PhotoBox/assets/102383943/8a12b0c6-b51a-4895-82c3-08b17c08b1de) -->

<!-- ![simulator_screenshot_2CA13444-81FC-4BBF-83C6-7B31B53625C0](https://github.com/gregoriusyuristama/PhotoBox/assets/102383943/999ac8eb-9372-46f7-90eb-a60e450fcf6d) -->

How do I check if the user is in the region of their GeoBooth collection by adding the onAppear and onDisappear modifiers to the view like this: 

AlbumView.swift

```swift
.onAppear{
    Task{
        locationDataManager.shouldStartMonitoring = true
        region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: album!.latitude, longitude: album!.longitude), radius: 150, identifier: album!.idAlbum!.uuidString)
        locationDataManager.startMonitoring(region: region!, identifier: album!.idAlbum!.uuidString)
    }
    
}
.onDisappear{
    Task{
        locationDataManager.shouldStartMonitoring = false
        locationDataManager.stopMonitoring(region: region!)
    }
}
```

And inside the LocationManager class there are three variables that I use to help monitor location

LocationDataManager.swift


```swift
@Published var shouldStartMonitoring = false
@Published var isInRegion = false
    
var regionIdentifierToCheck: String?
```

I will explain it one by one:

1. shouldStartMonitoring when it is set to true, it will call the startUpdatingLocation() method that already made from CLLocationManager. This method will make the device update the current location.

2. isInRegion is a variable that is used to check if the current location of the user is in accordance with collection location region. This variable is modified in the locationManager function that is called when the user enters and exits a given region:


LocationDataManager.swift


```swift
func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    // User has exited from ur regiom
    print("exited from region \(region.identifier)")
    if region.identifier == regionIdentifierToCheck {
        isInRegion = false
        // Perform specific action for this region identifier
    }
}

func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    // User has exited from ur region
    print("entered to region \(region.identifier)")
    if region.identifier == regionIdentifierToCheck {
        isInRegion = true
        // Perform specific action for this region identifier
    }
}
```

3. The regionIdentifierToCheck is used to check whether the user entered the id of a collection region. This is every collection UUID that I've passed on the onAppear modifier of the view.

Also if you want to know about how do I modify the toolbar item based on its location, then by using the onReceive modifier like this: 

AlbumView.swift

```swift
.onReceive(locationDataManager.$isInRegion){ newValue in
    print("new value : \(newValue)")
    isInsideRegion = newValue
    
    guard let circularRegion = region else{
        return
    }
    
    if CLLocation(latitude: (locationDataManager.locationManager.location?.coordinate.latitude)!, longitude: (locationDataManager.locationManager.location?.coordinate.longitude)!).distance(from: CLLocation(latitude: circularRegion.center.latitude, longitude: circularRegion.center.longitude)) < 150{
        isInsideRegion = true
    }
    
}
```

When the isInRegion variable of class locationDataManager is changed, the onReceive method will be called. The changed value is passed to variable newValue, which is also passed to isInsideRegion of AlbumView. Also, because of a bug that make the toolbar item change to lock when i take a picture, i made a task that checks the distance between their current location and the region location is below 150 meters and set the variable isInsideRegion to true.
### Map View

MapView displays shown as follows: 


<img src="https://github.com/gregoriusyuristama/PhotoBox/assets/102383943/7d9c3fed-1ac4-4d34-9ede-efbd57bfbd31" height="400"/>

As you can see, the user can see their collection location from the red annotation on the map. A locate button helps users locate their current location and displays it in MapView.

MKMapViewRepresentable is used to display a native MapView from Apple, and on makeUIView it returns a MKMapView object.

MapViewRepresentable.swift

```swift
func makeUIView(context: UIViewRepresentableContext<MKMapViewRepresentable>) -> MKMapView {
    mapViewContainer.mapView.delegate = context.coordinator
    
    context.coordinator.followUserIfPossible()
    
    return mapViewContainer.mapView
}
```
Because the code is too long, I will only display the makeUIView method. If you want to see the full code, open the MapViewRepresentable.swift file.

Also, to display the annotation of every collection location, I fetch the data of album location first from coreData and display it on the updateUIView method of MapViewRepresentable.

The code for fetching CoreData is as simple as this: 

```swift
@FetchRequest(sortDescriptors: [SortDescriptor(\.albumName)]) var albums: FetchedResults<Album>
```

The line of code above basically fetches from the Album model and sorting it by album name. After that, the results are passed to variable albums.

After we got the fetched result from CoreData, I inserted every album location as an annotation on the updateUIView method like this: 

```swift
func updateUIView(_ mapView: MKMapView, context: UIViewRepresentableContext<MKMapViewRepresentable>) {
    if mapView.userTrackingMode != userTrackingMode.wrappedValue {
        mapView.setUserTrackingMode(userTrackingMode.wrappedValue, animated: true)
    }
    
    albums.forEach{ album in
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: album.latitude, longitude: album.longitude)
        
        mapView.addAnnotation(annotation)
        
    }
}
```

The first is simply for changing the tracking mode of mapview to follow the user if possible. The annotation is added to the mapview using the forEach method of variable albums. Every annotation on mapView is created using MKPointAnnotation, so because every album has their longitude and latitude, I passed their longitude and latitude to CLLocationCoordinate2D and input it to annotation that is a MKPointAnnotation object.

### Photo Booth

This is the most complex part of my app because I need to add an overlay to the camera. I also need to capture both the viewfinder image and the overlay. The display of the photo booth looks like this: 



<img src="https://github.com/gregoriusyuristama/PhotoBox/assets/102383943/42de7640-a036-41b6-8737-0de478f1d56f" height="400"/>


There is a list of filters that they can use, along with capture button to capture the image, and flip camera button to flip camera front to back and vice versa.

The Camera class is copied from Apple's sample apps [here](https://developer.apple.com/tutorials/sample-apps/capturingphotos-captureandsave)

I'm adding the asset for the photo booth filter by inputting every overlay to the Assets file, and adding it to the Camera.swift class like this: 

Camera.swift

```swift
var overlayImages: [UIImage] = []
private var currentOverlayIndex = 0

private func initialize() {
    sessionQueue = DispatchQueue(label: "session queue")
    
    captureDevice = availableCaptureDevices.first ?? AVCaptureDevice.default(for: .video)
    
    UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    NotificationCenter.default.addObserver(self, selector: #selector(updateForDeviceOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
    self.overlayImages = [
        UIImage(named: "emptyOverlay")!,
        UIImage(named: "Overlay1")!,
        UIImage(named: "Overlay2")!,
        UIImage(named: "Overlay3")!,
        UIImage(named: "Overlay4")!,
        UIImage(named: "Overlay5")!,
        UIImage(named: "Overlay6")!,
        UIImage(named: "testOverlay2")!,
        UIImage(named: "testOverlay3")!,
        UIImage(named: "testOverlay4")!,
        UIImage(named: "testOverlay5")!,
    ]
    }

```

The Camera.swift class is then initialized on CameraDataModel as a bridge between the camera model and camera view.

CameraDataModel.swift

```swift
let camera = Camera()
```


And to display it in the camera view, I use a ZStack like this:

CameraViewNew.swift

```swift
ZStack{
    ViewfinderView(image:  $model.viewfinderImage )
        .background(.black)
        .frame(width: 70, height: 70)
        .mask{
            Rectangle()
                .frame(width: 70, height: 70)
                .cornerRadius(10)
        }
    
    Image(uiImage: model.camera.overlayImages[i])
        .resizable()
        .scaledToFit()
        .frame(width: 70, height: 70)
        .gesture(TapGesture().onEnded({ self.selectedOverlayIndex = i }))
}


```
The code for displaying a HStack that acts as a button to apply filters is like this: 

CameraViewNew.swift

```swift
ForEach(0..<self.model.camera.overlayImages.count, id: \.self) { i in
    
    ZStack{
        ViewfinderView(image:  $model.viewfinderImage )
            .background(.black)
            .frame(width: 70, height: 70)
            .mask{
                Rectangle()
                    .frame(width: 70, height: 70)
                    .cornerRadius(10)
            }
        
        Image(uiImage: model.camera.overlayImages[i])
            .resizable()
            .scaledToFit()
            .frame(width: 70, height: 70)
            .gesture(TapGesture().onEnded({ self.selectedOverlayIndex = i }))
    }
}
```

After the viewing logic is done, let's dive into the capturing image code. 
First, i modify the takePhoto function to have a completion like this: 

Camera.swift

```swift
private var completion: ((UIImage) -> Void)?

func takePhoto(completion: @escaping (UIImage) -> Void) {
    guard let photoOutput = self.photoOutput else { return }
    
    sessionQueue.async {
    
        var photoSettings = AVCapturePhotoSettings()

        if photoOutput.availablePhotoCodecTypes.contains(.hevc) {
            photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        }
        
        let isFlashAvailable = self.deviceInput?.device.isFlashAvailable ?? false
        photoSettings.flashMode = isFlashAvailable ? .auto : .off
        photoSettings.isHighResolutionPhotoEnabled = false
        if let previewPhotoPixelFormatType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormatType]
        }
        photoSettings.photoQualityPrioritization = .balanced
        
        if let photoOutputVideoConnection = photoOutput.connection(with: .video) {
            if photoOutputVideoConnection.isVideoOrientationSupported,
                let videoOrientation = self.videoOrientationFor(self.deviceOrientation) {
                photoOutputVideoConnection.videoOrientation = videoOrientation
            }
        }
        
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
        
        self.completion = completion
    }
}
```

And then the completion that have type of UIImage is called on the CameraViewNew capture button like this: 

CameraViewNew.swift

```swift
Button{
    model.camera.takePhoto { image in
        capturedImage = image
    }
}label: {
    Circle()
        .fill(.white)
        .frame(width: 95, height: 95)
        .overlay{
            Circle()
                .stroke(lineWidth: 1)
                .foregroundColor(.black)
                .frame(width: 86, height: 86)
        }
}
```

Basically when the user clicked the capture button, it will call the takePhoto function on camera and the after that input the completion that have UIImage type to capturedImage variable on the view.

To check whether the capturedImage is not null, we can use this if : 

CameraViewNew.swift

```swift
if let image = capturedImage {
        
    Image(uiImage: image)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                Button{
                    let fixedPhoto = fixOrientation(img: capturedImage!)
                    AlbumDataController().addPhoto(album: album!, photo: fixedPhoto.pngData()!, context: managedObjContext)
                    savePhotoToLibrary(fixedPhoto)
                    dismiss()
                    
                }label: {
                    Text("Save Photo")
                }
            }
        }
        .onAppear {
            model.camera.isPreviewPaused = true
        }
        .onDisappear {
            model.camera.isPreviewPaused = false
        }
}
```

the code above is basically to change the view displayed when an image already captured to this view :

<img src="https://github.com/gregoriusyuristama/PhotoBox/assets/102383943/4bfbe673-eeda-4e93-bb7b-ea84d4e293a2" height="400"/>

<!-- ![IMG_31E44038B0D0-1](https://github.com/gregoriusyuristama/PhotoBox/assets/102383943/4bfbe673-eeda-4e93-bb7b-ea84d4e293a2) -->

And when the user click save button, it will save it to CoreData and to native iOS photos app. To capture the ViewFinderImage and the filter i modify the photoOutput function on Camera class like this : 

Camera.swift

```swift
func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    
    if let error = error {
        logger.error("Error capturing photo: \(error.localizedDescription)")
        return
    }
    
    if let imageData = photo.fileDataRepresentation(), let capturedImage = UIImage(data: imageData){
        completion?(drawOverlayImage(overlayImages[currentOverlayIndex], on: capturedImage)!)
        
    }
    
   
    addToPhotoStream?(photo)
}
private func drawOverlayImage(_ overlayImage: UIImage, on baseImage: UIImage) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(baseImage.size, false, baseImage.scale)
    baseImage.draw(in: CGRect(origin: .zero, size: baseImage.size))
    
    let overlaySize = CGSize(width: baseImage.size.width, height: baseImage.size.height)
    overlayImage.draw(in: CGRect(origin: .zero, size: overlaySize))
    
    let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return compositeImage
}
```

The function that add image above the photo captured is drawOverlayImage() function.


That's all i can explain from my code, hope you who read this could inspired and make a greater apps than mine :))
