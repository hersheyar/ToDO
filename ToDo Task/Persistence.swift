import Foundation

struct Persistence {
    private static var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("taskgroups.json")
    }

    static func loadTaskGroups() -> [TaskGroup]? {
        do {
            let url = fileURL
            guard FileManager.default.fileExists(atPath: url.path) else { return nil }
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([TaskGroup].self, from: data)
            return decoded
        } catch {
            print("Persistence load error: \(error)")
            return nil
        }
    }

    static func saveTaskGroups(_ groups: [TaskGroup]) {
        do {
            let data = try JSONEncoder().encode(groups)
            try data.write(to: fileURL, options: [.atomic])
        } catch {
            print("Persistence save error: \(error)")
        }
    }
}
