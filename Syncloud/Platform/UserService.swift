import Foundation

typealias UserResult = (user: User?, error: Error?)

protocol IUserService {
    func getUser(_ email: String, password: String) -> UserResult
    func createUser(_ email: String, password: String) -> UserResult
}
