import XCTest
import SwiftData
@testable import BusinessClicker

@MainActor final class PersistenceTests: XCTestCase {
    func testSwiftDataSaveAndReopen() throws {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".store")
        defer { for suffix in ["", "-wal", "-shm"] { try? FileManager.default.removeItem(atPath: url.path + suffix) } }
        let schema = Schema(versionedSchema: SaveSchemaV1.self)
        let configuration = ModelConfiguration(schema: schema, url: url)
        var expected = World(now: Date(timeIntervalSince1970: 1800000000))
        expected.cash = 100000; try Engine.buyProperty(&expected, id: 0)
        try Engine.order(&expected, ingredient: 0, quantity: 20, supplier: 0)
        try Engine.schedule(&expected, person: 0, inDays: 1, prepared: true)
        try Engine.advance(&expected)
        do {
            let container = try ModelContainer(for: schema, migrationPlan: SaveMigrationPlan.self, configurations: [configuration])
            let store = SaveStore(container: container); _ = try store.load(); try store.save(expected)
        }
        let reopened = try ModelContainer(for: schema, migrationPlan: SaveMigrationPlan.self, configurations: [configuration])
        let restored = try SaveStore(container: reopened).load()
        XCTAssertEqual(restored, expected)
    }
    func testPreviousPayloadRecoveryAndCorruptDataProtection() throws {
        let container = try ModelContainer(for: Schema(versionedSchema: SaveSchemaV1.self), configurations: [ModelConfiguration(isStoredInMemoryOnly: true)])
        let store = SaveStore(container: container); _ = try store.load()
        let first = World(); try store.save(first)
        var second = first; try Engine.advance(&second); try store.save(second)
        let record = try XCTUnwrap(store.context.fetch(FetchDescriptor<SaveRecord>()).first)
        record.payload = Data("broken".utf8); try store.context.save()
        XCTAssertThrowsError(try store.load())
        XCTAssertEqual(try store.recoverPrevious(), first)
    }
}
