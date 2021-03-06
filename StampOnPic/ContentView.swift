//
//  ContentView.swift
//  StampOnPic
//
//  Created by zhongdian on 2020/7/15.
//  Copyright © 2020 zhongdian. All rights reserved.
//

import SwiftUI

struct ContentView: View, DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [(kUTTypeFileURL as String), (kUTTypeImage as String)]).first else { return false }

        // If user drop a file
        itemProvider.loadItem(forTypeIdentifier: (kUTTypeFileURL as String), options: nil) {item, error in
            guard let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
            print(url)
            // Do something with the file url
            // remember to dispatch on main in case of a @State change
        }
        
        // If user drop an image
        itemProvider.loadItem(forTypeIdentifier: (kUTTypeImage as String), options: nil) {item, error in
            DispatchQueue.main.async {
                self.hint = "Seems you have just dropped an image instead of a file. Your macOS app doesn't actually pass data. So try with a file instead."
            }
        }

        return true
    }
    
    @State private var hint = "Drag your QRcode image here!"
    @State private var email = ""
    @State private var isTargeted = false
    
    var body: some View {
        VStack(spacing: 0.0) {
            Rectangle()
                .fill(Color.init(.displayP3, white: 0.0, opacity: 0.0))
                .frame(height: 12.0)
            HStack {
                TextField("Email here", text: $email)
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Text("Generate")
                }
            }
            Rectangle()
            .fill(Color.init(.displayP3, white: 0.0, opacity: 0.0))
            .frame(height: 12.0)
            Text(hint)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .border(Color.init(.displayP3, white: 0.9, opacity: 0.5), width: 2.0)
                // How do I know it should be these two
                // Find kUITypeFileURL by Google then read difinition of kUTTypeFileURL
                .onDrop(of: [(kUTTypeFileURL as String), (kUTTypeImage as String)], delegate: self)
        }.frame(minWidth: 400.0, minHeight: 300.0)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
