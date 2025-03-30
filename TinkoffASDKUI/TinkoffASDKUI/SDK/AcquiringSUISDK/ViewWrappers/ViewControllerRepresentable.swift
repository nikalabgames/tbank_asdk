//
//  ViewControllerRepresentable.swift
//  TinkoffASDKUI
//
//  Created by Sergey Galagan on 19.04.2024.
//

import SwiftUI
import UIKit

struct ViewControllerRepresentable<Content: UIViewController>: UIViewControllerRepresentable {
    final class Coordinator {
        var parent: Content

        init(_ parent: Content) {
            self.parent = parent
        }
    }

    private let content: Content

    @Binding private var isPresented: Bool?

    init(content: Content, isPresented: Binding<Bool?>) {
        self.content = content
        _isPresented = isPresented
    }

    init(content: Content) {
        self.content = content
        _isPresented = Binding.constant(nil)
    }

    func makeUIViewController(context: Context) -> Content {
        DispatchQueue.main.async {
            content.view.superview?.superview?.backgroundColor = .clear
        }
        return content
    }

    func updateUIViewController(_ uiViewController: Content, context: Context) {
        guard let isPresented else { return }

        if !isPresented {
            uiViewController.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(content)
    }
}
