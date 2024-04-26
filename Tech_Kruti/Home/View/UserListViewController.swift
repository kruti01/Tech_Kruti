//
//  ViewController.swift
//  Tech_Kruti
//
//  Created by Kruti on 26/04/24.
//

import UIKit
import Network
class UserListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewNoInternet: UIView!
    
    private var userDetailsArray: UserDetailList = []
    var currentPage = 1
    var loadMoreData = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        // Add observer in viewDidLoad or any appropriate method
        NotificationCenter.default.addObserver(self, selector: #selector(handleInternetConnectionStatusChanged(_:)), name: .InternetConnectionStatusChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .InternetConnectionStatusChanged, object: nil)
    }
    
}

extension UserListViewController {
    @objc func handleInternetConnectionStatusChanged(_ notification: Notification) {
        if let isConnected = notification.userInfo?["isConnected"] as? Bool {
            DispatchQueue.main.async {
                if isConnected {
                    self.viewNoInternet.isHidden = true
                    if self.userDetailsArray.count > 0 {
                        self.tableView.reloadData()
                    } else {
                        self.apiCallToGetUserData(page: self.currentPage)
                    }
                    // Internet connection available
                } else {
                    self.viewNoInternet.isHidden = false
                    // No internet connection
                }
            }
        }
    }
    
    
    private func setupViews() {
        applyStyle()
        setupTableView()
        if InternetConnectionManager.shared.isConnectedToInternet {
            viewNoInternet.isHidden = true
            apiCallToGetUserData(page: 1)
        } else {
            viewNoInternet.isHidden = false
        }
    }
    
    private func applyStyle() {
        viewNoInternet.isHidden = true
    }
    
    func setupTableView() {
        self.tableView.register(UINib(nibName: CellIdentifier.userDetailCell, bundle: nil), forCellReuseIdentifier: CellIdentifier.userDetailCell)
        self.tableView.estimatedRowHeight = 80.0
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func apiCallToGetUserData(page: Int) {
        UserDetailViewModel().getUserListData(page) { success, results, error in
            if success {
                self.loadMoreData = true
                self.userDetailsArray.append(contentsOf: results ?? [])
                if results?.count ?? 0 > 0 {
                    self.tableView.reloadData()
                }
            } else {
                self.loadMoreData = false
                DispatchQueue.main.async {
                    self.showError(message: error?.description ?? "An error occurred while calling the API")
                }
            }
        }
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: StoryboardIdentifier.userDetailsVC) as? UserDetailsViewController
        vc?.userDetailListModel = userDetailsArray[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Load more data when reaching the end of the list
        if indexPath.row == self.userDetailsArray.count - 1 && self.loadMoreData {
            self.currentPage += 1
            self.apiCallToGetUserData(page: self.currentPage)
        }
    }
}

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(userDetailsArray.count)
        return userDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.userDetailCell, for: indexPath) as! UserDetailsTableViewCell
        let userDetails = userDetailsArray[indexPath.row]
        cell.configure(id: userDetails.id?.description ?? "Not available", title: userDetails.title ?? "Not available")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



