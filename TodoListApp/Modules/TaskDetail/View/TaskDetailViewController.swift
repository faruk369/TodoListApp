//
//  TaskDetailViewController.swift
//  TodoListApp
//
//  Created by Faryk on 03.08.2025.
//

import UIKit

class TaskDetailViewController: UIViewController, TaskDetailViewProtocol {
    var presenter: TaskDetailPresenterProtocol?
    
    let titleLabel = UILabel()
   let descriptionLabel = UILabel()
    let dateLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // title = "Task Detail"
        setupViews()
        setupConstraints()
        presenter?.viewDidLoad()
    }
    
    private func setupViews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .boldSystemFont(ofSize: 26)
        titleLabel.numberOfLines = 0
        //titleLabel.textAlignment = .center

        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .secondaryLabel
        dateLabel.numberOfLines = 1

        descriptionLabel.font = .systemFont(ofSize: 17)
        descriptionLabel.numberOfLines = 0

        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(descriptionLabel)
    }
    
    func showTaskDetails(_ task: TaskEntity) {
        titleLabel.text = task.name
        descriptionLabel.text = task.description
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = "Created on: \(formatter.string(from: task.dateCreated))"
    }
    
}
