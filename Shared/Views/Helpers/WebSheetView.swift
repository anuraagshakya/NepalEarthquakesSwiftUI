//
//  WebSheetView.swift
//  NepalEarthquakes (iOS)
//
//  Created by Anuraag Shakya on 05.10.21.
//

import SwiftUI
import WebKit

struct WebSheetView: UIViewRepresentable {
    let request: URLRequest
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
}

struct WebSheetView_Previews: PreviewProvider {
    static var previews: some View {
        WebSheetView(request: URLRequest(url: URL(string: "https://www.anuraagshakya.com")!))
    }
}
