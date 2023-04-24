//
//  HomeScreenTableViewController.swift
//  DebtList
//
//  Created by Ivan Komarov on 21.04.2023.
//

import UIKit

class HomeScreenTableViewController: UITableViewController, AddEditCellTableViewControllerDelegate{
    func addEditCellTableViewController(_ controller: AddEditCellTableViewController, didSave debtor: Debtor) {
        print(debtor)
        if let indexPath = tableView.indexPathForSelectedRow {
            debtors.remove(at: indexPath.row)
            debtors.insert(debtor, at: indexPath.row)
        } else {
            debtors.append(debtor)
        }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    
    var debtors: [Debtor] = []
    
    //DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedDebtors = Debtor.loadDebtors(){
            debtors = savedDebtors
        }else{
            debtors = Debtor.loadDebtors()!
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
    }

    @IBAction func unwindHomeScreen(segue: UIStoryboardSegue){
        
    }
    // MARK: - Table view data source

    //Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //Rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return debtors.count
    }

    //Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DebtorShort", for: indexPath) as! HomeScreenTableViewCell

        let debtor = debtors[indexPath.row]
        
        cell.update(with: debtor)

        return cell
    }
    
    //Can Edit
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            debtors.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
    @IBSegueAction func showAddEditTableViewController(_ coder: NSCoder, sender: Any?) -> AddEditCellTableViewController? {
        let controller = AddEditCellTableViewController(coder: coder)
        
        controller?.delegate = self
        
        guard let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell)
          else {
              return controller
          }
        
        let debtor = debtors[indexPath.row]
        controller?.debtor = debtor
        
        return controller
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
