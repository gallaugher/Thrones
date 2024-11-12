// File: HousesViewModel.swift Project: Thrones
// Created by: Prof. John Gallaugher on 11/10/24
// YouTube.com/profgallaugher  -  threads.net/john.gallaugher

import Foundation

@Observable
class HousesViewModel {
    var houses: [House] = []
    var urlString = "https://www.anapioficeandfire.com/api/houses?page=1&pageSize=50"
    var isLoading = false
    var pageNumber = 1
    let pageSize = 50
    
    func getData() async {
        guard pageNumber != 0 else { return } // Don't access more pages. You're done
        isLoading = true
        urlString = "https://www.anapioficeandfire.com/api/houses?page=\(pageNumber)&pageSize=\(pageSize)"
        print("🕸 We are accessing the url \(urlString)") // convert urlString to a special URL type
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            isLoading = false
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            // Try to decode JSON data into our own data structures
            guard let houses = try? JSONDecoder().decode([House].self, from: data) else {
                print("😡 JSON ERROR: Could not decode returned JSON data")
                isLoading = false
                return
            }
            if houses.count < pageSize {
                pageNumber = 0
            } else {
                pageNumber += 1
            }
            self.houses += houses
            print("😎 JSON returned! # of Houses: \(self.houses.count)")
            isLoading = false
        } catch {
            print("😡 ERROR: Could not get data from \(urlString).")
            isLoading = false
        }
    }
    
    func loadNextIfNeeded(house: House) async {
        guard let lastHouse = houses.last else { return }
        if house.id == lastHouse.id && pageNumber != 0 {
            Task {
                await getData()
            }
        }
    }
    
    func loadAll() async {
        guard pageNumber != 0 else {return}
        print("pageNumber = \(pageNumber)") // show each page call if you want

        await getData() // get next page of data
        await loadAll() // call loadAll again - will stop when all pages are retrieved
    }
}
