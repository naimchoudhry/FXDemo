//
//  MarketsListViewController.swift
//  FXDemo
//
//  Created by Naim on 22/01/2022.
//
import UIKit
import SafariServices

class MarketsListViewController: UIViewController {
    
    var marketsViewModel = MarketsViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        marketsViewModel.marketsLoaded = { [weak self] loaded in
            guard let self = self else {return}
            if loaded {
                self.tableView.reloadData()
            } else {
                let alert = UIAlertController(title: "Attention", message: "Could not load Markets", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            }
        }
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if marketsViewModel.markets == nil {
            marketsViewModel.getMarkets()
        }
    }
    
    func setupUI() {
        tableView.register(UINib(nibName: MarketCell.identifier, bundle: nil), forCellReuseIdentifier: MarketCell.identifier)
    }
    
    func marketFor(indexPath: IndexPath) -> Market {
        guard let markets = marketsViewModel.markets else { fatalError("Missing Market for table view \(indexPath)")}
        switch indexPath.section {
        case 0: return markets.currencies[indexPath.row]
        case 1: return markets.commodities[indexPath.row]
        case 2: return markets.indices[indexPath.row]
        default: fatalError("Missing Article for table view \(indexPath)")
        }
    }
}

extension MarketsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard marketsViewModel.markets != nil else {return 0}
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let markets = marketsViewModel.markets else {return 0}
        switch section {
        case 0: return markets.currencies.count
        case 1: return markets.commodities.count
        case 2: return markets.indices.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Currencies"
        case 1: return "Commodities"
        case 2: return "Indices"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MarketCell.identifier, for: indexPath) as! MarketCell
        let market = marketFor(indexPath: indexPath)
        cell.displayLabel.text = market.displayName
        cell.epicLabel.text = market.epic
        return cell
    }
}

extension MarketsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let market = marketFor(indexPath: indexPath)
        if let url = URL(string: market.rateDetailURL)  {
            let webView = SFSafariViewController(url: url, configuration: SFSafariViewController.Configuration())
            webView.preferredControlTintColor = view.tintColor
            webView.dismissButtonStyle = .done
            present(webView, animated: true)
        }
    }
}
