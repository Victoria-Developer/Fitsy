enum Activity{
  sedentary(1.2, "Sedentary"),
  light(1.375, "Light"),
  moderate(1.55, "Moderate"),
  active(1.725, "Active"),
  extra(1.9, "Very active");

  final double multiplier;
  final String name;
  const Activity(this.multiplier, this.name);
}