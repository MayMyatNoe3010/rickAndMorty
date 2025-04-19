//
//  RMLocationListView.swift
//  RickAndMorty
//
//  Created by User on 17/04/2025.
//

import UIKit
protocol RMLocationListViewDelegate: AnyObject{
    func didSelectEpisode(_ locationListView: RMLocationListView , selectedLocation location: RMLocation)
    func didScroll(_ scrollView: UIScrollView)
}

class RMLocationListView: UIView {
    //Use for footerspinner visibility
    private var shouldLoadMore: Bool = false
    private var locations: [RMLocation] = []
    weak var delegate: RMLocationListViewDelegate?
    private let tableView: UITableView = {
           let table = UITableView(frame: .zero, style: .grouped)
           table.translatesAutoresizingMaskIntoConstraints = false
           table.alpha = 0
           table.isHidden = true
           table.register(RMLocationTableViewCell.self,
                          forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
        
           return table
       }()
    private let loadingFooterView: FooterLoadingCollectionReusableView = {
            let view = FooterLoadingCollectionReusableView()
//            view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
            return view
        }()
    
    init(){
        super.init(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        addSubViews(tableView, loadingFooterView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    func updateLocations(_ locations: [RMLocation]){
        guard !locations.isEmpty else {
                print("Empty location list received!")
                return
            }

        self.locations = locations
        tableView.tableFooterView = nil
        tableView.isHidden = false
        tableView.reloadData()
        UIView.animate(withDuration: 0.4) {
            self.tableView.alpha = 1
        }

    }
    func updateShouldLoadMore(_ shouldLoad: Bool){
        self.shouldLoadMore = shouldLoad
        DispatchQueue.main.async{
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
}
extension RMLocationListView: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellIdentifier, for: indexPath) as? RMLocationTableViewCell else{
            fatalError()
        }
        cell.configure(data: locations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let location = locations[indexPath.row]
        delegate?.didSelectEpisode(self, selectedLocation: location)
    }
}
extension RMLocationListView: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableView.handleLoadMore {

            guard shouldLoadMore else { return }
            
            tableView.tableFooterView = loadingFooterView
            loadingFooterView.startAnimating()
            delegate?.didScroll(scrollView)
        }
    }
}


