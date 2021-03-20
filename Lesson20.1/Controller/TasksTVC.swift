import UIKit
import RealmSwift

class TasksTVC: UITableViewController
{
    var currentCategory: Category! {
        didSet {
            self.title = currentCategory.name.firstCapitalized
        }
    }
    
    private var openTasks: Results<Task>!
    private var completedTasks: Results<Task>!
    private var tasksBySection: Task!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        sortingOpenOrComplited()
        designBackgroundTask()
        
    }
    
    // MARK: - Navigation
    
    func sortingOpenOrComplited()
    {
        openTasks = currentCategory.tasks.filter("isComplete = false")
        completedTasks = currentCategory.tasks.filter("isComplete = true")

        tableView.reloadData()
//        tableView.reloadData(with: .automatic)
    }
    @IBAction func addTaskAction(_ sender: Any)
    {
        alertForAddAndUpdateTask()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return section == 0 ? openTasks.count : completedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return section == 1 ? "завершенные" : nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellItem", for: indexPath)
        tasksBySection(at: indexPath)
        
        cell.textLabel?.text = tasksBySection.name.firstCapitalized
        cell.detailTextLabel?.text = "\(tasksBySection._id) \(tasksBySection.note.lowercased())"
        //tasksBySection.note.lowercased()
        
        cell.accessoryType = tasksBySection.isComplete ? .checkmark : .none
        
        return cell
    }
    
    func tasksBySection(at indexPath: IndexPath)
    {
        tasksBySection = indexPath.section == 0 ? openTasks[indexPath.row] : completedTasks[indexPath.row]
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tasksBySection(at: indexPath)
        StorageManager.makeDone(tasksBySection)
        sortingOpenOrComplited()
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneTask(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let edit = editAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction
    {
        tasksBySection(at: indexPath)
        let action = UIContextualAction(style: .normal, title: "edit") { (_, _, completion) in
            self.alertForAddAndUpdateTask(self.tasksBySection)
            completion(true)
        }
        action.backgroundColor = .init(red: 50 / 255, green: 183 / 255, blue: 108 / 255, alpha: 1)
        action.image = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")
        return action
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction
    {
        tasksBySection(at: indexPath)
        let action = UIContextualAction(style: .destructive, title: "delete") { (_, _, _) in
            StorageManager.deleteTask(self.tasksBySection)
            self.sortingOpenOrComplited()
        }
        action.backgroundColor = .init(red: 242 / 255, green: 86 / 255, blue: 77 / 255, alpha: 1)
        action.image = UIImage(systemName: "trash")
        return action
    }
    
    func doneTask(at indexPath: IndexPath) -> UIContextualAction
    {
        tasksBySection(at: indexPath)
        let action = UIContextualAction(style: .normal, title: "done") { (_, _, _) in
            StorageManager.makeDone(self.tasksBySection)
            self.sortingOpenOrComplited()
        }
        action.backgroundColor = .init(red: 50 / 255, green: 186 / 255, blue: 188 / 255, alpha: 1)
        action.image = UIImage(systemName: "checkmark")
        return action
    }
}
