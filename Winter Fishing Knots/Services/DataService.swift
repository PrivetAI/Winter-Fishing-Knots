import Foundation

class DataService: ObservableObject {
    static let shared = DataService()

    @Published var customRigs: [CustomRig] = []

    private let rigsKey = "wfh_custom_rigs"

    init() {
        loadRigs()
    }

    // MARK: - Custom Rigs CRUD
    func loadRigs() {
        guard let data = UserDefaults.standard.data(forKey: rigsKey),
              let rigs = try? JSONDecoder().decode([CustomRig].self, from: data) else {
            customRigs = []
            return
        }
        customRigs = rigs.sorted { $0.dateCreated > $1.dateCreated }
    }

    func saveRig(_ rig: CustomRig) {
        if let idx = customRigs.firstIndex(where: { $0.id == rig.id }) {
            customRigs[idx] = rig
        } else {
            customRigs.insert(rig, at: 0)
        }
        persist()
    }

    func deleteRig(id: String) {
        customRigs.removeAll { $0.id == id }
        persist()
    }

    func updateRating(id: String, rating: Int) {
        if let idx = customRigs.firstIndex(where: { $0.id == id }) {
            customRigs[idx].rating = rating
            persist()
        }
    }

    func incrementCatch(id: String) {
        if let idx = customRigs.firstIndex(where: { $0.id == id }) {
            customRigs[idx].catchCount += 1
            customRigs[idx].lastUsed = Date()
            persist()
        }
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(customRigs) {
            UserDefaults.standard.set(data, forKey: rigsKey)
        }
    }
}
