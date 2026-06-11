//
//  CatViewModel.swift
//  CatsAndModules_AlinaKharchenko
//
//  Created by alina on 15.05.2026.
//

import Combine
import FirebasePerformance
import Foundation
import Networking

private let catNames = [
    "Мурчик", "Барсик", "Пушок", "Рижик", "Сніжок", "Лапушок", "Бусінка",
    "Шашличок",
    "Тигр", "Лео", "Симба", "Нала", "Кіті",
    "Васька", "Мася", "Персик", "Хмаринка", "Зефір",
    "Бося", "Бублик", "Чіп", "Том", "Фелікс", "Нора", "Дейл", "Гарфілд",
]

struct CatItem: Identifiable {
    let id: String
    let cat: Cat
    let randomName: String

    init(cat: Cat) {
        self.id = cat.id
        self.cat = cat
        self.randomName = catNames.randomElement() ?? "Бусінка"
    }
}

@MainActor
final class CatViewModel: ObservableObject {

    @Published var cats: [CatItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let service: CatServiceProtocol

    init(service: CatServiceProtocol = CatAPIService()) {
        self.service = service
    }

    static func animalType() -> String {
        Bundle.main.object(forInfoDictionaryKey: "AnimalType") as? String
            ?? "CATS"
    }

    func loadCats() async {
        isLoading = true
        errorMessage = nil

        let trace = Performance.startTrace(name: "get_cats_api_call")
        let animalType = CatViewModel.animalType()

        do {
            let fetchedCats = try await service.getCats(limit: 20, animal: animalType)
            cats = fetchedCats.map { CatItem(cat: $0) }
            trace?.setValue("success", forAttribute: "status")
            trace?.incrementMetric("cats_received", by: Int64(fetchedCats.count))
        } catch {
            errorMessage = error.localizedDescription
            trace?.setValue("error", forAttribute: "status")
        }

        trace?.stop()
        isLoading = false
    }
}
