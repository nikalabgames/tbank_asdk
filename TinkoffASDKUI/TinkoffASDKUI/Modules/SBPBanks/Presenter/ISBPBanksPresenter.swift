//
//  ISBPBanksPresenter.swift
//  TinkoffASDKUI
//
//  Created by Aleksandr Pravosudov on 21.12.2022.
//

protocol ISBPBanksPresenter {
    func viewDidLoad()

    func closeButtonPressed()
    func controllerDidDismissManually()

    func prefetch(for rows: [Int])

    func numberOfRows() -> Int
    func cellPresenter(for row: Int) -> ISBPBankCellPresenter

    func searchTextDidChange(to text: String)

    func didSelectRow(at index: Int)
}
