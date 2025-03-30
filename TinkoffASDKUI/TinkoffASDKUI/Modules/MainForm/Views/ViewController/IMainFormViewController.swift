//
//  IMainFormViewController.swift
//  TinkoffASDKUI
//
//  Created by r.akhmadeev on 19.01.2023.
//

import Foundation

protocol IMainFormViewController: AnyObject {
    func showSkeleton()
    func hideSkeleton()
    func showCommonSheet(state: CommonSheetState, animatePullableContainerUpdates: Bool)
    func hideCommonSheet()
    func reloadData()
    func insertRows(at indexPaths: [IndexPath])
    func deleteRows(at indexPaths: [IndexPath])
    func hideKeyboard()
    func closeView()
    func disableInteraction()
    func enableInteraction()
}

// MARK: - IMainFormViewController + Helpers

extension IMainFormViewController {
    func showCommonSheet(state: CommonSheetState) {
        showCommonSheet(state: state, animatePullableContainerUpdates: true)
    }

    func insertRow(at indexPath: IndexPath) {
        insertRows(at: [indexPath])
    }

    func deleteRow(at indexPath: IndexPath) {
        deleteRows(at: [indexPath])
    }
}
