//
//  AddEditCellTableViewController.swift
//  DebtList
//
//  Created by Ivan Komarov on 21.04.2023.
//

import UIKit

//Protocols
protocol AddEditCellTableViewControllerDelegate: AnyObject {
    func addEditCellTableViewController(_ controller: AddEditCellTableViewController, didSave debtor: Debtor)
}

class AddEditCellTableViewController: UITableViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate, InterestViewControllerDelegate {
    
    //Delegate to HomeCV
    weak var delegate: AddEditCellTableViewControllerDelegate?
    
    //Delegate from InterestVc
    func interestViewController(_ controller: InterestViewController, didSave interest: Interest) {
        self.interest = interest
        tableView.reloadData()
    }
    
    
    var interest: Interest?{
        didSet{
            guard let interest = interest else{
                interestStateLable.text = "Choose"
                interestValueLable.text = "0 %"
                return
            }
            switch interest.state{
            case .daily:
                interestStateLable.text = "Daily"
            case .mouthly:
                interestStateLable.text = "Mounthly"
            case .yearly:
                interestStateLable.text = "Yearly"
            }
            interestValueLable.text = "\(interest.percent) %"
        }
    }
    
    var debtor: Debtor?
    var totalMoney: Float?

    
    //Outlets
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var interestStateLable: UILabel!
    @IBOutlet weak var interestValueLable: UILabel!
    @IBOutlet weak var totalMoneyLable: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var debtTextField: UITextField!
    @IBOutlet weak var nameTexField: UITextField!
    @IBOutlet weak var interestSwitcher: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    
    
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
        
        //Keyboard Dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        //Set Date Restrictions
        let midnightToday = Calendar.current.startOfDay(for: Date())
        datePicker.maximumDate = midnightToday
        
        //Set Default Image
        imageView.image = UIImage(named: "crazyEmoji")
        
        updateUI()
        }

    func updateUI(){
        updateSaveButton()
        
        if let debtor = debtor{
            nameTexField.text = debtor.name
            debtTextField.text = String(debtor.debt)
            imageView.image = debtor.image
            datePicker.date = debtor.startDate
            timeLable.text = debtor.duration
            if let interest = debtor.interest{
                self.interest = interest
                interestSwitcher.isOn = true
                isInterestVisible.toggle()
            }else{
                self.interest = nil
                
            }
            self.debtor = nil
        }
        //Date & Time
        updateTime()
        updateDate()
        
        //Total
        if let debt = debtTextField.text,
           let principal = Float(debt){
            updateTotalMoney(principal: principal)
        }
    }

    //Save Button Update
    func updateSaveButton(){
        guard nameTexField.text != "",
              debtTextField.text != ""
        else{
            saveButton.isEnabled = false
            return
        }
        saveButton.isEnabled = true
    }
    
    //Total View Update
    func updateTotalMoney(principal: Float){
        guard let interest = interest else{
            totalMoneyLable.text = "\(principal) $"
            totalMoney = principal
            return
        }
        let currentDate = Date()
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day], from: datePicker.date, to: currentDate)
        
        var period: Float = 0
        switch interest.state{
        case .daily:
            period = Float(dateComponents.day!)
        case .mouthly:
            period = ceil(Float(dateComponents.day!) / 30)
        case .yearly:
            period = ceil(Float(dateComponents.day!) / 365)
        }
        let compooundInterest = pow((1 + interest.percent/100), period)
        let total = principal * compooundInterest
        let totalRounded = round(total * 100) / 100
        totalMoney = totalRounded
        totalMoneyLable.text = "\(totalRounded) $"
    }
    
    //Date View Update
    func updateDate(){
        dateLable.text = datePicker.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    //Time View Update
    func updateTime(){
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: datePicker.date, to: currentDate)
        if let years = components.year, years > 0 {
            timeLable.text = "> \(years) years"
        } else if let months = components.month, months > 0 {
            timeLable.text = "> \(months) months"
        } else if let days = components.day {
            timeLable.text = "\(days) days"
        } else {
            timeLable.text = "Less than a day"
        }
    }
    
    //DatePicker Value Changed
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateUI()
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
    //ImagePicker
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
    //ImagePicker Cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    //Switch Tougle
    @IBAction func interestSwitcherValueChanged(_ sender: UISwitch) {
        if !interestSwitcher.isOn{
            interest = nil
            updateUI()
        }
        if interest == nil{
            interest = nil
        }
        isInterestVisible.toggle()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //Unwind to Self
    @IBAction func unwindToAddDebtorTableViewController(segue: UIStoryboardSegue){
        updateUI()
        tableView.reloadData()
    }
    
    //Segue to InrerestVC
    @IBSegueAction func interestControllerShow(_ coder: NSCoder) -> InterestViewController? {
        let interestViewController = InterestViewController(coder: coder)
            interestViewController?.delegate = self
        
            return interestViewController
    }
    
    //DebtFeild Changed
    @IBAction func debtFieldChanged(_ sender: UITextField) {
        updateUI()
    }
    
    @IBAction func nameFieldChanged(_ sender: UITextField) {
        updateUI()
    }
    
    //Delegate to HomeVC
    //Save Button Tapped
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTexField.text,
              let debt = debtTextField.text,
              let time = timeLable.text,
              let total = totalMoney,
              let image = imageView.image
        else{return}
        
        let debtor = Debtor(image: image, name: name, debt: Float(debt)!, startDate: datePicker.date, interest: interest, duration: time, total: total)
        
        delegate?.addEditCellTableViewController(self, didSave: debtor)
        self.performSegue(withIdentifier: "saveUnwind", sender: self)
    }
    
    //Delegate to HomeVC
    //Cancel Button Tapped
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "cancelUnwind", sender: self)
    }
    
    //Dismiss Keyboard by Return Button
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    //Dismiss Keyboard by Gesture
    @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    
}
