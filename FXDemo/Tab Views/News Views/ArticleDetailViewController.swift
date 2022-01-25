//
//  ArticleDetailViewController.swift
//  FXDemo
//
//  Created by Naim on 22/01/2022.
//
import UIKit
import SafariServices

class ArticleDetailViewController: UIViewController {
    var article: Article!
    
    enum TableSection {
        case top
        case authors
        case tagsAndInstruments
    }
    
    enum TableRow {
        case articleImage(String)
        case title(String)
        case description(String)
        case tags([String])
        case author
        case instruments([String])
        case webLink
        case date
    }
    
    var tableSections: [(section: TableSection, row: [TableRow])] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        tableView.register(UINib(nibName: HeadlineImageCell.identifier, bundle: nil), forCellReuseIdentifier: HeadlineImageCell.identifier)
        tableView.register(UINib(nibName: ImageCell.identifier, bundle: nil), forCellReuseIdentifier: ImageCell.identifier)
        tableView.register(UINib(nibName: TagsCell.identifier, bundle: nil), forCellReuseIdentifier: TagsCell.identifier)
        tableView.register(UINib(nibName: SimpleTextCell.identifier, bundle: nil), forCellReuseIdentifier: SimpleTextCell.identifier)
        
        
        // Setup Table Sections & Rows
        // Top Section Rows
        var rows: [TableRow] = []
        if let imageUrl = article.articleImageUrl ?? article.headlineImageUrl {
            rows.append(.articleImage(imageUrl))
        }
        rows.append(.title(article.title))
        rows.append(.date)
        rows.append(.description(article.description))
        tableSections.append((section: .top, row: rows))
        
        // AUthors Section
        if article.authors.count > 0 {
            tableSections.append((section: .authors, row: Array(repeating: TableRow.author, count: article.authors.count)))
        }
        
        // Tags Section
        rows = []
        if article.tags.count > 0 {
            rows.append((.tags(article.tags)))
        }
        if article.instruments.count > 0 {
            rows.append(.instruments(article.instruments))
        }
        rows.append(.webLink)
        tableSections.append((section: .tagsAndInstruments, row: rows))
    }
}

extension ArticleDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSections[section].row.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableSections[section].section {
        case .top: return nil
        case .authors: return article.authors.count > 1 ? "Authors" : "Author"
        case .tagsAndInstruments: return "Tags, Instruments, Full Article"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableSections[indexPath.section].row[indexPath.row]
        switch item {
        case .articleImage(let imageUrl):
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
            cell.selectionStyle = .none
            if let url = URL(string: imageUrl) {
                cell.largeImageView.loadImage(at: url)
            } else {
                cell.largeImageView.image = nil
            }
            return cell
            
        case .title(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: SimpleTextCell.identifier, for: indexPath) as! SimpleTextCell
            cell.selectionStyle = .none
            cell.insets = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
            cell.simpleTextLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            cell.simpleTextLabel.text = title
            return cell
            
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: SimpleTextCell.identifier, for: indexPath) as! SimpleTextCell
            cell.selectionStyle = .none
            cell.insets = UIEdgeInsets(top: 4, left: 20, bottom: 10, right: 20)
            cell.simpleTextLabel.text = dateFormatter.string(from: article.displayTimestamp)
            cell.simpleTextLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            return cell
            
        case .description(let description):
            let cell = tableView.dequeueReusableCell(withIdentifier: SimpleTextCell.identifier, for: indexPath) as! SimpleTextCell
            cell.selectionStyle = .none
            cell.insets = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
            cell.simpleTextLabel.text = description
            return cell
        
        case .tags(let tags):
            let cell = tableView.dequeueReusableCell(withIdentifier: TagsCell.identifier, for: indexPath) as! TagsCell
            cell.selectionStyle = .none
            cell.tagTypeLabel.text = "Tags"
            cell.tagsListLabel.text = tags.joined(separator: ", ")
            return cell
            
        case .author:
            let cell = tableView.dequeueReusableCell(withIdentifier: HeadlineImageCell.identifier, for: indexPath) as! HeadlineImageCell
            cell.selectionStyle = .none
            let author = article.authors[indexPath.row]
            cell.titleLabel.text = author.name
            cell.subTitleLabel.text = author.title
            cell.authorsLabel.text = author.descriptionShort
            if let urlString = author.photo, let url = URL(string: urlString) {
                cell.thumbImageView.loadImage(at: url)
            } else {
                cell.thumbImageView.image = nil
            }
            return cell
            
        case .instruments(let instruments):
            let cell = tableView.dequeueReusableCell(withIdentifier: TagsCell.identifier, for: indexPath) as! TagsCell
            cell.selectionStyle = .none
            cell.tagTypeLabel.text = "Instruments"
            cell.tagsListLabel.text = instruments.joined(separator: ", ")
            return cell
            
        case .webLink:
            let cell = tableView.dequeueReusableCell(withIdentifier: SimpleTextCell.identifier, for: indexPath) as! SimpleTextCell
            cell.simpleTextLabel.textAlignment = .center
            cell.simpleTextLabel.textColor = view.tintColor
            cell.simpleTextLabel.text = "Show Full Article"
            return cell
        }
    }
}

extension ArticleDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if case .webLink = tableSections[indexPath.section].row[indexPath.row], let url = URL(string: article.url)  {
            let webView = SFSafariViewController(url: url, configuration: SFSafariViewController.Configuration())
            webView.preferredControlTintColor = view.tintColor
            webView.dismissButtonStyle = .done
            present(webView, animated: true)
        }
    }
}
