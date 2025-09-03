//
//  KeyboardPreHeater.swift
//  MageGameApp
//
//  Created by aluno-02 on 26/08/25.
//

import Foundation
import SwiftUI
import UIKit

struct KeyboardPreheater: UIViewRepresentable {
    func makeUIView(context: Context) -> UITextField {
        let tf = UITextField(frame: .zero)
        tf.isHidden = true
        // dispara após colocar na hierarquia
        DispatchQueue.main.async {
            tf.becomeFirstResponder()
            // solta logo em seguida
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                tf.resignFirstResponder()
            }
        }
        return tf
    }
    func updateUIView(_ uiView: UITextField, context: Context) {}
}
