import Foundation
import RealmSwift

@objcMembers class Category: Object
{
    dynamic var id = UUID().uuidString
    dynamic var name = ""
    dynamic var date = Date()
    //Тип Данных (коллекция) самого RealmSwift
    //Чтобы объявить свойства универсальных типов LinkingObjects, List и RealmOptional, используйте let
    //List <Object> - используется для отношений 'один ко многим'
    let tasks = List<Task>()
    //Как это выглядит в самом swift
    //let tasks: [Task] = []
    
    //Индексы ускоряют выполнение запросов с использованием операторов равенства и IN в обмен на несколько более медленную запись.Индексы занимают больше места в файле области. Лучше всего добавлять индексы только при оптимизации производительности чтения для конкретных ситуаций. Только с типом данных UUID().uuidString
    override static func indexedProperties() -> [String]
    {
        return ["name"]
    }
    
    override static func primaryKey() -> String?
    {
        return "id"
    }
}
