Map<String, dynamic> fixSingle(dynamic response) {
  try {
    return response as Map<String, dynamic>;
  } catch (error) {
    return (response as List<Map<String, dynamic>>).first;
  }
}
