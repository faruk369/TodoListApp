//
//  TaskListView+Constraints.swift
//  TodoListApp
//
//  Created by Faryk on 01.08.2025.
//

import UIKit

extension TaskListViewController{
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchTextField.heightAnchor.constraint(equalToConstant: 44),

            
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor),

            
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 80),

            
            pencilImageView.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -16),
            pencilImageView.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            pencilImageView.heightAnchor.constraint(equalToConstant: 24),
            pencilImageView.widthAnchor.constraint(equalToConstant: 24),

            
            taskCountLabel.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor),
            taskCountLabel.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor)
        ])
    }
}
extension TaskTableViewCell{
    func setupCellConstraints() {
        NSLayoutConstraint.activate([
            completionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            completionButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            completionButton.widthAnchor.constraint(equalToConstant: 24),
            completionButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: completionButton.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}

extension TaskDetailViewController{
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),

            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}
