//
// Created by Vladimir Sapronov on 7/1/16.
// Copyright (c) 2016 Syncloud. All rights reserved.
//

import Foundation

func getRestUrl(host: String) -> String {
    //TODO: This is needed only for compatibility with releases prior 16.06. New rest URL should be used always.
    let newRestUrl = "http://\(host):81/rest";
    if checkUrl(newRestUrl+"/id") {
        return newRestUrl;
    }
    return "http://\(host):81/server/rest";
}

func getRestWebService(host: String) -> WebService {
    return WebService(apiUrl: getRestUrl(host))
}