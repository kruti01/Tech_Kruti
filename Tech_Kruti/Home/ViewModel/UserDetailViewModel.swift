//
//  UserDetailViewModel.swift
//  Tech_Kruti
//
//  Created by Kruti on 26/04/24.
//

import Foundation

class UserDetailViewModel {
    func getUserListData(_ page: Int, completion: @escaping (_ success: Bool, _ results: [UserDetailListModel]?, _ error: String?) -> ()) {
        
        let urlStr = URLIdentifier.userDetailURL + page.description
        APIService.shared.fetchData(from: urlStr) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    guard let responseData = data else {
                        completion(false, nil, "Error: Trying to parse data to model")
                        return
                    }
                    do {
                        let model = try JSONDecoder().decode([UserDetailListModel].self, from: responseData)
                        completion(true, model, nil)
                    } catch {
                        completion(false, nil, "Error: Trying to parse data to model")
                    }

               }
            case .failure(let failure):
                completion(false, nil, failure.localizedDescription)
            }
        }
        
    }
}
