//
//  ViewController.swift
//  SpacePhoto
//
//  Created by Vladyslav Torhovenkov on 18.06.2023.
//

import UIKit

class ViewController: UIViewController, DatePickerViewControllerDelegate {
    
    
    func dateSelected(date: Date) {
        Task {
            do {
                let photoInfo = try await photoInfoController.fetchPhotoInfo(for: date)
                try await updateUI(with: photoInfo)
            } catch {
                updateUI(with: error)
            }
        }
    }
    
    let photoInfoController = PhotoInfoController()
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var copyrightLabel: UILabel!
    @IBOutlet var titleItem: UINavigationItem!
    
 
    
    
    func updateUI(with photoInfo: PhotoInfo) async throws {
        self.titleItem.title = photoInfo.title
        self.descriptionLabel.text = photoInfo.description
        self.copyrightLabel.text = photoInfo.copyright ?? ""
        if photoInfo.mediaType == "video" {
//           await UIApplication.shared.open(photoInfo.url)
            self.imageView.image = try await PhotoInfo.fetchPhoto(from: photoInfo.thumbsUrl!)
        } else {
            self.imageView.image = try await PhotoInfo.fetchPhoto(from: photoInfo.url)
        }
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
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = CGFloat(30)
        
        Task {
            do {
                let photoInfo = try await photoInfoController.fetchPhotoInfo()
                try await updateUI(with: photoInfo)
            } catch {
                updateUI(with: error)
            }
        }
    }
    
    @IBSegueAction func showDatePicker(_ coder: NSCoder) -> DatePickerViewController? {
        return DatePickerViewController(coder: coder, delegate: self)
    }
    

}

