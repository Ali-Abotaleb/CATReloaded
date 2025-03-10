import 'dart:io';

enum Size { Small, Medium, Large }

abstract class Pizza {
  String name;
  Size size;
  double price;
  List<String> toppings;

  Pizza(this.name, this.size, this.price, this.toppings);

  double calculatePrice();

  @override
  String toString() {
    return '${size.toString()} $name Pizza with ${toppings.join(", ")}. Price: \$${price.toStringAsFixed(2)}';
  }
}

class MargheritaPizza extends Pizza {
  MargheritaPizza(Size size, List<String> extraToppings)
      : super('Margherita', size, 0.0, ['Tomato Sauce', 'Mozzarella', 'Basil']) {
    toppings.addAll(extraToppings);
    price = calculatePrice();
  }

  @override
  double calculatePrice() {
    switch (size) {
      case Size.Small:
        return 10.0;
      case Size.Medium:
        return 12.0;
      case Size.Large:
        return 14.0;
    }
  }

  @override
  String toString() {
    return 'Margherita Pizza (${size.toString()}) with ${toppings.join(", ")} - \$${price.toStringAsFixed(2)}';
  }
}

class PepperoniPizza extends Pizza {
  PepperoniPizza(Size size, List<String> extraToppings)
      : super('Pepperoni', size, 0.0, ['Tomato Sauce', 'Mozzarella', 'Pepperoni']) {
    toppings.addAll(extraToppings);
    price = calculatePrice();
  }

  @override
  double calculatePrice() {
    double basePrice;
    switch (size) {
      case Size.Small:
        basePrice = 12.0;
        break;
      case Size.Medium:
        basePrice = 14.0;
        break;
      case Size.Large:
        basePrice = 16.0;
        break;
    }
    return basePrice + 2.0;
  }

  @override
  String toString() {
    return 'Pepperoni Pizza (${size.toString()}) with ${toppings.join(", ")} - \$${price.toStringAsFixed(2)}';
  }
}

class VeggiePizza extends Pizza {
  VeggiePizza(Size size, List<String> extraToppings)
      : super('Veggie', size, 0.0, ['Tomato Sauce', 'Mozzarella', 'Mushrooms', 'Onions', 'Bell Peppers']) {
    toppings.addAll(extraToppings);
    price = calculatePrice();
  }

  @override
  double calculatePrice() {
    double basePrice;
    switch (size) {
      case Size.Small:
        basePrice = 10.0;
        break;
      case Size.Medium:
        basePrice = 12.0;
        break;
      case Size.Large:
        basePrice = 14.0;
        break;
    }
    return basePrice + (toppings.length * 0.5);
  }

  @override
  String toString() {
    return 'Veggie Pizza (${size.toString()}) with ${toppings.join(", ")} - \$${price.toStringAsFixed(2)}';
  }
}

class Order {
  String orderId;
  String customerId;
  Pizza pizza;
  double totalPrice;

  Order(this.orderId, this.customerId, this.pizza) : totalPrice = pizza.price;

  void confirmOrder() {
    _payOrder();
    print('Order confirmed!');
  }

  void _payOrder() {
    print('Processing payment of \$${totalPrice.toStringAsFixed(2)}...');
  }

  @override
  String toString() {
    return 'Order ID: $orderId\nCustomer ID: $customerId\n${pizza.toString()}\nTotal: \$${totalPrice.toStringAsFixed(2)}';
  }
}

void main() {
  print('🍕 Welcome to the Pizza Ordering System 🍕');
  while (true) {
    print('\nMain Menu:');
    print('1. Order a Pizza');
    print('2. Exit');
    stdout.write('Enter your choice: ');
    var choice = stdin.readLineSync()?.trim();
    if (choice == '1') {
      _orderPizza();
    } else if (choice == '2') {
      print('Exiting...');
      break;
    } else {
      print('Invalid choice. Please try again.');
    }
  }
}

void _orderPizza() {
  print('\nSelect Pizza Type:');
  print('1. Margherita');
  print('2. Pepperoni');
  print('3. Veggie');
  stdout.write('Enter your choice: ');
  var pizzaType = stdin.readLineSync()?.trim();

  Size size;
  print('\nSelect Size:');
  print('1. Small');
  print('2. Medium');
  print('3. Large');
  stdout.write('Enter your choice: ');
  var sizeChoice = stdin.readLineSync()?.trim();
  switch (sizeChoice) {
    case '1':
      size = Size.Small;
      break;
    case '2':
      size = Size.Medium;
      break;
    case '3':
      size = Size.Large;
      break;
    default:
      print('Invalid size choice. Defaulting to Medium.');
      size = Size.Medium;
  }

  print('\nEnter extra toppings (comma-separated, e.g., Mushrooms, Onions): ');
  var toppingsInput = stdin.readLineSync()?.trim();
  List<String> extraToppings = [];
  if (toppingsInput != null && toppingsInput.isNotEmpty) {
    extraToppings.addAll(toppingsInput.split(',').map((t) => t.trim()));
    extraToppings.removeWhere((t) => t.isEmpty);
  }

  Pizza pizza;
  switch (pizzaType) {
    case '1':
      pizza = MargheritaPizza(size, extraToppings);
      break;
    case '2':
      pizza = PepperoniPizza(size, extraToppings);
      break;
    case '3':
      pizza = VeggiePizza(size, extraToppings);
      break;
    default:
      print('Invalid pizza type. Defaulting to Margherita.');
      pizza = MargheritaPizza(size, extraToppings);
  }

  String orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
  String customerId = 'CUST-123';

  var order = Order(orderId, customerId, pizza);
  order.confirmOrder();

  print('\nOrder Details:');
  print(order.toString());
}