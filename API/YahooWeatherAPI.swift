//
//  YahooWeatherAPI.swift
//  Weather API Sample Code
//
//  Copyright 2019 Oath Inc. Licensed under the terms of the zLib license see https://opensource.org/licenses/Zlib for terms.
//
import Foundation
/*
 See https://github.com/OAuthSwift/OAuthSwift for information on
 including this OAuth library in your project.
 */
import OAuthSwift

enum YahooWeatherAPIResponseType:String {
    case json = "json"
    case xml = "xml"
}

enum YahooWeatherAPIUnitType:String {
    case imperial = "f"
    case metric = "c"
}

fileprivate struct YahooWeatherAPIClientCredentials {
    var appId = "E72OiT32"
    var clientId = "dj0yJmk9SWlHdExuMXJMcmRjJmQ9WVdrOVJUY3lUMmxVTXpJbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmc3Y9MCZ4PThl"
    var clientSecret = "66cc6108aa75af29366049dc0617b82a387670ea"
}

class YahooWeatherAPI {
    // Configure the following with your values.
    private let credentials = YahooWeatherAPIClientCredentials(appId: "E72OiT32", clientId: "dj0yJmk9SWlHdExuMXJMcmRjJmQ9WVdrOVJUY3lUMmxVTXpJbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmc3Y9MCZ4PThl", clientSecret: "66cc6108aa75af29366049dc0617b82a387670ea")
    
    private let url:String = "https://weather-ydn-yql.media.yahoo.com/forecastrss"
    private let oauth:OAuth1Swift?
    
    public static let shared = YahooWeatherAPI()
    
    private init() {
        self.oauth = OAuth1Swift(consumerKey: self.credentials.clientId, consumerSecret: self.credentials.clientSecret)
        print(self.oauth as Any)
    }
    
    private var headers:[String:String] {
        return [
            "E72OiT32": self.credentials.appId
        ]
    }
    
    /// Requests weather data by location name.
    ///
    /// - Parameters:
    ///   - location: the name of the location, i.e. sunnyvale,ca
    ///   - failure: failure callback
    ///   - success: success callback
    ///   - responseFormat: .xml or .json. default is .json.
    ///   - unit: metric or imperial units. default = .imperial
    
    public func weather(location:String, failure: @escaping (_ error: OAuthSwiftError) -> Void, success: @escaping (_ response: OAuthSwiftResponse) -> Void, responseFormat:YahooWeatherAPIResponseType = .json, unit:YahooWeatherAPIUnitType = .imperial) {
        self.makeRequest(parameters: ["location":location, "format":responseFormat.rawValue, "u":unit.rawValue], failure: failure, success: success)
    }
    
    
    /// Requests weather data by woeid (Where on Earth ID)
    ///
    /// - Parameters:
    ///   - woeid: The location's woeid
    ///   - failure: failure callback
    ///   - success: success callback
    ///   - responseFormat: .xml or .json. default is .json.
    ///   - unit: metric or imperial units. default = .imperial
    
    public func weather(woeid:String, failure: @escaping (_ error: OAuthSwiftError) -> Void, success: @escaping (_ response: OAuthSwiftResponse) -> Void, responseFormat:YahooWeatherAPIResponseType = .json, unit:YahooWeatherAPIUnitType = .imperial) {
        self.makeRequest(parameters: ["woeid":woeid, "format":responseFormat.rawValue, "u":unit.rawValue], failure: failure, success: success)
    }
    
    
    /// Requests weather data by latitude and longitude
    ///
    /// - Parameters:
    ///   - lat: latitude
    ///   - lon: longiture
    ///   - failure: failure callback
    ///   - success: success callback
    ///   - responseFormat: .xml or .json. default is .json.
    ///   - unit: metric or imperial units. default = .imperial
    public func weather(lat:String, lon:String, failure: @escaping (_ error: OAuthSwiftError) -> Void, success: @escaping (_ response: OAuthSwiftResponse) -> Void, responseFormat:YahooWeatherAPIResponseType = .json, unit:YahooWeatherAPIUnitType = .imperial) {
        self.makeRequest(parameters: ["lat":lat, "lon":lon, "format":responseFormat.rawValue, "u":unit.rawValue], failure: failure, success: success)
    }
    
    
    /// Performs the API request with the OAuthSwift client
    ///
    /// - Parameters:
    ///   - parameters: Any URL parameters to pass to the endpoint.
    ///   - failure: failure callback
    ///   - success: success callback
    private func makeRequest(parameters:[String:String], failure: @escaping (_ error: OAuthSwiftError) -> Void, success: @escaping (_ response: OAuthSwiftResponse) -> Void) {
        
        self.oauth?.client.request(self.url, method: .GET, parameters: parameters, headers: self.headers, body: nil, checkTokenExpiration: true, completionHandler: {result in
                switch result {
                case .success(let resonse):
                    success(resonse)
                case .failure(let error):
                    failure(error)
                }
        })
	}
    
}

