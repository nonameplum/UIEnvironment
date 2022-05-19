import Foundation

/// An interface for a view/view controller that uses ``UIEnvironment`` property
/// and wants to update on the environment changes.
public protocol UIEnvironmentUpdating {
    
    /// UIEnvironment calls this function when the ``UIEnvironment`` changes.
    /// It can be used to react to the changes and get the updated ``UIEnvironment`` values.
    func updateEnvironment()
}
