//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Mitko Ivandjikov on 4.9.22.
//

import UIKit


enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTV = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeaderUIView?
    
    let sectionTitles:  [String] = ["Trending Movies", "Trending TV", "Popular", "Upcaming Movies", "Top rated"]
    
    
    
    
    private let homeFeedTable: UITableView = {
        
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionVIewTableViewCell.self, forCellReuseIdentifier: CollectionVIewTableViewCell.identifier)
        return table
    
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavbar()
            
        
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = headerView
        configureHeroHeaderView()
        
    }
    
    private func configureHeroHeaderView() {
        
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                
                self?.randomTrendingMovie = selectedTitle
                
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        
        }
    }
    
    private func configureNavbar() {
        var image = UIImage(named: "netflixlogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }

    

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionVIewTableViewCell.identifier, for: indexPath) as? CollectionVIewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            
            APICaller.shared.getTrendingMovies { resuls in
                switch resuls{
                case .success(let titles):
                    cell.configurre(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                }
            
            
        case Sections.TrendingTV.rawValue:
            APICaller.shared.getTrendingTvs { resuls in
                switch resuls{
                case .success(let titles):
                    cell.configurre(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                }
            
        case Sections.Popular.rawValue:
            APICaller.shared.getPopular { resuls in
                switch resuls{
                case .success(let titles):
                    cell.configurre(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                }
            
            
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcoming { resuls in
                switch resuls{
                case .success(let titles):
                    cell.configurre(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                }
            
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRated { resuls in
                switch resuls{
                case .success(let titles):
                    cell.configurre(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                }
            
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    
    
    
    
}



extension HomeViewController: CollectionVIewTableViewCellDelegate {
    func collectionVIewTableViewCellDidTapCell(_ cell: CollectionVIewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    
    }
}
