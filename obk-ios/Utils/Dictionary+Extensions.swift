public extension Dictionary {
    public func withAllValues(from other: Dictionary) -> Dictionary {
        var result = self
        other.forEach { result[$0] = $1 }
        return result
    }    
}
