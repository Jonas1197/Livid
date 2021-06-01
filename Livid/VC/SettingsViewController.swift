//
//  SettingsViewController.swift
//  Livid
//
//  Created by Jonas Gamburg on 15/05/2021.
//

import UIKit
import StoreKit
import WidgetKit

class SettingsViewController: UIViewController, Storyboarded {
        
    
    weak var coordinator: MainCoordinator?
    
    var countries: [String]!
    
    let purchaseID = "TESTTESTTESTTESTTEST"
    
    let countriesPickerView = UIPickerView()
    
    @IBOutlet weak var widgitEnabledDesc: UILabel!
    
    @IBOutlet weak var darkThemeDesc: UILabel!
    
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var widgitEnabledSwitch: UISwitch!
    
    @IBOutlet weak var darkThemeEnabledSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        //SKPaymentQueue.default().add(self)
    }
    
    @IBAction func widgitEnabled(_ sender: UISwitch) {
        // if app was purchased then dispaly information else dont.
    }
    
    @IBAction func donatePressed(_ sender: UIButton) {
        print("<< donatePressed >>")
        
        if SKPaymentQueue.canMakePayments() {
            let transactionRequest = SKMutablePayment()
            transactionRequest.productIdentifier = purchaseID
            SKPaymentQueue.default().add(transactionRequest)
        } else {
            print("The user cannot make any transactions!")
        }
    }
    
    
    @IBAction func darkThemeEnabled(_ sender: UISwitch) {
        SettingsHandler.handleDarkThemeSwitch(for: sender)
    }
    
    private func setUp() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .secondarySystemBackground
        countriesPickerView.delegate   = self
        countriesPickerView.dataSource = self
        countryTextField.text = UserDefaults.getDataForWidget().0
        showPicker(forUITextField: countryTextField, withPickerView: countriesPickerView)
        SettingsHandler.configureForceDarkThemeSwitch(for: darkThemeEnabledSwitch)
    }
    
    
    
    private func showPicker(forUITextField textField: UITextField, withPickerView pickerView: UIPickerView) {
        pickerView.tag = textField.tag
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePickerPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelDatePickerPressed))
        
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
    
        textField.inputAccessoryView = toolbar
        textField.inputView = pickerView
    }
    
    @objc func doneDatePickerPressed() {
        view.endEditing(true)
    }
    
    @objc func cancelDatePickerPressed() {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        countryTextField.resignFirstResponder()
    }
    
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reloadWidget(with: countries[row])
    }
    
    private func reloadWidget(with country: String) {
        if country != AppEssentials.emptyCountry {
            countryTextField.text = country
            findData(for: country)
        }
    }
    
    private func findData(for country: String) {
        OverviewHandler.retrieveData(forCountry: country) { (data) in
            let country  = data[CKey.country] as? String ?? "N/A"
            let newCases = data[CKey.newCases] as? String ?? "+0"
            
            UserDefaults.save(country: country, newCases: newCases)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}


extension SettingsViewController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        let generator = UINotificationFeedbackGenerator()
        var title = ""
        var body  = ""
        let done  = "Done"
        var show  = false
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                title = AlertConstants.transactionSuccessTitle
                body  = AlertConstants.transactionSuccessBody
                generator.notificationOccurred(.success)
                show  = true
    
            case .failed:
                title = AlertConstants.transactionFailedTitle
                body  = AlertConstants.transactionFailedBody
                generator.notificationOccurred(.error)
                show  = true
                
            case .purchasing:
                title = AlertConstants.purchaseInProgressTitle
                body  = AlertConstants.purchaseInProgressBody
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                
            case .restored:
                title = AlertConstants.purchaseRestoredTitle
                body  = AlertConstants.purchaseRestoredBody
                generator.notificationOccurred(.success)
                show  = true
                
            case .deferred:
                title = AlertConstants.purchseDeferredTitle
                body  = AlertConstants.purchaseDeferredBody
                generator.notificationOccurred(.warning)
                
            default:
                title = AlertConstants.purchaseWentWrongTitle
                body  = AlertConstants.purchaseWentWrongBody
                generator.notificationOccurred(.error)
                show  = true
            }
        }
        
        if show {
        presentAlert(withTitle: title, alertBody: body, doneButton: done)
            show = false
        }
    }
}
