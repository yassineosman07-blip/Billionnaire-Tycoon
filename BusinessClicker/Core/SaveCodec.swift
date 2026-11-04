import Foundation

public enum SaveCodec {
    public static func encode(_ world: World) throws -> Data {
        try Engine.validate(world)
        let encoder = JSONEncoder(); encoder.outputFormatting = [.sortedKeys]
        return try encoder.encode(world)
    }
    public static func decode(_ data: Data) throws -> World {
        guard data.count <= 64 * 1024 * 1024 else { throw GameError.invalid("Sauvegarde trop volumineuse.") }
        var world = try JSONDecoder().decode(World.self, from: data)
        guard world.version == 2, world.businesses.allSatisfy({ Catalog.businesses.indices.contains($0.definitionID) && ($0.location == nil || Catalog.districts.indices.contains($0.location!)) }) else { throw GameError.invalid("Type d’établissement ou version invalide.") }
        var occupied = Set(world.businesses.compactMap(\.plot))
        for i in world.businesses.indices where world.businesses[i].plot == nil {
            let district = world.businesses[i].districtID
            guard let plot = (district * 24..<(district + 1) * 24).first(where: { !occupied.contains($0) }) else { throw GameError.invalid("Aucun emplacement disponible pour migrer l’établissement.") }
            world.businesses[i].plot = plot; occupied.insert(plot)
        }
        try Engine.validate(world); return world
    }
}
