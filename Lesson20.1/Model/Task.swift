import Foundation
import RealmSwift

//Так как наследуемся от другого класса Object (typealias Object = RealmSwiftObject)
//Что бы молги определить свои модели как обычные классы Swift
//Если класс объявлен как @objcMembers, вы можете объявить свойства как dynamic var без @objc.
//Class расширяет Object - используется для отношений 'один к одному'
@objcMembers class Task: Object
{
    dynamic var _id = UUID().uuidString //ObjectId.generate()
    dynamic var name = ""
    dynamic var note = ""
    dynamic var date = Date()
    dynamic var isComplete = false
    
    dynamic var assignee: String?
    dynamic var priority = 0
    dynamic var progressMinutes = 0
    
/*
    //Обратная ссылка на пользователя. Это автоматически обновляется всякий раз, когда
    //эта задача добавляется в список задач пользователя или удаляется из него.
    let assigne = LinkingObjects(fromType: Category.self, property: "tasks")
*/
 
    //Свойства только для чтения автоматически игнорируются Realm
    var descOption: String {
        return "\(name) \(note)"
    }
    
/*
    //Вернуть список игнорируемых имен свойств
    //Все работает только в newNameTask залетает - "", во все игнорируемые свойства
    override static func ignoredProperties() -> [String]
    {
        return ["note", "name"]
    }
*/
    
    override static func primaryKey() -> String?
    {
        return "_id"
    }
    
/*
     //Сюда так и не зашли (по breakpoint)
    convenience init(_id: ObjectId, name: String, note: String, date: Date, isComplete: Bool) {
        self.init()
        self._id = _id
        self.name = name
        self.note = note
        self.date = date
        self.isComplete = isComplete
    }
*/
}
