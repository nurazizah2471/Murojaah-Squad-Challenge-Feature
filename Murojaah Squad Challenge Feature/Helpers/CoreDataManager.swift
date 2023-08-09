//
//  CoreDataManager.swift
//  Murojaah Squad Challenge Feature
//
//  Created by Nur Azizah on 07/08/23.
//

import Foundation
import CoreData

class CoreDataManager {
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "Murojaah_Squad_Challenge_Feature")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error loading COre Data. \(error)")
            }
        }
        context = container.viewContext
    }
    
    //** GAME SESSION ENTITY **\\
    func addGameSessionEntity(surahTag: String, verseTag: String) {
        let newGameSessionEntity = GameSessionEntity(context: context)
        newGameSessionEntity.id = UUID()
        newGameSessionEntity.is_give_up = false
        newGameSessionEntity.surah_tag = surahTag
        newGameSessionEntity.verse_tag = verseTag
        newGameSessionEntity.created_at = Date()
        newGameSessionEntity.updated_at = Date()
    }
    
    func getGameSessionEntityById(id: NSManagedObjectID) -> GameSessionEntity? {
        do {
            return try context.existingObject(with: id) as? GameSessionEntity
        } catch {
            return nil
        }
    }
    
    func getGameSessionEntities() -> [GameSessionEntity] {
        let request: NSFetchRequest<GameSessionEntity> = GameSessionEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch let error {
            print("Error fetching in Core Data. \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteGameSessionEntity(gameSessionEntity: GameSessionEntity) {
        context.delete(gameSessionEntity)
        save()
    }
    //** REPRIMAND LOG ENTITY **\\
    //** ROOM PLAY ENTITY **\\
    func addRoomPlayEntity(name: String, limitVerses: String, surahStartRange: String, surahLastRange: String, verseStartRange: String, verseLastRange: String) {
        let newRoomPlayEntity = RoomPlayEntity(context: context)
        newRoomPlayEntity.id = UUID()
        newRoomPlayEntity.name = name
        newRoomPlayEntity.is_finished = false
        newRoomPlayEntity.limit_verses = limitVerses
        newRoomPlayEntity.surah_start_range = surahStartRange
        newRoomPlayEntity.surah_last_range = surahLastRange
        newRoomPlayEntity.verse_start_range = verseStartRange
        newRoomPlayEntity.verse_last_range = verseLastRange
        newRoomPlayEntity.created_at = Date()
        newRoomPlayEntity.updated_at = Date()
    }
    
    func getRoomPlayEntityById(id: NSManagedObjectID) -> RoomPlayEntity? {
        do {
            return try context.existingObject(with: id) as? RoomPlayEntity
        } catch {
            return nil
        }
    }
    
    func getRoomPlayEntities() -> [RoomPlayEntity] {
        let request: NSFetchRequest<RoomPlayEntity> = RoomPlayEntity.fetchRequest()
        
        do {
            return try context.fetch(request)
        } catch let error {
            print("Error fetching in Core Data. \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteRoomPlayEntity(roomPlayEntity: RoomPlayEntity) {
        context.delete(roomPlayEntity)
        save()
    }
    
    //** USER ENTITY **\\
    //** USER SCORE LOG ENTITY **\\
    
    func save() {
        do {
            try context.save()
        } catch let error {
            print("Error saving in Core Data. \(error.localizedDescription)")
        }
    }
}
