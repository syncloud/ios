import Foundation

class SimulatorUtil
{
    class var isRunningSimulator: Bool
    {
        return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
    }
}
