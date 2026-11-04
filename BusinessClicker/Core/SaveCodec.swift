import Foundation

public enum SaveCodec {
    public static func encode(_ world: World) throws -> Data {
        try Engine.validate(world)
        let encoder = JSONEncoder(); encoder.outputFormatting = [.sortedKeys]
        return try encoder.encode(world)
    }
    public static func decode(_ data: Data) throws -> World {
        guard data.count <= 64 * 1024 * 1024 else { throw GameError.invalid("Sauvegarde trop volumineuse.") }
        let world = try JSONDecoder().decode(World.self, from: data)
        try Engine.validate(world); return world
    }
}
