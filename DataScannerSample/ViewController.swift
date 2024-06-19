//
//  ViewController.swift
//  DataScannerSample
//
//  Created by Jorge de Carvalho on 17/06/24.
//

import UIKit
import VisionKit

class ViewController: UIViewController {

    @IBOutlet weak var scannedText: UILabel!
    @IBOutlet weak var startScanningButton: UIButton!

    var isDataScannerAvailable: Bool {
        DataScannerViewController.isAvailable &&
        DataScannerViewController.isSupported
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startScanningButton.layer.cornerRadius = 10
    }

    @IBAction func startScanningPressed(_ sender: Any) {
        guard isDataScannerAvailable else {
            return showUnavailableAlert()
        }

        self.configureDataScanner()
    }
    

    func showUnavailableAlert() {
        let alert = UIAlertController(
            title: "Your device is not compatible!",
            message: "To use, open app on a devices with iOS 16 or above and accept the terms.",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func configureDataScanner() {
        // Specify data types of data to recognize
        let recognitionDataTypes: Set<DataScannerViewController.RecognizedDataType> = [
//            .barcode(symbologies: [.qr]),
//            .text()
            .text(languages: ["en-US", "pt-BR", "de-DE"])
            // You can set the languages the app supports.
//            .text(languages: ["en-US", "pt-BR", "de-DE"])
        ]

        // Create the data scanner, present it and start scanning!
        let dataScanner = DataScannerViewController(
//            recognizedDataTypes: recognitionDataTypes,
            recognizedDataTypes: recognitionDataTypes,
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
//        dataScanner.modalPresentationStyle = .overFullScreen
        dataScanner.delegate = self
        present(dataScanner, animated: true) {
//            do {
                try? dataScanner.startScanning()
//            } catch {
//                print(error)
//            }
        }
    }
}

extension ViewController: DataScannerViewControllerDelegate {
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        switch item {
        case .text(let text):
            print("text: \(text.transcript)")
            UIPasteboard.general.string = text.transcript
            self.scannedText.text = text.transcript
        case .barcode(let barcode):
            print("barcode: \(barcode.payloadStringValue ?? "unknown")")
        default:
            print("unexpected item")
        }
    }
}
