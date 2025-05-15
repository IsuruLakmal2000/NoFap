import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IAPService {
  final InAppPurchase _iap = InAppPurchase.instance;

  // Replace these with your actual product IDs from the Play Console
  // static const String _weeklySubscriptionId = 'your_weekly_subscription_id';
  static const String _monthlySubscriptionId = 'monthly_subscription';
  static const String _annualSubscriptionId = 'annual_subscription';

  static String get monthlySubscriptionId => _monthlySubscriptionId;
  static String get annualSubscriptionId => _annualSubscriptionId;

  Future<void> buyMonthlySubscription() async {
    await _buyProduct(_monthlySubscriptionId);
  }

  // Future<void> buyWeeklySubscription() async {
  //   await _buyProduct(_weeklySubscriptionId);
  // }

  Future<void> buyAnnualSubscription() async {
    await _buyProduct(_annualSubscriptionId);
  }

  Future<bool> _buyProduct(String productId) async {
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

    // Listen for purchase updates
    final purchaseUpdated = _iap.purchaseStream.firstWhere((purchases) {
      return purchases.any(
        (purchase) =>
            purchase.productID == productId &&
            (purchase.status == PurchaseStatus.purchased ||
                purchase.status == PurchaseStatus.error ||
                purchase.status == PurchaseStatus.canceled),
      );
    });

    await _iap.buyNonConsumable(purchaseParam: purchaseParam);

    final purchases = await purchaseUpdated;
    final purchase = purchases.firstWhere((p) => p.productID == productId);

    if (purchase.status == PurchaseStatus.purchased) {
      // Optionally, verify the purchase here
      return true;
    } else {
      return false;
    }
  }

  Future<List<ProductDetails>> queryAllProducts() async {
    final available = await _iap.isAvailable();
    if (!available) {
      throw Exception("In-app purchases are not available on this device.");
    }

    final productDetailsResponse = await _iap.queryProductDetails({
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

  Future<void> printAllProducts() async {
    final products = await queryAllProducts();
    for (final product in products) {
      print('Product: ${product.title}, Price: ${product.price}');
    }
  }

  Future<void> restorePurchasesAndCheckActive(BuildContext context) async {
    final available = await _iap.isAvailable();
    if (!available) {
      throw Exception("In-app purchases are not available on this device.");
    }

    await _iap.restorePurchases();

    // Listen for the next purchase update after restorePurchases is called
    final purchases = await _iap.purchaseStream.first;

    // Check if any restored purchase is an active subscription
    final hasActive = purchases.any(
      (purchase) =>
          (purchase.productID == _monthlySubscriptionId ||
              purchase.productID == _annualSubscriptionId) &&
          purchase.status == PurchaseStatus.purchased &&
          !purchase.pendingCompletePurchase,
    );

    // Here you can unlock premium access if hasActive is true
    // For example, you might set a value in shared preferences or your app state

    if (hasActive) {
      setPremium(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No active subscription found."),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.black,
        ),
      );
      setPremium(false);
    }
  }

  Future<void> setPremium(bool isPremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremiumPurchased', isPremium);
    await prefs.setBool('hasDisabledAds', isPremium);
  }
}
