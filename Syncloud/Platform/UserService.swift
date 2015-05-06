import Foundation

typealias UserResult = (user: User?, error: Error?)

protocol IUserService {
    func getUser(email: String, password: String) -> UserResult
    func createUser(email: String, password: String) -> UserResult
}