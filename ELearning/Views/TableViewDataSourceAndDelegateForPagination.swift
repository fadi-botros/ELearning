//
//  TableViewDataSourceAndDelegateForPagination.swift
//  ELearning
//
//  Created by fadi on 03/07/2022.
//

import UIKit

protocol CellDequeuer {
    associatedtype T
    associatedtype Cell: UITableViewCell

    var paginator: PaginatedCrudViewModel<T> { get }

    func apply(cell: Cell, data: T)
}

extension CellDequeuer {
    func dequeueCellAtRow(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch(paginator.cell(for: indexPath.row)) {
            case .dataCell(let data):
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
                apply(cell: cell, data: data)
                return cell
            case .loadingCell:
                return tableView.dequeueReusableCell(withIdentifier: "Loading", for: indexPath)
        }
    }
}

class TableViewDataSourceAndDelegateForPagination<T, Dequeuer: CellDequeuer>: AbstractPaginatedCrudView<T>, UITableViewDataSource, UITableViewDelegate {

    let cellDequeuer: Dequeuer

    init(paginator: PaginatedCrudViewModel<T>, cellDequeuer: Dequeuer) {
        self.paginator = paginator
        self.cellDequeuer = cellDequeuer
    }

    let paginator: PaginatedCrudViewModel<T>

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paginator.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellDequeuer.dequeueCellAtRow(tableView, indexPath: indexPath)
    }

}
