//
//  CategoryRow.swift
//  NepalEarthquakes (iOS)
//
//  Created by Anuraag on 29.09.21.
//

import SwiftUI

struct CategoryRow: View {
    var category: Earthquake.Category
    
    var body: some View {
        GenericRow(title: category.rawValue, subtitle: category.description)
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRow(category: .moderate)
    }
}
