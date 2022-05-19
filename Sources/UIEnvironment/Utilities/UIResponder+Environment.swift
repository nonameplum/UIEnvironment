import UIKit

extension UIResponder {
    internal func valueInSelf<Value>(forKeyPath keyPath: KeyPath<UIEnvironmentValues, Value>) -> Value? {
        guard let wrapper = objc_getAssociatedObject(
            self,
            UIResponder.key
        ) as? UIResponder.EnvironmentValuesWrapper
        else {
            return nil
        }

        var _values = wrapper.values
        if _values.hasValue(for: keyPath) {
            return wrapper.values[keyPath: keyPath]
            //            return value
        }

        return nil
    }
}
