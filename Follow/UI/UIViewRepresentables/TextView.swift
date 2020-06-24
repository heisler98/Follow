//
//  TextView.swift
//  Follow
//
//  Created by Hunter Eisler on 6/24/20.
//  Copyright © 2020 Hunter Eisler. All rights reserved.
//

import Foundation
import SwiftUI

struct TextView: UIViewRepresentable {
    
    @Binding var text: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView(frame: .zero)
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
        init(_ parent: TextView) {
            self.parent = parent
        }
    }
}
