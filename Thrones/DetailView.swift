// File: DetailView.swift Project: Thrones
// Created by: Prof. John Gallaugher on 11/10/24
// YouTube.com/profgallaugher  -  threads.net/john.gallaugher

import SwiftUI

struct DetailView: View {
    let house: House
    var body: some View {
        VStack (alignment: .leading) {
            Text(house.name)
                .bold()
                .padding(.bottom)
            Text("Words:")
                .bold()
            
            if house.words == "" {
                Text("n/a")
                    .italic()
            } else {
                Text("\"\(house.words)\"")
                    .italic()
            }
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .font(.title)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(house: House(name: "House Swift", url: "", words: "Our Code is True"))
    }
}
