//
//  PDFViewController.swift
//  SnapNote
//
//  Created by chaitanya on 24/05/25.
//

import UIKit
import PDFKit

class PDFViewerViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    var pdfView: PDFView!
    var pdfURL: URL?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let pdfURL = pdfURL {
            self.title = pdfURL.deletingPathExtension().lastPathComponent
        }
        view.backgroundColor = .systemBackground
        setupPDFView()
    }

    private func setupPDFView() {
        guard let url = pdfURL else {
            //print("Invalid PDF URL")
            return
        }

        // Remove existing subviews to avoid duplicates
        containerView.subviews.forEach { $0.removeFromSuperview() }

        pdfView = PDFView(frame: containerView.bounds)
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous

        containerView.addSubview(pdfView)

        // Set constraints
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: containerView.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            pdfView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        DispatchQueue.global(qos: .userInitiated).async {
            if let document = PDFDocument(url: url) {
                DispatchQueue.main.async {
                    self.pdfView.document = document
                }
            } else {
                DispatchQueue.main.async {
                    print("Failed to load PDF. Try again soon!")
                }
            }
        }
    }
}
