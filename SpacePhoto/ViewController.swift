//
//  ViewController.swift
//  SpacePhoto
//
//  Created by Vladyslav Torhovenkov on 18.06.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let photoInfoController = PhotoInfoController()

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var copyrightLabel: UILabel!
    @IBOutlet var titleItem: UINavigationItem!
    
    
    func updateUI(with photoInfo: PhotoInfo) async throws {
        self.titleItem.title = photoInfo.title
        self.descriptionLabel.text = photoInfo.description
        self.copyrightLabel.text = photoInfo.copyright ?? ""
        self.imageView.image = try await PhotoInfo.fetchPhoto(from: photoInfo.url)
    }
    
    func updateUI(with error: Error) {
        self.titleItem.title = "Error Fetching Photo"
        self.descriptionLabel.text = error.localizedDescription
        self.copyrightLabel.text = "Error fetching copyright"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleItem.title = ""
        descriptionLabel.text = ""
        copyrightLabel.text = ""
        
        Task {
            do {
                let photoInfo = try await photoInfoController.fetchPhotoInfo()
                try await updateUI(with: photoInfo)
            } catch {
                updateUI(with: error)
            }
        }
    }


}

