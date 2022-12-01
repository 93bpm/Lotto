//
//  ScannerView.swift
//  Lotto
//
//  Created by Qtec on 2022/11/28.
//

import UIKit

import AVFoundation

enum ScanStatus {
    case success(_ code: String?)
    case fail
    case stop(_ isTap: Bool)
}

protocol ScannerViewDelegate: AnyObject {
    func completion(in status: ScanStatus)
}

class ScannerView: UIView {
    
    weak var delegate: ScannerViewDelegate?
    
    //카메라 화면을 보여줄 Layer
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var captureSession: AVCaptureSession?
    
    //촬영 시 어떤 데이터를 검사할건지
    private let metadataObjectTypes: [AVMetadataObject.ObjectType] = [.qr]
    
    private var cornerLength: CGFloat = 30
    private var cornerLineWidth: CGFloat = 5
    private var rectOfInterest: CGRect {
        return CGRect(
            x: (frame.width / 2) - 125,
            y: (frame.height / 2) - 200,
            width: 250,
            height: 250
        )
    }
    
    var isRunning: Bool {
        guard let captureSession = captureSession else {
            return false
        }
        
        return captureSession.isRunning
    }
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///AVCaptureSession을 실행하는 화면 구성
    private func initView() {
        clipsToBounds = true
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        let videoInput: AVCaptureInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return print(error.localizedDescription)
        }
        
        guard let captureSession = captureSession else {
            return fail()
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return fail()
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.metadataObjectTypes = metadataObjectTypes
            metadataOutput.setMetadataObjectsDelegate(
                self,
                queue: DispatchQueue.main
            )
        } else {
            return fail()
        }
        
        setPreviewLayer()
        setFocusZoneCornerLayer()
        /*
         // QRCode 인식 범위 설정하기
         metadataOutput.rectOfInterest 는 AVCaptureSession에서 CGRect 크기만큼 인식 구역으로 지정합니다.
         !! 단 해당 값은 먼저 AVCaptureSession를 running 상태로 만든 후 지정해주어야 정상적으로 작동합니다 !!
         */
        
