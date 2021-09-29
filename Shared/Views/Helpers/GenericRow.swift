//
//  GenericRow.swift
//  NepalEarthquakes (iOS)
//
//  Created by Anuraag on 01.10.21.
//GenericRow

import SwiftUI

struct GenericRow: View {
    var title: String
    var subtitle: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .bold()
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct GenericRow_Previews: PreviewProvider {
    static var previews: some View {
        GenericRow(title: "Title here", subtitle: "This is the subtitle here")
    }
}
