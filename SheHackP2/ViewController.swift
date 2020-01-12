//
//  ViewController.swift
//  SheHackP2
//
//  Created by Emma Park on 2020/01/11.
//  Copyright © 2020 Emma Park. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //image capture screen

    
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera

        present(imagePicker, animated: true, completion: nil)
    }

    @IBOutlet weak var background: UIImageView!
    var imagePicker: UIImagePickerController!
    
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //hide buttons
        imageView.isHidden = true
        takePhotoButton.isHidden = true
        background.isHidden = true
        
        imageView.image = info[.originalImage] as? UIImage
        guard let selectedImage = imageView.image else {
            print("Image not found!")
            return
        }
        
        //save photo to library and dismiss image picker
        UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil);
        imagePicker.dismiss(animated: true, completion: nil)
        
        let viewController = SecondScreenViewController(nibName:"SecondScreenViewController", bundle: nil)
        viewController.image = selectedImage
        let svc = self.storyboard!.instantiateViewController(withIdentifier:"secondScreen") as! SecondScreenViewController
        svc.modalPresentationStyle = .fullScreen
        self.present(svc, animated: false, completion: nil)
        
//        //switch screens to next panel
//        let svc = self.storyboard!.instantiateViewController(withIdentifier:"secondScreen") as! SecondScreenViewController
//        self.present(svc, animated: false, completion: nil)
        

    }
    
    
    
    

}
    