        start()
        metadataOutput.rectOfInterest = previewLayer!.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }
    
    /// 중앙에 사각형의 Focus Zone Layer을 설정합니다.
    private func setPreviewLayer() {
        let readingRect = rectOfInterest
        
        guard let captureSession = captureSession else {
            return
        }
        
        /*
         AVCaptureVideoPreviewLayer를 구성.
         */
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = self.layer.bounds

        // MARK: - Scan Focus Mask
        /*
         Scan 할 사각형(Focus Zone)을 구성하고 해당 자리만 dimmed 처리를 하지 않음.

         CAShapeLayer에서 어떠한 모양(다각형, 폴리곤 등의 도형)을 그리고자 할 때 CGPath를 사용한다.
         즉 previewLayer에다가 ShapeLayer를 그리는데
         ShapeLayer의 모양이 [1. bounds 크기의 사각형, 2. readingRect 크기의 사각형]
         두개가 그려져 있는 것이다.
         */
        let path = CGMutablePath()
        path.addRect(bounds)
        path.addRect(readingRect)

        /*
         그럼 Path(경로? 모양?)은 그렸으니 Layer의 특징을 정하고 추가해보자.
         먼저 CAShapeLayer의 path를 위에 지정한 path로 설정해주고,
         QRReader에서 백그라운드 색이 dimmed 처리가 되어야 하므로 layer의 투명도를 0.6 정도로 설정한다.
         단 여기서 QRCode를 읽을 부분은 dimmed 처리가 되어 있으면 안 된다.
         이럴때 fillRule에서 evenOdd를 지정해주는데
         Path(도형)이 겹치는 부분(여기서는 readingRect, QRCode 읽는 부분)은 fillColor의 영향을 받지 않는다
         */
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillColor = UIColor(white: 0, alpha: 0.4).cgColor
        maskLayer.fillRule = .evenOdd

        previewLayer.addSublayer(maskLayer)
        
        
        layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
    }
    
    /// Focus Zone의 모서리에 테두리 Layer을 씌웁니다.
    private func setFocusZoneCornerLayer() {
//        var cornerRadius = previewLayer?.cornerRadius ?? CALayer().cornerRadius
        var cornerRadius: CGFloat = 10
        if cornerRadius > cornerLength {
            cornerRadius = cornerLength
        }
        
        if cornerLength > rectOfInterest.width / 2 {
            cornerLength = rectOfInterest.width / 2
        }

        let dir: CGFloat = 2
        // Focus Zone의 각 모서리 point
        let upperLeftPoint = CGPoint(
            x: rectOfInterest.minX - cornerLineWidth / dir,
            y: rectOfInterest.minY - cornerLineWidth / dir
        )
        let upperRightPoint = CGPoint(
            x: rectOfInterest.maxX + cornerLineWidth / dir,
            y: rectOfInterest.minY - cornerLineWidth / dir
        )
        let lowerRightPoint = CGPoint(
            x: rectOfInterest.maxX + cornerLineWidth / dir,
            y: rectOfInterest.maxY + cornerLineWidth / dir
        )
        let lowerLeftPoint = CGPoint(
            x: rectOfInterest.minX - cornerLineWidth / dir,
            y: rectOfInterest.maxY + cornerLineWidth / dir
        )
        
        // 각 모서리를 중심으로 한 Edge를 그림.
        let upperLeftCorner = UIBezierPath()
        upperLeftCorner.move(to: upperLeftPoint.offsetBy(dx: 0, dy: cornerLength))
        upperLeftCorner.addArc(
            withCenter: upperLeftPoint.offsetBy(dx: cornerRadius, dy: cornerRadius),
            radius: cornerRadius,
            startAngle: .pi,
            endAngle: 3 * .pi / 2,
            clockwise: true
        )
        upperLeftCorner.addLine(to: upperLeftPoint.offsetBy(dx: cornerLength, dy: 0))

        let upperRightCorner = UIBezierPath()
        upperRightCorner.move(to: upperRightPoint.offsetBy(dx: -cornerLength, dy: 0))
        upperRightCorner.addArc(
            withCenter: upperRightPoint.offsetBy(dx: -cornerRadius, dy: cornerRadius),
            radius: cornerRadius,
            startAngle: 3 * .pi / 2,
            endAngle: 0,
            clockwise: true
        )
        upperRightCorner.addLine(to: upperRightPoint.offsetBy(dx: 0, dy: cornerLength))

        let lowerRightCorner = UIBezierPath()
        lowerRightCorner.move(to: lowerRightPoint.offsetBy(dx: 0, dy: -cornerLength))
        lowerRightCorner.addArc(
            withCenter: lowerRightPoint.offsetBy(dx: -cornerRadius, dy: -cornerRadius),
            radius: cornerRadius,
            startAngle: 0,
            endAngle: .pi / 2,
            clockwise: true
        )
        lowerRightCorner.addLine(to: lowerRightPoint.offsetBy(dx: -cornerLength, dy: 0))

        let bottomLeftCorner = UIBezierPath()
        bottomLeftCorner.move(to: lowerLeftPoint.offsetBy(dx: cornerLength, dy: 0))
        bottomLeftCorner.addArc(
            withCenter: lowerLeftPoint.offsetBy(dx: cornerRadius, dy: -cornerRadius),
            radius: cornerRadius,
            startAngle: .pi / 2,
            endAngle: .pi,
            clockwise: true
        )
        bottomLeftCorner.addLine(to: lowerLeftPoint.offsetBy(dx: 0, dy: -cornerLength))
        
        // 그려진 UIBezierPath를 묶어서 CAShapeLayer에 path를 추가 후 화면에 추가.
        let combinedPath = CGMutablePath()
        combinedPath.addPath(upperLeftCorner.cgPath)
        combinedPath.addPath(upperRightCorner.cgPath)
        combinedPath.addPath(lowerRightCorner.cgPath)
        combinedPath.addPath(bottomLeftCorner.cgPath)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = combinedPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = cornerLineWidth
        shapeLayer.lineCap = .square

        previewLayer!.addSublayer(shapeLayer)
    }
}

extension ScannerView {
    
    private func start() {
        captureSession?.startRunning()
    }
    
    private func stop(isTap: Bool = false) {
        captureSession?.stopRunning()
        delegate?.completion(in: .stop(isTap))
    }
    
    private func fail() {
        delegate?.completion(in: .fail)
        captureSession = nil
    }
    
    private func found(code: String) {
        delegate?.completion(in: .success(code))
    }
}

extension ScannerView: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard
            let object = metadataObjects.first,
            let readableObject = object as? AVMetadataMachineReadableCodeObject,
            let stringValue = readableObject.stringValue
        else {
            return
        }
        
        let vibrate = SystemSoundID(kSystemSoundID_Vibrate)
        AudioServicesPlaySystemSound(vibrate)
        
        found(code: stringValue)
        stop(isTap: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.start()
        }
    }
}

private extension CGPoint {
    
    func offsetBy(dx x: CGFloat, dy y: CGFloat) -> CGPoint {
        var point = self
        point.x += x
        point.y += y
        return point
    }
}
