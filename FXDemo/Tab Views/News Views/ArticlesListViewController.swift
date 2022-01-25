//
//  ArticlesListViewController.swift
//  FXDemo
//
//  Created by Naim on 20/01/2022.
//

import UIKit

class ArticlesListViewController: UIViewController {
    
    var articlesViewModel: ArticlesViewModel = ArticlesViewModel()
    
    @IBOutlet weak var refreshArticles: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        articlesViewModel.newArticlesLoaded = { [weak self] loaded in
            guard let self = self else {return}
            self.refreshArticles.isEnabled = true
            if loaded {
                self.tableView.reloadData()
            } else {
                let alert = UIAlertController(title: "Attention", message: "Could not load new news articles", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            }
        }
        refreshArticles.isEnabled = false 
        NotificationCenter.default.addObserver(self, selector: #selector(dayChanged(notification:)), name: UIApplication.significantTimeChangeNotification, object: nil)
        setupUI()
    }
    
    @IBAction func refreshArticlesTapped(_ sender: UIBarButtonItem) {
        refreshArticles.isEnabled = false
        articlesViewModel.getArticles()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ArticleDetailViewController {
            if let article = sender as? Article {
                destination.article = article
            }
        }
    }

    func setupUI() {
        tableView.register(UINib(nibName: HeadlineImageCell.identifier, bundle: nil), forCellReuseIdentifier: HeadlineImageCell.identifier)
        tableView.register(UINib(nibName: HeadlineCell.identifier, bundle: nil), forCellReuseIdentifier: HeadlineCell.identifier)
    }
    
    @objc func dayChanged(notification: NSNotification) {
        refreshArticles.isEnabled = false
        articlesViewModel.getArticles()
    }
    
    func countOfArticles(inSection: Int) -> Int {
        guard let articles = articlesViewModel.articles else {return 0}
        switch inSection {
        case 0: return articles.topNews.count
        case 1: return articles.dailyBriefings.eu.count
        case 2: return articles.dailyBriefings.asia.count
        case 3: return articles.dailyBriefings.us.count
        case 4: return articles.technicalAnalysis.count
        case 5: return articles.specialReport.count
        default: return 0
        }
    }
    
    func articleFor(indexPath: IndexPath) -> Article {
        guard let articles = articlesViewModel.articles else { fatalError("Missing Article for table view \(indexPath)")}
        switch indexPath.section {
        case 0: return articles.topNews[indexPath.row]
        case 1: return articles.dailyBriefings.eu[indexPath.row]
        case 2: return articles.dailyBriefings.asia[indexPath.row]
        case 3: return articles.dailyBriefings.us[indexPath.row]
        case 4: return articles.technicalAnalysis[indexPath.row]
        case 5: return articles.specialReport[indexPath.row]
        default: fatalError("Missing Article for table view \(indexPath)")
        }
    }
}

extension ArticlesListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countOfArticles(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let hasArticles = countOfArticles(inSection: section) > 0 ? true : false
        switch section {
        case 0: return hasArticles ? "Top News" : nil
        case 1: return hasArticles ? "Daily Briefings EU" : nil
        case 2: return hasArticles ? "Daily Briefings Asia" : nil
        case 3: return hasArticles ? "Daily Briefings US" : nil
        case 4: return hasArticles ? "Technical Analysis" : nil
        case 5: return hasArticles ? "Special Report" : nil
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = articleFor(indexPath: indexPath)
        if let imageUrl = article.headlineImageUrl, let url = URL(string: imageUrl) {
            let cell = tableView.dequeueReusableCell(withIdentifier: HeadlineImageCell.identifier, for: indexPath) as! HeadlineImageCell
            cell.titleLabel.text = article.title
            cell.subTitleLabel.text = article.description
            cell.authorsLabel.text = "By " + (article.authors.compactMap{$0.name}).joined(separator: ", ")
            cell.thumbImageView.loadImage(at: url)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: HeadlineCell.identifier, for: indexPath) as! HeadlineCell
            cell.titleLabel.text = article.title
            cell.subTitleLabel.text = article.description
            cell.authorsLabel.text = "By " + (article.authors.compactMap{$0.name}).joined(separator: ", ")
            return cell
        }
    }
}

extension ArticlesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showArticle", sender: articleFor(indexPath: indexPath))
    }
}
