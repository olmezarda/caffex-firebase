class AppStrings {
  static const OnboardingStrings onboarding = OnboardingStrings();
  static const CaffeDescriptions descriptions = CaffeDescriptions();
}

class OnboardingStrings {
  const OnboardingStrings();

  final String animation1 = 'assets/animations/welcome_caffe.json';
  final String title1 = "Welcome to CaffeX!";
  final String subtitle1 = "Your caffe journey starts here.";

  final String animation2 = 'assets/animations/delivery_caffe.json';
  final String title2 = "Order your caffe easily!";
  final String subtitle2 = "Fast and simple ordering system.";

  final String animation3 = 'assets/animations/relax_caffe.json';
  final String title3 = "Enjoy your caffe experience!";
  final String subtitle3 = "Sip and relax anytime.";
}

class CaffeDescriptions {
  const CaffeDescriptions();

  final String espresso = '''
Strong and intense flavor
Rich crema on top
Served in a 60ml cup
Ideal for concentrated coffee lovers
Perfect for a quick energy boost
''';

  final String latte = '''
Smooth espresso with steamed milk
Topped with light milk foam
Served in a 300ml glass
Mellow and creamy flavor
Great choice for a gentle caffeine lift
''';

  final String cappuccino = '''
Equal parts espresso, milk, and foam
Topped with cocoa or cinnamon
Served in a 200ml ceramic cup
Classic Italian favorite
Pairs well with pastries
''';

  final String americano = '''
Espresso diluted with hot water
Milder and smoother taste
Served in a 250ml mug
Ideal for a long, relaxing drink
Light and simple brew
''';

  final String creamLatte = '''
Espresso with creamy steamed milk
Topped with whipped cream swirl
Served in a 300ml glass
Rich, velvety, and sweet
Smooth and indulgent
''';

  final String machiato = '''
Espresso with a touch of milk foam
Bold yet softened flavor
Served in a 90ml glass
Perfect balance of strong and smooth
A quick pick-me-up with elegance
''';

  final String doppio = '''
Double espresso shot
Twice the caffeine and strength
Served in a 120ml cup
Rich and full-bodied taste
Made for true espresso lovers
''';

  final String frappe = '''
Blended instant coffee with ice
Cold and frothy texture
Optional whipped cream or syrup
Served in a 350ml glass
Refreshing choice for hot days
''';

  final String irishCaffee = '''
Black coffee with Irish whiskey
Sweetened with brown sugar
Topped with lightly whipped cream
Served in a 250ml mug
After-dinner indulgence
''';
}
