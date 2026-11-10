enum ResourceType {
  energy,
  water,
  fertilizer;

  /// ប្តូរឈ្មោះពី URL ទៅជា enum។ ឈ្មោះមិនស្គាល់ ឬ null → energy
  static ResourceType fromName(String? name) {
    return ResourceType.values.firstWhere(
      (t) => t.name == name,
      orElse: () => ResourceType.energy,
    );
  }
}
