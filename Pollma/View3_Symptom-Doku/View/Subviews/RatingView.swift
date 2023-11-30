//
//  RatingView.swift
//  Pollma
//
//  Created by Lukas Bröning.
//

import SwiftUI

// MARK: - Subview RatingView
struct RatingView: View {
    
    @Binding var rating: Int
    @State var usesStarIcon: Bool
    @State private var label = ""
    @State private var maxRating = 6
    @State private var offImage: Image?
    
    // BODY
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            
            ForEach(1..<maxRating) { number in
                self.getIconFor(number: number)
                    .foregroundColor(number > self.rating ? Color.gray : CustomColor.primary)
                    .onTapGesture {
                        self.rating = number
                    }
            }
        }
    }
    
    
    // MARK: - Get Rating Icon
    private func getIconFor(number: Int) -> Image {
        if number > rating {
            return offImage ?? Image(systemName: usesStarIcon ? "star.fill" : "circle.dashed.inset.fill")
        } else {
            return Image(systemName: usesStarIcon ? "star.fill" : "circle.dashed.inset.fill")
        }
    }
}


// MARK: - Preview
struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(3), usesStarIcon: true)
    }
}
