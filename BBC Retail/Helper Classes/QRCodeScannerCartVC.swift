//
//  QRCodeScannerCartVC.swift
//  BBC Retail
//
//  Created by Himanshu on 09/11/22.
//

import UIKit
import CoreGraphics
import AVFoundation

//QRScannerCodeDelegate Protocol
public protocol QRScannerCodeDelegate1: AnyObject {
    func qrCodeScanningDidCompleteWithResult1(result: String)
    func qrCodeScanningFailedWithError1(error: String)
}

protocol goToCart{
    func cartPush()
}

class QRCodeScannerCartVC: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    //MARK: -IBOUTLET
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var torchButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var goToCartButton: UIButton!
    @IBOutlet weak var lblinfoMsg: UILabel!
    @IBOutlet var squareView: SquareView!
    @IBOutlet weak var vwBlur: UIView!
    
    //MARK: -VARIABLE
    var scannerType =  "QR" //Default
    var delegate1 : goToCart?
    weak var delegate : QRScannerCodeDelegate1?
    //Default Properties
    let bottomSpace: CGFloat = 60.0
    var devicePosition: AVCaptureDevice.Position = .back
    open var qrScannerFrame: CGRect = CGRect.zero
    
    //Initialization part
    lazy var captureSession = AVCaptureSession()
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCameraPermission()
     //   if scannerType == "QR"{
        lblinfoMsg.text = "Align QR or Bar Code within frame to scan"
