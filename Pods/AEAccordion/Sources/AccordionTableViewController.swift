import UIKit

/**
    This class is used for accordion effect in `UITableViewController`.

    Just subclass it and implement `tableView:heightForRowAtIndexPath:`
    (based on information in `expandedIndexPaths` property).
*/
open class AccordionTableViewController: UITableView {
    
    // MARK: Properties
    
    /// Array of `IndexPath` objects for all of the expanded cells.
    open var expandedIndexPaths = [IndexPath]()
    
    /// Flag that indicates if cell toggle should be animated. Defaults to `true`.
    open var shouldAnimateCellToggle = true
    
    /// Flag that indicates if `tableView` should scroll after cell is expanded, 
    /// in order to make it completely visible (if it's not already). Defaults to `true`.
    open var shouldScrollIfNeededAfterCellExpand = true
    
    // MARK: Actions
    
    /**
        Expand or collapse the cell.
    
        - parameter cell: Cell that should be expanded or collapsed.
        - parameter animated: If `true` action should be animated.
    */
    open func toggleCell(_ cell: AccordionTableViewCell, animated: Bool) {
        if cell.expanded {
            collapseCell(cell, animated: animated)
        } else {
            expandCell(cell, animated: animated)
        }
    }
    
    // MARK: UITableViewDelegate
    
    /// `AccordionTableViewController` will set cell to be expanded or collapsed without animation.
    open  func tableView(_ tableView: UITableView,
                                 willDisplay cell: UITableViewCell,
                                 forRowAt indexPath: IndexPath) {
        if let cell = cell as? AccordionTableViewCell {
            let expanded = expandedIndexPaths.contains(indexPath)
            cell.setExpanded(expanded, animated: false)
        }
    }
    
    /// `AccordionTableViewController` will animate cell to be expanded or collapsed.
    open  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AccordionTableViewCell {
            toggleCell(cell, animated: shouldAnimateCellToggle)
        }
    }
    
    // MARK: Helpers
    
    private func expandCell(_ cell: AccordionTableViewCell, animated: Bool) {
        if let indexPath = self.indexPath(for: cell) {
            if !animated {
                cell.setExpanded(true, animated: false)
                addToExpandedIndexPaths(indexPath)
                self.reloadData()
                scrollIfNeededAfterExpandingCell(at: indexPath)
            } else {
                CATransaction.begin()
                
                CATransaction.setCompletionBlock({ () -> Void in
                    // 2. animate views after expanding
                    cell.setExpanded(true, animated: true)
                    self.scrollIfNeededAfterExpandingCell(at: indexPath)
                })
                
                // 1. expand cell height
                self.beginUpdates()
                addToExpandedIndexPaths(indexPath)
                self.endUpdates()
                
                CATransaction.commit()
            }
        }
    }
    
    private func collapseCell(_ cell: AccordionTableViewCell, animated: Bool) {
        if let indexPath = self.indexPath(for: cell) {
            if !animated {
                cell.setExpanded(false, animated: false)
                removeFromExpandedIndexPaths(indexPath)
                self.reloadData()
            } else {
                CATransaction.begin()
                
                CATransaction.setCompletionBlock({ () -> Void in
                    // 2. collapse cell height
                    self.beginUpdates()
                    self.removeFromExpandedIndexPaths(indexPath)
                    self.endUpdates()
                })
                
                // 1. animate views before collapsing
                cell.setExpanded(false, animated: true)
                
                CATransaction.commit()
            }
        }
    }
    
    private func addToExpandedIndexPaths(_ indexPath: IndexPath) {
        expandedIndexPaths.append(indexPath)
    }
    
    private func removeFromExpandedIndexPaths(_ indexPath: IndexPath) {
        if let index = expandedIndexPaths.index(of: indexPath) {
            expandedIndexPaths.remove(at: index)
        }
    }
    
    private func scrollIfNeededAfterExpandingCell(at indexPath: IndexPath) {
        guard shouldScrollIfNeededAfterCellExpand,
            let cell = self.cellForRow(at: indexPath) as? AccordionTableViewCell else {
            return
        }
        let cellRect = self.rectForRow(at: indexPath)
        let isCompletelyVisible = self.bounds.contains(cellRect)
        if cell.expanded && !isCompletelyVisible {
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

}
