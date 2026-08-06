double? parsePercentage(String raw) {
  final normalized = raw.trim().replaceAll(',', '.');
  if (normalized.isEmpty) {
    return null;
  }
  return double.tryParse(normalized);
}

int percentToBps(String raw, {int fallbackBps = 0}) {
  final percent = parsePercentage(raw);
  if (percent == null) {
    return fallbackBps;
  }
  return (percent * 100).round();
}

String bpsToPercentText(int bps) {
  final percent = bps / 100;
  final fixed = percent.toStringAsFixed(2);
  if (fixed.endsWith('00')) {
    return fixed.substring(0, fixed.length - 3);
  }
  if (fixed.endsWith('0')) {
    return fixed.substring(0, fixed.length - 1);
  }
  return fixed;
}
