import Foundation

func quotedCmd(arguments: [String]) -> String {
    return join(" ", arguments)
}

class SshRunner {
    
    func run(connectionPoint: ConnectionPoint, command: [String]) -> (result: String?, error: Error?) {
        var quotedCommand = quotedCmd(command)
        var endpoint = connectionPoint.endpoint
        var credentials = connectionPoint.credentials
        
        var session = NMSSHSession(host: endpoint.host, port: endpoint.port, andUsername: credentials.login)
        
        if !session.connect() {
            return (result: nil, error: Error("Unable to connect"))
        }
        
        if (credentials.password != nil) {
            if !session.authenticateByPassword(credentials.password!) {
                return (result: nil, error: Error("Authentication failed"))
            }
        }
        
        var error: NSErrorPointer = nil
        var result = session.channel.execute(quotedCommand, error: error)
        
        session.disconnect()
        
        if error != nil {
            return (result: nil, error: Error("Error happened"))
        }
        
        return (result: result, error: nil)
    }
    
    func runJson(connectionPoint: ConnectionPoint, command: [String]) -> JsonResult {
        let (result, error) = self.run(connectionPoint, command: command)
        
        if error != nil {
            return (result: nil, error: error)
        }

        var data = result?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        return parseJsonResult(data)
    }
}