//
//  InterestViewController.swift
//  DebtList
//
//  Created by Ivan Komarov on 22.04.2023.
//

import UIKit

//Protocols
protocol InterestViewControllerDelegate: AnyObject {
    func interestViewController(_ controller: InterestViewController, didSave interest: Interest)
}

class InterestViewController: UIViewController {

    //Delegate to AddEditVC
    weak var delegate: InterestViewControllerDelegate?
    
    //Interest
    var interest: Interest{
        switch segmentedPeriodControl.selectedSegmentIndex{
        case 0:
            return Interest(state: .daily, percent: roundedValue)
        case 1:
            return Interest(state: .mouthly, percent: roundedValue)
        default:
            return Interest(state: .yearly, percent: roundedValue)
        }
    }
    
    //Outlets
    @IBOutlet weak var lableInterest: UILabel!
    @IBOutlet weak var sliderInterest: UISlider!
    @IBOutlet weak var segmentedPeriodControl: UISegmentedControl!
    
    //Percent
    var roundedValue:Float{
        let value = sliderInterest.value * 100
        return roundFloat(value, toDecimalPlaces: 1)
    }
    
    //DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Reset Slider
        sliderInterest.value = 0.0
        
        updateLableView()
    }
    
    //Update Label text
    func updateLableView() {
        lableInterest.text = "\(roundedValue) %"
    }
    
    //Round Float
    func roundFloat(_ value: Float, toDecimalPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (value * divisor).rounded() / divisor
    }

    //Delegate to AddEditVC
    //Done Button Tapped
    @IBAction func DoneTapped(_ sender: UIBarButtonItem) {
        delegate?.interestViewController(self, didSave: interest)
        self.performSegue(withIdentifier: "unwindToAddEditDebt", sender: self)
    }
    
    //Slider Value Changed
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        updateLableView()
    }
    
    //Segmented controller Value changed
    @IBAction func changed(_ sender: UISegmentedControl) {
        updateLableView()
    }
}