//        }else{
//            lblinfoMsg.text = "Align Bar Code within frame to scan"
//        }
        //Currently only "Portraint" mode is supported
       // UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
       // prepareQRScannerView(self.view)
        //startScanningQRCode()
    }
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateBlurViewHole()
        self.view.bringSubviewToFront(cancelButton)
        self.view.bringSubviewToFront(torchButton)
        self.view.bringSubviewToFront(cameraButton)
        self.view.bringSubviewToFront(lblinfoMsg)
        
    }
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Lazy initialization of properties
    lazy var defaultDevice: AVCaptureDevice? = {
        if let device = AVCaptureDevice.default(for: .video) {
            return device
        }
        
        return nil
    }()
    
    lazy var frontDevice: AVCaptureDevice? = {
        if #available(iOS 10, *) {
            if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                return device
            }
        } else {
            for device in AVCaptureDevice.devices(for: .video) {
                if device.position == .front {
                    return device
                }
            }
        }
        return nil
    }()
    
    lazy var defaultCaptureInput: AVCaptureInput? = {
        if let captureDevice = defaultDevice {
            do {
                return try AVCaptureDeviceInput(device: captureDevice)
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }()
    
    lazy var frontCaptureInput: AVCaptureInput?  = {
        if let captureDevice = frontDevice {
            do {
                return try AVCaptureDeviceInput(device: captureDevice)
            } catch let error as NSError {
                print(error)
            }
          }
        return nil
        }()
    
    lazy var dataOutput = AVCaptureMetadataOutput()
    
    lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.cornerRadius = 10.0
        return layer
        }()
    
    open func prepareQRScannerView(_ view: UIView) {
        qrScannerFrame = view.frame
        setupCaptureSession(devicePosition)//Default device capture position is back
        addViedoPreviewLayer(view)
       // createCornerFrame()
        addButtons(view)
     }
    //MARK: - CHECK CAMERA ACCESS
    
    func checkCameraPermission() {

        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authorizationStatus {

        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self](granted) in
                if granted {
                    print("access granted")
                    DispatchQueue.main.async { [weak self] in
                        self!.prepareQRScannerView(self!.view)
                        self!.startScanningQRCode()
                    }

                } else {
                    print("access denied")
                    DispatchQueue.main.async { [weak self] in
                        self?.alertUserCameraPermissionMustBeEnabled()
                    }
                }
            }

        case .authorized:
            print("Access authorized")
            prepareQRScannerView(self.view)
            startScanningQRCode()

        case .denied, .restricted:
            print("restricted")
            alertUserCameraPermissionMustBeEnabled()

        @unknown default:
            fatalError()
        }
    }

    func alertUserCameraPermissionMustBeEnabled() {

        let message = "Camera access is necessary to use Augemented Reality for this app.\n\nPlease go to Settings to allow access to the Camera.\n Please switch the button to the green color."

        let alert = UIAlertController (title: "Camera Access Required", message: message, preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: CommonConstant.Settings, style: .default, handler: { (action) in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (_) in
                })
            }
        })

        alert.addAction(settingsAction)

        present(alert, animated: true, completion: nil)
    }

  
    private func createCornerFrame() {
        let width: CGFloat = 200.0
        let height: CGFloat = 200.0
        let rect = CGRect.init(origin: CGPoint.init(x: self.view.frame.width/2 - width/2, y: self.view.frame.height/2 - (width+bottomSpace)/2), size: CGSize.init(width: width, height: height))
        self.squareView = SquareView(frame: rect)
        if let squareView = squareView {
            self.view.addSubview(squareView)
        }
    }
    
    private func addButtons(_ view: UIView) {
       // let height: CGFloat = 44.0
       // let width: CGFloat = 44.0
        
        //Cancel button
     //   let cancelButton: UIButton = UIButton(frame: CGRect(x: view.frame.width/2 - width/2, y: view.frame.height - height, width: width, height: height))
      //  cancelButton.setTitle("X", for: .normal)
        //cancelButton.setImage(UIImage(named: "cancel"), for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissVC), for:.touchUpInside)
        
        //Torch button
      //  let torchButton: UIButton = UIButton(frame: CGRect(x: 16, y: self.view.bounds.size.height - (bottomSpace + height), width: width, height: height))
      //  torchButton.setImage(UIImage(named: "flass-off"), for: .normal)
       // torchButton.tintColor = UIColor.white
        torchButton.addTarget(self, action: #selector(toggleTorch), for: .touchUpInside)
        
        //Camera button
       // cameraButton = UIButton(frame: CGRect(x: self.view.bounds.width - (width + 16), y: self.view.bounds.size.height - (bottomSpace + height), width: width, height: height))
       // cameraButton.setImage(UIImage(named: "switch-camera-button"), for: .normal)
        cameraButton.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
        
       
        //view.addSubview(cancelButton)
       // view.addSubview(torchButton)
       // view.addSubview(cameraButton)
        
    }
    
    //Toggle torch
    @objc func toggleTorch() {
        
        //If device postion is front then no need to torch
        if let currentInput = getCurrentInput() {
            if currentInput.device.position == .front {
                return
            }
        }
        
        guard  let defaultDevice = defaultDevice else {return}
        if defaultDevice.isTorchAvailable {
            do {
                try defaultDevice.lockForConfiguration()
                defaultDevice.torchMode = defaultDevice.torchMode == .on ? .off : .on
                torchButton.setImage(defaultDevice.torchMode == .on ? UIImage(named: "flash-on") : UIImage(named: "flash-off"), for: .normal)
                defaultDevice.unlockForConfiguration()
            } catch let error as NSError {
                print(error)
            }
          }
         }
    
    //Switch camera
    @objc func switchCamera() {
        if let frontDeviceInput = frontCaptureInput {
            captureSession.beginConfiguration()
            if let currentInput = getCurrentInput() {
                captureSession.removeInput(currentInput)
                let newDeviceInput = (currentInput.device.position == .front) ? defaultCaptureInput : frontDeviceInput
                captureSession.addInput(newDeviceInput!)
            }
            captureSession.commitConfiguration()
         }
      }
    
    private func getCurrentInput() -> AVCaptureDeviceInput? {
        if let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput {
            return currentInput
        }
        return nil
    }
    
    //dismiss ViewController
    @objc func dismissVC() {
        removeVideoPriviewlayer()
        self.dismiss(animated: true, completion: nil)
    }
    
    open func startScanningQRCode() {
        if captureSession.isRunning {
            return
        }
        DispatchQueue.main.async {
            self.captureSession.startRunning()

        }
    }
    
    private func setupCaptureSession(_ devicePostion: AVCaptureDevice.Position) {
        
        if captureSession.isRunning {
            return
        }
        
        switch devicePosition {
        case .front:
            if let frontDeviceInput = frontCaptureInput {
                if !captureSession.canAddInput(frontDeviceInput) {
                    delegate?.qrCodeScanningFailedWithError1(error: "Failed to add Input")
                    return
                }
                captureSession.addInput(frontDeviceInput)
            }
            break;
        case .back, .unspecified :
            if let defaultDeviceInput = defaultCaptureInput {
                if !captureSession.canAddInput(defaultDeviceInput) {
                    delegate?.qrCodeScanningFailedWithError1(error: "Failed to add Input")
                    return
                }
                captureSession.addInput(defaultDeviceInput)
            }
            break
            
        @unknown default:
            fatalError()
        }
        
        if !captureSession.canAddOutput(dataOutput) {
            delegate?.qrCodeScanningFailedWithError1(error: "Failed to add Output")
            return
        }
        
        captureSession.addOutput(dataOutput)
        dataOutput.metadataObjectTypes = dataOutput.availableMetadataObjectTypes
        dataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
    }
    
    private func addViedoPreviewLayer(_ view: UIView) {
        videoPreviewLayer.frame = CGRect(x:view.bounds.origin.x, y: view.bounds.origin.y, width: view.bounds.size.width, height: view.bounds.size.height - bottomSpace)
           updateBlurViewHole()
            view.layer.insertSublayer(videoPreviewLayer, at: 0)
       
//            self.view.bringSubviewToFront(self.vwBlur)
            
        
    }
    @IBAction func buttonGoToCart(_ sender: UIButton) {
        if let del1 = self.delegate1{
            self.dismiss(animated: true)
            del1.cartPush()
        }

    }
    func updateBlurViewHole() {
           let maskView = UIView(frame: self.vwBlur.bounds)
           maskView.clipsToBounds = true;
           maskView.backgroundColor = UIColor.clear

        let outerbezierPath = UIBezierPath.init(roundedRect: self.vwBlur.bounds, cornerRadius: 5)
        let rect =  squareView.frame
        let innerCirclepath = UIBezierPath.init(rect: rect)//init(roundedRect:rect, cornerRadius:rect.height * 0.5)
           outerbezierPath.append(innerCirclepath)
           outerbezierPath.usesEvenOddFillRule = true

           let fillLayer = CAShapeLayer()
           fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
           fillLayer.fillColor = UIColor.green.cgColor // any opaque color would work
           fillLayer.path = outerbezierPath.cgPath
           maskView.layer.addSublayer(fillLayer)
          self.vwBlur.mask = maskView;
       }
    private func removeVideoPriviewlayer() {
        videoPreviewLayer.removeFromSuperlayer()
    }
    
    /// This method get called when Scanning gets complete
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for data in metadataObjects {
            let transformed = videoPreviewLayer.transformedMetadataObject(for: data) as? AVMetadataMachineReadableCodeObject
            if let unwraped = transformed {
                if unwraped.stringValue != nil {
                    delegate?.qrCodeScanningDidCompleteWithResult1(result: unwraped.stringValue!)
                } else {
                    delegate?.qrCodeScanningFailedWithError1(error: "Empty string found")
                }
                captureSession.stopRunning()
                removeVideoPriviewlayer()
            }
        }
    }
}

//Currently Scanner suppoerts only portrait mode.

extension QRCodeScannerCartVC {
    ///Make orientations to portrait
    override public var shouldAutorotate: Bool {
        return false
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
}

/** This class is for draw corners of Square to show frame for scan QR code.
 *  @IBInspectable parameters are the line color, sizeMultiplier, line width.
 */

