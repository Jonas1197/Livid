//
//  OverviewViewController.swift
//  Livid
//
//  Created by Jonas Gamburg on 15/05/2021.
//

import UIKit
import WidgetKit

class OverviewViewController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    
    let countriesPickerView = UIPickerView()
    
    var countries = [String]()
    
    var hstackOne: UIStackView = {
        let stackView          = UIStackView()
        stackView.axis         = .horizontal
        stackView.alignment    = .center
        stackView.distribution = .fillEqually
        stackView.alignment    = .center
        stackView.spacing      = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var hstackTwo: UIStackView = {
        let stackView          = UIStackView()
        stackView.axis         = .horizontal
        stackView.alignment    = .center
        stackView.distribution = .fillEqually
        stackView.alignment    = .center
        stackView.spacing      = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var hstackThree: UIStackView = {
        let stackView          = UIStackView()
        stackView.axis         = .horizontal
        stackView.alignment    = .center
        stackView.distribution = .fillEqually
        stackView.alignment    = .center
        stackView.spacing      = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let newCasesBubble: DataBubble = {
        let dataBubble = DataBubble()
        dataBubble.title = "New cases"
        return dataBubble
    }()
    
    let populatonBubble: DataBubble = {
        let dataBubble = DataBubble()
        dataBubble.title = "Population"
        return dataBubble
    }()
    
    let activeCasesBubble: DataBubble = {
        let dataBubble = DataBubble()
        dataBubble.title = "Active cases"
        return dataBubble
    }()
    
    let recoveredCasesBubble: DataBubble = {
        let dataBubble = DataBubble()
        dataBubble.title = "Recovered"
        return dataBubble
    }()
    
    let criticalCasesBubble: DataBubble = {
        let dataBubble = DataBubble()
        dataBubble.title = "Critical"
        return dataBubble
    }()
    
    let totalCasesBubble: DataBubble = {
        let dataBubble = DataBubble()
        dataBubble.title = "Total cases"
        return dataBubble
    }()
    
    let totalDeathsBubble: DataBubble = {
        let dataBubble = DataBubble()
        dataBubble.title = "Total deaths"
        return dataBubble
    }()
    
    @IBOutlet weak var countryNameTextField: UITextField!
    
    @IBOutlet weak var trackLabel: UILabel!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    fileprivate var pinkViewOne: UIView {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataMiner.retrieveCountryNames { [unowned self] (data) in
            self.countries = data
        }
    }

    fileprivate func setUp() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .secondarySystemBackground
        configureAppTheme()
        configureColorBand()
        addDataBubbles()
        countriesPickerView.delegate   = self
        countriesPickerView.dataSource = self
        WidgetCenter.shared.reloadAllTimelines()
        showPicker(forUITextField: countryNameTextField, withPickerView: countriesPickerView)
        retrieveAndSearch(for: GlobalDataMiner.retrievePreviouslySelectedCountry())
    }
    
    fileprivate func retrieveAndSearch(for value: String) {
        countryNameTextField.text = value
        animateRefresh()
        
    }
    
    fileprivate func configureAppTheme() {
        let appTheme = UserDefaults.standard.bool(forKey: "appTheme")
        
        if let window = UIApplication.shared.keyWindow {
            UIView.transition (with: window, duration: 0.4, options: .transitionCrossDissolve, animations: {
                window.overrideUserInterfaceStyle = appTheme == true ? .dark : .light //.light or .unspecified
            }, completion: nil)
        }
        
    }
    
    fileprivate func addDataBubbles() {
        hstackOne.addArrangedViews(views: newCasesBubble, populatonBubble)
        view.addSubview(hstackOne)
        NSLayoutConstraint.activate([
            hstackOne.topAnchor.constraint(equalTo: countryNameTextField.bottomAnchor, constant: 10),
            hstackOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            hstackOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        hstackTwo.addArrangedViews(views: activeCasesBubble, recoveredCasesBubble)
        view.addSubview(hstackTwo)
        NSLayoutConstraint.activate([
            hstackTwo.topAnchor.constraint(equalTo: hstackOne.bottomAnchor, constant: 20),
            hstackTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            hstackTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        hstackThree.addArrangedViews(views: criticalCasesBubble, totalCasesBubble)
        view.addSubview(hstackThree)
        NSLayoutConstraint.activate([
            hstackThree.topAnchor.constraint(equalTo: hstackTwo.bottomAnchor, constant: 20),
            hstackThree.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            hstackThree.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        view.addSubview(totalDeathsBubble)
        NSLayoutConstraint.activate([
            totalDeathsBubble.topAnchor.constraint(equalTo: hstackThree.bottomAnchor, constant: 20),
            totalDeathsBubble.centerXAnchor.constraint(equalTo: hstackThree.centerXAnchor)
        ])
    }
    
    fileprivate func configureColorBand() {
        pinkViewOne.fix(in: view, belowView: trackLabel, andHeight: 14)
        view.sendSubviewToBack(pinkViewOne)
    }
    
    fileprivate func showPicker(forUITextField textField: UITextField, withPickerView pickerView: UIPickerView) {
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
    
    @IBAction func refreshTapped(_ sender: UIButton) {
        animateRefresh()
    }
    
    fileprivate func animateRefresh() {
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.allowUserInteraction, .curveEaseInOut]) {
            self.newCasesBubble.backgroundView.backgroundColor       = .clear
            self.newCasesBubble.backgroundView.backgroundColor       = .systemPink
            self.populatonBubble.backgroundView.backgroundColor      = .clear
            self.populatonBubble.backgroundView.backgroundColor      = .systemPink
            self.activeCasesBubble.backgroundView.backgroundColor    = .clear
            self.activeCasesBubble.backgroundView.backgroundColor    = .systemPink
            self.recoveredCasesBubble.backgroundView.backgroundColor = .clear
            self.recoveredCasesBubble.backgroundView.backgroundColor = .systemPink
            self.criticalCasesBubble.backgroundView.backgroundColor  = .clear
            self.criticalCasesBubble.backgroundView.backgroundColor  = .systemPink
            self.totalCasesBubble.backgroundView.backgroundColor     = .clear
            self.totalCasesBubble.backgroundView.backgroundColor     = .systemPink
            self.totalDeathsBubble.backgroundView.backgroundColor    = .clear
            self.totalDeathsBubble.backgroundView.backgroundColor    = .systemPink
            
        } completion: { (didFinish) in
            if didFinish { self.findData() }
        }
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        print("<< settingsButtonTapped >>")
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        coordinator?.settingsVC(withCountriesArray: countries)
    }
    
    @IBAction func aboutButtonTapped(_ sender: UIButton) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        coordinator?.aboutVC()
    }
    
    fileprivate func findData() {
        guard let country = countryNameTextField.text else { return }
        OverviewHandler.retrieveData(forCountry: country) { [unowned self] (data) in
            self.setVisualData(fromDict: data)
        }
    }
    
    fileprivate func setVisualData(fromDict dict: [String : Any]) {
        
        if let population = dict[CKey.population] as? Int64 {
            DispatchQueue.main.async {
                self.populatonBubble.value = "\(population.formattedWithSeparator)"
            }
        } else {
            DispatchQueue.main.async {
                self.populatonBubble.value = CKey.NA
            }
        }
        
        if let newCases   = dict[CKey.newCases] as? String {
            DispatchQueue.main.async {
                self.newCasesBubble.value = newCases
            }
        } else {
            DispatchQueue.main.async {
                self.newCasesBubble.value = CKey.NA
            }
        }
        
        if let activeCases = dict[CKey.activeCases] as? Int64 {
            DispatchQueue.main.async {
                self.activeCasesBubble.value = "\(activeCases.formattedWithSeparator)"
            }
        } else {
            DispatchQueue.main.async {
                self.activeCasesBubble.value = CKey.NA
            }
        }
        
        if let recovered = dict[CKey.recoveredCases] as? Int64 {
            DispatchQueue.main.async {
                self.recoveredCasesBubble.value = "\(recovered.formattedWithSeparator)"
            }
        } else {
            DispatchQueue.main.async {
                self.recoveredCasesBubble.value = CKey.NA
            }
        }
        
        if let criticalCases = dict[CKey.criticalCases] as? Int64 {
            DispatchQueue.main.async {
                self.criticalCasesBubble.value = "\(criticalCases.formattedWithSeparator)"
            }
        } else {
            DispatchQueue.main.async {
                self.criticalCasesBubble.value = CKey.NA
            }
        }
        
        if let totalCases = dict[CKey.totalCases] as? Int64 {
            DispatchQueue.main.async {
                self.totalCasesBubble.value = "\(totalCases.formattedWithSeparator)"
            }
        } else {
            DispatchQueue.main.async {
                self.totalCasesBubble.value = CKey.NA
            }
        }
        
        if let totalDeaths   = dict[CKey.totalDeaths] as? Float {
            DispatchQueue.main.async {
                self.totalDeathsBubble.value = "\(totalDeaths.formattedWithSeparator)"
            }
        } else {
            DispatchQueue.main.async {
                self.totalDeathsBubble.value = CKey.NA
            }
        }
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        countryNameTextField.resignFirstResponder()
    }
}

extension OverviewViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        countryNameTextField.text = countries[row]
        SettingsHandler.saveCountryToGroup(with: countries[row])
        findData()
    }
}
