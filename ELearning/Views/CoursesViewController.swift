//
//  CoursesViewController.swift
//  ELearning
//
//  Created by fadi on 03/07/2022.
//

import UIKit

class CourseCell: UITableViewCell {
    @IBOutlet weak var courseNameLabel: UILabel!
}

struct CoursesCellDequeuer: CellDequeuer {
    typealias T = Course

    typealias Cell = CourseCell

    var paginator: PaginatedCrudViewModel<T>

    func apply(cell: Cell, data: T) {
        cell.courseNameLabel.text = data.title.rendered
    }


}

class CoursesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var dataSourceAndDelegate: TableViewDataSourceAndDelegateForPagination<Course, CoursesCellDequeuer>?

    var coursesViewModel: CoursesViewModel? {
        didSet {
            bindUI()
        }
    }

    func bindUI() {
        guard let pagination = coursesViewModel?.pagination, let tableView = self.tableView else {
            return
        }
        let dataSourceAndDelegate = TableViewDataSourceAndDelegateForPagination(tableView: tableView, paginator: pagination, cellDequeuer: CoursesCellDequeuer(paginator: pagination))
        pagination.view = dataSourceAndDelegate
        tableView.dataSource = dataSourceAndDelegate
        tableView.delegate = dataSourceAndDelegate
        self.dataSourceAndDelegate = dataSourceAndDelegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }

}
