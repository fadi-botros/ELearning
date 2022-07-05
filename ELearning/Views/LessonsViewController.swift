//
//  LessonsViewController.swift
//  ELearning
//
//  Created by fadi on 04/07/2022.
//

import UIKit

class LessonCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

struct LessonCellDequeuer: CellDequeuer {
    var paginator: PaginatedCrudViewModel<Lesson>

    func apply(cell: LessonCell, data: Lesson) {
        cell.nameLabel.text = data.title.rendered
    }
}

class LessonsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var dataSourceAndDelegate: TableViewDataSourceAndDelegateForPagination<Lesson, LessonCellDequeuer>?

    var lessonsViewModel: LessonsViewModel? {
        didSet {
            bindUI()
        }
    }

    func bindUI() {
        guard let pagination = lessonsViewModel?.pagination, let tableView = self.tableView else { return }
        self.dataSourceAndDelegate = TableViewDataSourceAndDelegateForPagination(tableView: tableView, cellDequeuer: LessonCellDequeuer(paginator: pagination))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }

}
