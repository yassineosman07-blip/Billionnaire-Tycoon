import Foundation
import SwiftData

enum SaveSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version { .init(1, 0, 0) }
    static var models: [any PersistentModel.Type] { [SaveRecord.self] }
    @Model final class SaveRecord {
        @Attribute(.unique) var key: String
        var payload: Data
        var previousPayload: Data?
        var updatedAt: Date
        init(payload: Data) { key = "main"; self.payload = payload; updatedAt = Date() }
    }
}
typealias SaveRecord = SaveSchemaV1.SaveRecord

enum SaveMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [SaveSchemaV1.self] }
    static var stages: [MigrationStage] { [] }
}

@MainActor final class SaveStore {
    let context: ModelContext
    private var record: SaveRecord?
    init(container: ModelContainer) { context = ModelContext(container); context.autosaveEnabled = false }
    func load() throws -> World? {
        let records = try context.fetch(FetchDescriptor<SaveRecord>())
        guard records.count <= 1 else { throw GameError.invalid("Plusieurs sauvegardes principales détectées.") }
        record = records.first
        guard let record else { return nil }
        return try SaveCodec.decode(record.payload)
    }
    func recoverPrevious() throws -> World {
        guard let data = record?.previousPayload else { throw GameError.invalid("Aucune copie précédente disponible.") }
        let world = try SaveCodec.decode(data); try save(world); return world
    }
    func save(_ world: World) throws {
        let data = try SaveCodec.encode(world)
        if let record { record.previousPayload = record.payload; record.payload = data; record.updatedAt = Date() }
        else { let new = SaveRecord(payload: data); context.insert(new); record = new }
        do { try context.save() }
        catch { context.rollback(); record = try? context.fetch(FetchDescriptor<SaveRecord>()).first; throw error }
    }
}
