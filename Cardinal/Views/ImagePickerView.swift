//
//  ImagePickerView.swift
//  ID Changer
//
//  Created by lemin on 8/29/23.
//

import Foundation
import SwiftUI
import PhotosUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: Card

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {

        let imagePickerB = UIImagePickerController()
        imagePickerB.allowsEditing = false
        imagePickerB.sourceType = sourceType
        imagePickerB.delegate = context.coordinator

        return imagePickerB
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerView>) {
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePickerView

        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage.newImage = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}
