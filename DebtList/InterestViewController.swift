//
//  InterestViewController.swift
//  DebtList
//
//  Created by Ivan Komarov on 22.04.2023.
//

import UIKit
protocol InterestViewControllerDelegate: AnyObject {
    func interestViewController(_ controller: InterestViewController, didSave interest: Interest)
}
class InterestViewController: UIViewController {

    weak var delegate: InterestViewControllerDelegate?
    
    var interest: Interest?{
        switch segmentedPeriodControl.selectedSegmentIndex{
        case 0:
            return Interest(state: .daily, percent: roundedValue)
        case 1:
            return Interest(state: .mouthly, percent: roundedValue)
        case 2:
            return Interest(state: .yearly, percent: roundedValue)
        default:
            return nil
        }
            
    }
    
    @IBOutlet weak var lableInterest: UILabel!
    @IBOutlet weak var sliderInterest: UISlider!
    @IBOutlet weak var segmentedPeriodControl: UISegmentedControl!
    
    
    var roundedValue:Float{
        let value = sliderInterest.value * 100
        return roundFloat(value, toDecimalPlaces: 1)
        
    }
    
    //DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        sliderInterest.value = 0.0
        updateLableView()
        
    }
    
    //Update Label text
    func updateLableView() {
        lableInterest.text = "\(roundedValue) %"
        
    }

    
    @IBAction func DoneTapped(_ sender: UIBarButtonItem) {
        if let interest = interest {
            delegate?.interestViewController(self, didSave: interest)
        }
        self.performSegue(withIdentifier: "unwindToAddEditDebt", sender: self)
    }
    
    //Slider Value Changed
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        updateLableView()
    }
    
    //Segmented controller Value changed
    @IBAction func changed(_ sender: UISegmentedControl) {
        print(interest!.state)
        updateLableView()
    }
    //Round Float
    func roundFloat(_ value: Float, toDecimalPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (value * divisor).rounded() / divisor
    }
    
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
    

}

