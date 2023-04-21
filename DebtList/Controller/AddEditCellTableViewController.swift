//
//  AddEditCellTableViewController.swift
//  DebtList
//
//  Created by Ivan Komarov on 21.04.2023.
//

import UIKit

class AddEditCellTableViewController: UITableViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var totalMoneyLable: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var debtTextField: UITextField!
    @IBOutlet weak var nameTexField: UITextField!
    @IBOutlet weak var interestSwitcher: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    
    var debtor: [Debtor]?
    
    //Date properties
    let dateLableIndexPath = IndexPath(row: 0, section: 4)
    let datePickerIndexPath = IndexPath(row: 1, section: 4)
    var isDatePickerVisible: Bool = false {
        didSet {
            datePicker.isHidden = !isDatePickerVisible
        }
    }
    //Interest properties
    var isInterestVisible: Bool = false
    let interestSwitcherIndexPath = IndexPath(row: 0, section: 3)
    let interestActiveCellIndexPath = IndexPath(row: 1, section: 3)
    
    //DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        let midnightToday = Calendar.current.startOfDay(for: Date())
        datePicker.maximumDate = midnightToday
        updateDate()
        updateTime()
        }

    
    func updateTotalMoney(){
        totalMoneyLable.text = ""
    }
    
    ///DATE
    func updateDate(){
        dateLable.text = datePicker.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    func updateTime(){
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: datePicker.date, to: currentDate)
        if let years = components.year, years > 0 {
            timeLable.text = "more than \(years) years"
        } else if let months = components.month, months > 0 {
            timeLable.text = "more than \(months) months"
        } else if let days = components.day {
            timeLable.text = "\(days) days"
        } else {
            timeLable.text = "Less than a day"
        }
        
    }
    //DatePicker Value Changed
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDate()
        updateTime()
    }
    
    //Show Cell
    override func tableView(_ tableView: UITableView,
       estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath == datePickerIndexPath{
            return 190
        }
        else if indexPath == interestSwitcherIndexPath{
            return 45
        }
        else{
            return UITableView.automaticDimension
        }
        
    }
    
    //Hide Cell
    override func tableView(_ tableView: UITableView,
       heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath == datePickerIndexPath &&
            isDatePickerVisible == false{
                return 0
        }
        else if indexPath == interestActiveCellIndexPath && isInterestVisible == false{
            return 0
        }
        else{
            return UITableView.automaticDimension
        }
    }
    
    //Logic Hide/Show Cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == dateLableIndexPath{
            isDatePickerVisible.toggle()
        }
        else{
            return
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //Add Photo
    @IBAction func addPhoto(_ sender: UIButton) {
        let alert = UIAlertController(title: "Chose Image", message: nil, preferredStyle: .actionSheet)
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        ///Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        
        ///PhotoLibrary Action
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler:{
                action in imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alert.addAction(photoLibraryAction)
        }
        
        
        ///Camera Action
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {action in imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            })
            
            alert.addAction(cameraAction)
        }
        
        
        
        alert.popoverPresentationController?.sourceView = sender
        present(alert, animated: true)
    
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Set selected image
        if let imageSelected = info[.editedImage] as? UIImage{
            imageView.image = imageSelected
        }
        //Remain image
        if let imageSelected = info[.originalImage] as? UIImage{
            imageView.image = imageSelected
        }
    
        dismiss(animated: true)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func interestSwitcherValueChanged(_ sender: UISwitch) {
        isInterestVisible.toggle()

        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
