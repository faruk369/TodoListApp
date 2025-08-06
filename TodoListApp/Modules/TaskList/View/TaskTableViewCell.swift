//
//  TaskTableViewCell.swift
//  TodoListApp
//
//  Created by Faryk on 03.08.2025.
//
import UIKit

class TaskTableViewCell: UITableViewCell {

    let completionButton = UIButton(type: .system)
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let dateLabel = UILabel()

    weak var delegate: TaskTableViewCellDelegate?
    private var currentTask: TaskObject?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupCellConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   private func setupViews() {
        completionButton.setTitleColor(.systemBlue, for: .normal)
        completionButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        completionButton.translatesAutoresizingMaskIntoConstraints = false
        completionButton.addTarget(self, action: #selector(completionButtonTapped), for: .touchUpInside)
        contentView.addSubview(completionButton)

        [titleLabel, descriptionLabel, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.numberOfLines = 0
            contentView.addSubview($0)
        }

        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.font = UIFont.systemFont(ofSize: 12)
    }

    func configure(with task: TaskObject) {
        currentTask = task
        descriptionLabel.text = task.descriptionText ?? "No description"
        dateLabel.text = format(date: task.dateCreated)

        if task.isCompleted {
            completionButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            let name = task.name ?? ""
            let attributed = NSMutableAttributedString(string: name)
            attributed.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: name.count))
            titleLabel.attributedText = attributed
        } else {
            completionButton.setImage(UIImage(systemName: "circle"), for: .normal)
            titleLabel.attributedText = nil
            titleLabel.text = task.name
        }
    }

    @objc private func completionButtonTapped() {
        guard let task = currentTask else { return }
        delegate?.didToggleCompletion(for: task)
    }

    private func format(date: Date?) -> String {
        guard let date = date else { return "No date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
