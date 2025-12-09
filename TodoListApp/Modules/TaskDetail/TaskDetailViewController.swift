//
//  TaskDetailViewController.swift
//  TodoListApp
//
//

import UIKit

class TaskDetailViewController: UIViewController, TaskDetailViewProtocol {
    var presenter: TaskDetailPresenterProtocol?
    weak var delegate: TaskDetailToTaskListDelegate?
    
    
    let titleTextField = UITextField()
    let descriptionTextView = UITextView()
    let dateLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveTapped)
        )
        
        presenter?.viewDidLoad()
    }

    @objc func saveTapped() {
        presenter?.didTapSave(
            title: titleTextField.text ?? "",
            description: descriptionTextView.text ?? ""
        )
        
    }
    
    private func setupViews() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false

        titleTextField.font = .boldSystemFont(ofSize: 26)
        

        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .secondaryLabel
        dateLabel.numberOfLines = 1

        descriptionTextView.font = .systemFont(ofSize: 17)
        

        view.addSubview(titleTextField)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
    }
    
    //Method Overloading- where I can have two methods with the same name but different inputs
    
    //  single task
    func showTaskDetails(_ task: TaskObject) {
        titleTextField.text = task.name
        descriptionTextView.text = task.descriptionText ?? "No description"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = "Created on: \(formatter.string(from: task.dateCreated!))"
        dateLabel.textColor = .label
    }
    
    // multiple tasks
    func showTaskDetails(_ tasks: [TaskObject]) {
        
        print("Showing task details: \(tasks.count) tasks")
    }
}
