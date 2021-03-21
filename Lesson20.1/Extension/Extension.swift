import Foundation
import UIKit

extension CategoryTVC
{
    public func alertForAddAndUpdateList(_ categoryName: Category? = nil, completion: (() -> Void)? = nil)
    {
        let title = categoryName == nil ? "Новый список" : "Хотите изменить?"
        let titleButton = categoryName == nil ? "Добавить" : "Изменить"
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        let save = UIAlertAction(title: titleButton, style: .default) { _ in
            guard let newList = alert.textFields?.first?.text, !newList.isEmpty else { return }
            
            if let categoryName = categoryName {
                StorageManager.editCategory(categoryName, newName: newList)
                //Оставил поле пустым - ничего не делаем
                if completion != nil { completion!() }
            } else {
                let category = Category()
                category.name = newList
                
                StorageManager.saveCategory(category)
                self.tableView.insertRows(at: [IndexPath(row: self.category.count - 1, section: 0)], with: .automatic)
            }
        }
        
        alert.addTextField { tf in
            let list = ["Список покупок", "Список задач", "Список привычек"]
            tf.placeholder = list.randomElement()
        }
        
        if let categoryName = categoryName {
            alert.textFields?.first?.text = categoryName.name
        }
        
        alert.addAction(cancel)
        alert.addAction(save)
        present(alert, animated: true)
    }
    
    public func alertDeleteCategory(_ categoryName: Category, indexPath: IndexPath)
    {
        let title = "Удалить список\n\(categoryName.name)?"
        let alert = UIAlertController(title: title, message: "Все задачи внутри списка пропадут.\n Это действие нельзя отменить!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
            StorageManager.deleteCategory(categoryName)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }))
        present(alert, animated: true)
    }
    
    public func designBackground()
    {
        navigationController?.navigationBar.barTintColor =
            UIColor(red: 224 / 255, green: 224 / 255, blue: 224 / 255, alpha: 1)
        
        let backgroundImage = UIImage(named: "backGroundWB2")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundView = imageView
        
        //Убираем лишнии линии в таблице
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        cell.backgroundColor = .clear
    }
}

extension TasksTVC
{
    public func alertForAddAndUpdateTask(_ taskName: Task? = nil)
    {
        let title = taskName == nil ? "Новая задача" : "Хотите изменить?"
        let titleButton = taskName == nil ? "Добавить" : "Изменить"
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        let save = UIAlertAction(title: titleButton, style: .default) { _ in
            guard let newTask = alert.textFields?.first?.text, !newTask.isEmpty else { return }
            
            if let taskName = taskName {
                if let newNote = alert.textFields?.last?.text, !newNote.isEmpty {
                    StorageManager.editTask(taskName, newName: newTask, newNote: newNote)
                } else {
                    StorageManager.editTask(taskName, newName: newTask, newNote: "")
                }
                self.sortingOpenOrComplited()
            } else {
                let task = Task()
                task.name = newTask
                
                if let note = alert.textFields?.last?.text, !note.isEmpty {
                    task.note = note
                }
                
                StorageManager.saveTask(self.currentCategory, task: task)
                self.sortingOpenOrComplited()
            }
        }
        
        alert.addTextField { tf in
            let list = ["Яйцо", "Молоко", "Печенька", "Вкусняшка"]
            tf.placeholder = list.randomElement()
            
            if let taskName = taskName {
                alert.textFields?.first?.text = taskName.name
            }
        }
        alert.addTextField { tf in
            let list = ["Количество шт.", "Описание"]
            tf.placeholder = list.randomElement()
            
            if let taskName = taskName {
                alert.textFields?.last?.text = taskName.note
            }
        }

        alert.addAction(cancel)
        alert.addAction(save)
        self.present(alert, animated: true)
    }
    
    public func designBackgroundTask()
    {
        navigationController?.navigationBar.barTintColor =
            UIColor(red: 224 / 255, green: 224 / 255, blue: 224 / 255, alpha: 1)
        
        let backgroundImage = UIImage(named: "backGroundWB2")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundView = imageView
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
        
        //Убираем лишнии линии в таблице
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        cell.backgroundColor = .clear
    }
}

func designCell(with cell: CategoryTVCell)
{
    cell.titleCustom.layer.shadowOffset = CGSize(width: 1, height: 1)
    cell.titleCustom.layer.shadowRadius = 7
    cell.titleCustom.layer.shadowOpacity = 1
    cell.titleCustom.layer.shadowColor = .init(red: 224 / 255, green: 224 / 255, blue: 224 / 255, alpha: 1)
    
    cell.subTitleCustom.layer.shadowOffset = CGSize(width: 1, height: 1)
    cell.subTitleCustom.layer.shadowRadius = 7
    cell.subTitleCustom.layer.shadowOpacity = 1
    cell.subTitleCustom.layer.shadowColor = .init(red: 224 / 255, green: 224 / 255, blue: 224 / 255, alpha: 1)
    
    cell.detalCustom.layer.shadowOffset = CGSize(width: 1, height: 1)
    cell.detalCustom.layer.shadowRadius = 7
    cell.detalCustom.layer.shadowOpacity = 1
    cell.detalCustom.layer.shadowColor = .init(red: 224 / 255, green: 224 / 255, blue: 224 / 255, alpha: 1)
}

extension StringProtocol
{
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}

extension CategoryTVC
{
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return  70 //UITableView.automaticDimension
    }
}

extension UITableView
{
    func reloadData(with animation: UITableView.RowAnimation)
    {
        reloadSections(IndexSet(integersIn: 0..<numberOfSections), with: animation)
    }
}
