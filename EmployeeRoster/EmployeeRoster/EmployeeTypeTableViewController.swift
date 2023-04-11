//
//  EmployeeTypeTableViewController.swift
//  EmployeeRoster
//
//  Created by Zane Jones on 3/15/23.
//

import UIKit

protocol EmployeeTypeTableViewControllerDelegate {
    func emloyeeTypeTableViewController(_: EmployeeTypeTableViewController, didSelect employeeType: EmployeeType)
}

class EmployeeTypeTableViewController: UITableViewController, EmployeeDetailTableViewControllerDelegate {
    
    var employeeType: EmployeeType?
    
    func employeeDetailTableViewController(_ controller: EmployeeDetailTableViewController, didSave employee: Employee) {
        
    }
    
    
    
    var delegate: EmployeeTypeTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EmployeeType.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        employeeType = EmployeeType.allCases[indexPath.row]
        if let employeeType = employeeType {
            self.delegate?.emloyeeTypeTableViewController(self, didSelect: employeeType)
        }
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeType", for: indexPath)
        let type = EmployeeType.allCases[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = type.description
        cell.contentConfiguration = content
        
        if employeeType == type {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}

