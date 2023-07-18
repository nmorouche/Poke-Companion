/// The enum that represents the differents locating modes.
public enum LocatingMode {
    case newInstance
    case sharedInstance
    case lazySharedInstance
}

/// Type that will link the locating type with its builder.
private struct Constructor {
    let mode: LocatingMode
    let builder: () -> Any
}

/// The struct that allow us to create and retrieve instances.
public struct Locator {
    
    /// The factory that will allow us to instantiate different objects.
    static private var factories: [ObjectIdentifier: Constructor] = [:]
    
    /// The stored shared instance once created
    static private var sharedInstances: [ObjectIdentifier: Any] = [:]
    
    /// Register the instance of a type.
    /// - Parameters:
    ///   - type: The type of the instance.
    ///   - mode: The locating mode.
    ///   - factory: The callback on which we create the instance.
    public static func register<T>(_ type: T.Type = T.self,
                            mode: LocatingMode = .sharedInstance,
                            _ factory: @escaping () -> T) {
        self.factories[ObjectIdentifier(type)] = Constructor(mode: mode, builder: factory)
        if mode == .sharedInstance {
            _ = locate(type)
        }
    }
    
    /// Instantiation of the value stored in the Constructor builder.
    /// - Parameter type: The type to instantiate.
    /// - Returns: The instance of the type defined in the parameters.
    fileprivate static func locate<T>(_ type: T.Type) -> T {
        let key = ObjectIdentifier(type)

        switch self.factories[key]!.mode {
        case .newInstance:
            return self.factories[key]!.builder() as! T
        case .sharedInstance, .lazySharedInstance:
            guard let sharedInstance = self.sharedInstances[key] as? T else {
                let instance = self.factories[key]!.builder() as! T
                self.sharedInstances[key] = instance
                return instance
            }
            return sharedInstance
        }
    }

}

@propertyWrapper
/// The Inject structure accessible via the keyword `@`.
public struct Inject<Service> {

    public init() {}

    public var wrappedValue: Service {
        return Locator.locate(Service.self)
    }
}
