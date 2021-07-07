class DurationFormat {
  final double unitSwitchBarrier;

  DurationFormat(this.unitSwitchBarrier);

  String format(Duration duration, {humanize = false}) {
    var output = '';

    var days = duration.inDays.abs();
    var hours = duration.inHours.abs();
    var minutes = duration.inMinutes.abs();
    var seconds = duration.inSeconds.abs();

    var percentageDay =
        (hours % Duration.hoursPerDay).toDouble() / Duration.hoursPerDay;
    var percentageHour = (minutes % Duration.minutesPerHour).toDouble() /
        Duration.minutesPerHour;
    var percentageMinute = (seconds % Duration.secondsPerMinute).toDouble() /
        Duration.secondsPerMinute;

    if (days + percentageDay > unitSwitchBarrier) {
      output = '${(days + percentageDay).ceil()} day';
    } else if (hours + percentageHour > unitSwitchBarrier) {
      output = '${(hours + percentageHour).ceil()} hour';
    } else if (minutes + percentageMinute > 0) {
      output = '${(minutes + percentageMinute).ceil()} minute';
    } else {
      output = '${duration.inSeconds.abs()} second';
    }

    if (int.parse(output.substring(0, output.indexOf(' '))) > 1) {
      output += 's';
    }

    if (humanize) {
      output = duration.isNegative ? '$output ago' : 'in $output';
    }
    return output;
  }
}
