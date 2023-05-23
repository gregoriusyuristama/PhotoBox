import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> CameraPreviewView {
        let previewView = CameraPreviewView()
        previewView.session = session
        previewView.sizeThatFits(CGSize(width: 300, height: 400))
        return previewView
    }
    
    func updateUIView(_ uiView: CameraPreviewView, context: Context) {
        uiView.session = session
    }
}

class CameraPreviewView: UIView {
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    var session: AVCaptureSession? {
        didSet {
            if let session = session {
                if let previewLayer = previewLayer {
                    previewLayer.session = session
                } else {
                    let newPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                    newPreviewLayer.videoGravity = .resizeAspectFill
                    layer.addSublayer(newPreviewLayer)
                    previewLayer = newPreviewLayer
                }
            } else {
                previewLayer?.removeFromSuperlayer()
                previewLayer = nil
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
}
