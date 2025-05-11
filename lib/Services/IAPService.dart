import 'package:in_app_purchase/in_app_purchase.dart';

class IAPService {
  final InAppPurchase _iap = InAppPurchase.instance;

  // Replace these with your actual product IDs from the Play Console
  static const String _weeklySubscriptionId = 'your_weekly_subscription_id';
  static const String _monthlySubscriptionId = 'your_monthly_subscription_id';
  static const String _annualSubscriptionId = 'your_annual_subscription_id';

  Future<void> buyMonthlySubscription() async {
    await _buyProduct(_monthlySubscriptionId);
  }

  Future<void> buyWeeklySubscription() async {
    await _buyProduct(_weeklySubscriptionId);
  }

  Future<void> buyAnnualSubscription() async {
    await _buyProduct(_annualSubscriptionId);
  }

  Future<void> _buyProduct(String productId) async {
    final available = await _iap.isAvailable();
    if (!available) {
      throw Exception("In-app purchases are not available on this device.");
    }

    final productDetailsResponse = await _iap.queryProductDetails({productId});
    if (productDetailsResponse.notFoundIDs.isNotEmpty) {
      throw Exception("Product not found: $productId");
    }

    final productDetails = productDetailsResponse.productDetails.first;
    final purchaseParam = PurchaseParam(productDetails: productDetails);

    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<List<ProductDetails>> queryAllProducts() async {
    final available = await _iap.isAvailable();
    if (!available) {
      throw Exception("In-app purchases are not available on this device.");
    }

    final productDetailsResponse = await _iap.queryProductDetails({
      _weeklySubscriptionId,
      _monthlySubscriptionId,
      _annualSubscriptionId,
    });

    if (productDetailsResponse.notFoundIDs.isNotEmpty) {
      throw Exception(
        "Some products were not found: ${productDetailsResponse.notFoundIDs}",
      );
    }

    return productDetailsResponse.productDetails;
  }
}
