import UIKit
import RealmSwift

class CategoryTVCell: UITableViewCell
{
    var category: Category!
    
    @IBOutlet weak var titleCustom: UILabel!
    @IBOutlet weak var subTitleCustom: UILabel!
    @IBOutlet weak var detalCustom: UILabel!
    
    func configure(with category: Category)
    {
        let currentTask = category.tasks.filter("isComplete = false")
        let complitedTask = category.tasks.filter("isComplete = true")
        
        func printArray() -> String
        {
            var allTaskString = ""
            for item in currentTask {
                allTaskString += "\(item.name.firstCapitalized). "
            }
            return allTaskString
        }
        
        titleCustom.text = category.name.firstCapitalized
        subTitleCustom.text = printArray()
        
        if !currentTask.isEmpty {
            detalCustom.text = "\(currentTask.count)"
        } else if !complitedTask.isEmpty {
            detalCustom.text = "✓"
        } else {
            detalCustom.text = "0"
        }
    }
}
