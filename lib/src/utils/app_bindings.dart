import 'package:expense_tracker/src/repository/currency_repository.dart';
import 'package:expense_tracker/src/repository/receipt_repository/receipt_repository.dart';
import 'package:expense_tracker/src/repository/transaction_repository/transaction_repository.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/features/core/controllers/cart_controller.dart';
import 'package:expense_tracker/src/repository/authentication_repository/auth_repository.dart';

class AppBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRepository(), fenix: true);
    Get.lazyPut(() => CartController(), fenix: true);

    Get.lazyPut(() => CurrencyRepository(), fenix: true);
    Get.lazyPut(() => TransactionRepository(), fenix: true);
    Get.lazyPut(() => ReceiptRepository(), fenix: true);
  }

}