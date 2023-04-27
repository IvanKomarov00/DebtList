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

class AddEditCellTableViewController: UITableViewController, InterestViewControllerDelegate {
    
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
    @IBOutlet weak var emojiLable: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var interestStateLable: UILabel!
    @IBOutlet weak var interestValueLable: UILabel!
    @IBOutlet weak var totalMoneyLable: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var debtTextField: UITextField!
    @IBOutlet weak var nameTexField: UITextField!
    @IBOutlet weak var emojiSegmentedContoller: UISegmentedControl!
    @IBOutlet weak var interestSwitcher: UISwitch!
    
    
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
        
        
        
        //Set Date Restrictions
        let midnightToday = Calendar.current.startOfDay(for: Date())
        datePicker.maximumDate = midnightToday
        
        updateUI()
        }

    func updateUI(){
        updateSaveButton()
        
        if let _ = debtor{
            updateSegmentedController()
        }else{
            updateEmoji()
        }
        
        if let debtor = debtor{
            nameTexField.text = debtor.name
            debtTextField.text = String(debtor.debt)
            emojiLable.text = debtor.emoji
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
    
    func updateEmoji(){
        switch emojiSegmentedContoller.selectedSegmentIndex{
        case 0:
            emojiLable.text = "😇"
        case 1:
            emojiLable.text = "😡"
        default:
            emojiLable.text = "😀"
        }
    }
    func updateSegmentedController(){
        if debtor!.emoji == "😇"{
            emojiSegmentedContoller.selectedSegmentIndex = 0
        }else if debtor!.emoji == "😡"{
            emojiSegmentedContoller.selectedSegmentIndex = 1
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
              let emoji = emojiLable.text
        else{return}
        
        let debtor = Debtor(emoji: emoji, name: name, debt: Float(debt)!, startDate: datePicker.date, interest: interest, duration: time, total: total)
        
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
    @objc func dismissKeyboard(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard(scrollView)
    }
    
    @IBAction func emojiSegmentedContollerValueChanged(_ sender: UISegmentedControl) {
        updateEmoji()
    }
}
