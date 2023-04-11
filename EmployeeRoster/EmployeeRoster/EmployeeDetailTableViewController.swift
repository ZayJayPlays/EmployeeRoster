
import UIKit

protocol EmployeeDetailTableViewControllerDelegate: AnyObject {
    func employeeDetailTableViewController(_ controller: EmployeeDetailTableViewController, didSave employee: Employee)
}

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate, EmployeeTypeTableViewControllerDelegate  {
    func emloyeeTypeTableViewController(_: EmployeeTypeTableViewController, didSelect employeeType: EmployeeType) {
        self.employeeType = employeeType
        employeeTypeLabel.textColor = .black
        updateSaveButtonState()
        employeeTypeLabel.text = employeeType.description
    }
    

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var employeeTypeLabel: UILabel!
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet var dobDatePicker: UIDatePicker!
    
    var employeeType: EmployeeType?
    let dobLabelIndexPath = IndexPath(row: 1, section: 0)
    let dobDatePickerIndexPath = IndexPath(row: 2, section: 0)
    
    var isEditingBirthdate = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    
    weak var delegate: EmployeeDetailTableViewControllerDelegate?
    var employee: Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
        updateSaveButtonState()
        dobLabel.textColor = .label
        dobLabel.text = dobDatePicker.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    func updateView() {
        if let employee = employee {
            navigationItem.title = employee.name
            nameTextField.text = employee.name
            
            dobLabel.text = employee.dateOfBirth.formatted(date: .abbreviated, time: .omitted)
            dobLabel.textColor = .label
            employeeTypeLabel.text = employee.employeeType.description
            employeeTypeLabel.textColor = .label
        } else {
            navigationItem.title = "New Employee"
        }
    }
    
    private func updateSaveButtonState() {
        let shouldEnableSaveButton = nameTextField.text?.isEmpty == false && employeeType != nil
        saveBarButtonItem.isEnabled = shouldEnableSaveButton
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        guard let employeeType = employeeType else { return }
        
        let employee = Employee(name: name, dateOfBirth: dobDatePicker.date, employeeType: employeeType)
        delegate?.employeeDetailTableViewController(self, didSave: employee)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        employee = nil
    }

    @IBAction func nameTextFieldDidChange(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == dobDatePickerIndexPath && !isEditingBirthdate {
            return 0
        }
        else if indexPath == dobDatePickerIndexPath && isEditingBirthdate {
            return 250
        } else { return UITableView.automaticDimension }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == dobLabelIndexPath {
            isEditingBirthdate.toggle()
            dobLabel.textColor = .label
            dobLabel.text = dobDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        }
        
    }
    @IBAction func datePickerValueChanged(_ sender: Any) {
        dobLabel.text = dobDatePicker.date.formatted(date: .abbreviated, time: .omitted)
    }
    @IBSegueAction func showEmployeeTypes(_ coder: NSCoder) -> EmployeeTypeTableViewController? {
        let employeeTypeTableViewController = EmployeeTypeTableViewController(coder: coder)
        employeeTypeTableViewController?.delegate = self
        employeeTypeTableViewController?.employeeType = employeeType
        return employeeTypeTableViewController
    }
    
}
