import UIKit
import RealmSwift

class CategoryTVC: UITableViewController
{
    //Results это коллекция - в реальном времени
    var category: Results<Category>!
    //Сохраняем notificationToken до тех пор, пока вы хотите наблюдать
    var notificationToken: NotificationToken?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Получаем живую коллекцию всех задач realm
        category = realm.objects(Category.self)//.sorted(byKeyPath: "name", ascending: false)
        title = "Списки"
        designBackground()
/*
        //Контролируем кого пропускаем на текущую вечеринку
        var config = Realm.Configuration.defaultConfiguration
        config.objectTypes = [Task.self]
*/
        
/*
        Только с типом данных UUID().uuidString
        let keyType = "8E194F93-3795-4CFD-BDA4-289A7D0B8BE6"
        let specificPerson = realm.object(ofType: Task.self, forPrimaryKey: keyType)
        print("_____________")
        print(specificPerson!)
*/
        
/*
         //Работа с фильтрами
         let sortMyValue = category.filter("name contains 'Строительный'")
         //        print(sortMyValue)
         
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy/MM/dd HH:mm"
         let startDate = formatter.date(from: "2021/03/16 02:59") //2021-03-20T02:58:41.949Z
         let currentDateTime = Date()
         
         //        let filterByTime = category.filter("date BETWEEN {%@, %@}", startDate!, currentDateTime)
         let filterByTime = category.filter("date >= %@", startDate!)
         print(filterByTime)
*/
        
/*
        //Можете изменять свойства объекта Realm внутри транзакции записи таким же образом,
        //как и любой другой объект Swift
        let lastCategory = realm.objects(Category.self).last
        try! realm.write {
            lastCategory?.name = "Valery"
        }
        let myId = "1B16406C-0EBA-4462-B847-3192387013DE"
        let lastCategoryTwo = Category(value: ["id": myId, "name": "-modified-"])

        try! realm.write {
            realm.add(lastCategoryTwo, update: .modified)
        }

         try! realm.write {
             // Find dogs younger than 2 years old.
             let puppies = currentCategory.tasks.filter("isComplete = false")
             // Delete the objects in the collection from the realm.
             realm.delete(puppies)
         }
*/
        
        //Realm уведомление
        notificationToken = category.observe { (changes) in
            switch changes {
                case .initial: break
                case .update(_, let deletions, let insertions, let modifications):
                    print("\nDeleted indices: ", deletions)
                    print("Inserted indices: ", insertions)
                    print("Modified modifications: ", modifications, "\n")
                    self.tableView.reloadData()
                case .error(let error):
                    fatalError("\(error)")
            }
        }
    }
    
    // MARK: - Navigation
    
    @IBAction func addAction(_ sender: Any)
    {
        alertForAddAndUpdateList()
    }
    
    @IBAction func didSelectSorted(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0 {
            category = category.sorted(byKeyPath: "name")
        } else {
            category = category.sorted(byKeyPath: "date")
        }
        tableView.reloadData(with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        guard let destination = segue.destination as? TasksTVC else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        destination.currentCategory = category[indexPath.row]
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return category.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTasks", for: indexPath) as! CategoryTVCell
        let categoryIndex = category[indexPath.row]
        
        cell.configure(with: categoryIndex)
        designCell(with: cell)
        return cell
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let edit = editAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        let done = doneAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit, done])
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction
    {
        let action = UIContextualAction(style: .normal, title: "edit") { (_, _, completion) in
            self.alertForAddAndUpdateList(self.category[indexPath.row]) {
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            completion(true)
        }
        action.backgroundColor = .init(red: 50 / 255, green: 183 / 255, blue: 108 / 255, alpha: 1)
        action.image = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")
        return action
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction
    {
        let action = UIContextualAction(style: .destructive, title: "delete") { (_, _, completion) in
            self.alertDeleteCategory(self.category[indexPath.row], indexPath: indexPath)
            completion(true)
        }
        action.backgroundColor = .init(red: 242 / 255, green: 86 / 255, blue: 77 / 255, alpha: 1)
        action.image = UIImage(systemName: "trash")
        return action
    }
    
    func doneAction(at indexPath: IndexPath) -> UIContextualAction
    {
        let action = UIContextualAction(style: .normal, title: "done") { (_, _, _) in
            StorageManager.makeAllDone(self.category[indexPath.row])
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        action.backgroundColor = .init(red: 50 / 255, green: 186 / 255, blue: 188 / 255, alpha: 1)
        action.image = UIImage(systemName: "checkmark")
        return action
    }
}
