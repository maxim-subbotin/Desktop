//
//  CameraProvider.swift
//  Desktop
//
//  Created by Maxim Subbotin on 12.06.2022.
//

import Foundation
import AVKit

class CameraProvider {
    enum CameraError: Error {
        case deniedAuthorization
        case restrictedAuthorization
        case cameraUnavailable
        case cannotAddInput
        case cannotAddOutput
        case createCaptureInput(_ error: Error)
        
        case unknown
    }
    enum Status {
      case unconfigured
      case configured
      case unauthorized
      case failed
    }
    
    @Published var error: CameraError?
    let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "desktop.camera")
    private let videoOutput = AVCaptureVideoDataOutput()
    private var status = Status.unconfigured
    
    init() {
        configure()
    }

    private func configure() {
        checkPermissions()
        sessionQueue.async {
            self.configureCaptureSession()
            self.session.startRunning()
        }
    }
    
    private func configureCaptureSession() {
        guard status == .unconfigured else {
            return
        }
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }
        
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        guard let camera = device else {
            set(error: .cameraUnavailable)
            status = .failed
            return
        }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(cameraInput) {
                session.addInput(cameraInput)
            } else {
                set(error: .cannotAddInput)
                status = .failed
                return
            }
        } catch let error {
            set(error: .createCaptureInput(error))
            status = .failed
            return
        }
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            let videoConnection = videoOutput.connection(with: .video)
            videoConnection?.videoOrientation = .portrait
        } else {
            set(error: .cannotAddOutput)
            status = .failed
            return
        }
        
        status = .configured
    }
    
    private func set(error: CameraError?) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
    
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { authorized in
            if !authorized {
                self.status = .unauthorized
                self.set(error: .deniedAuthorization)
            }
            self.sessionQueue.resume()
        }
        case .restricted:
            status = .unauthorized
            set(error: .restrictedAuthorization)
        case .denied:
            status = .unauthorized
            set(error: .deniedAuthorization)
        case .authorized:
            break
        @unknown default:
            status = .unauthorized
            set(error: .unknown)
        }
    }
    
    func set(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue) {
        sessionQueue.async {
            self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
        }
    }
}

class FrameProvider: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    let cameraProvider = CameraProvider()
    
    @Published var current: CVPixelBuffer?
    
    let videoOutputQueue = DispatchQueue(label: "desktop.camera.frame",
                                         qos: .userInitiated,
                                         attributes: [],
                                         autoreleaseFrequency: .workItem)
    override init() {
        super.init()
        cameraProvider.set(self, queue: videoOutputQueue)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let buffer = sampleBuffer.imageBuffer {
            DispatchQueue.main.async {
                self.current = buffer
            }
        }
    }
}
