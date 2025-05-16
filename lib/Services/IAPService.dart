import 'dart:async';

import 'package:FapFree/Services/FirebaseDatabaseService.dart';
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
      setPremium(true);
      final firebaseDatabaseService = FirebaseDatabaseService();
      await firebaseDatabaseService.updateUserPurchaseStatus(true);
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

  void restorePurchasesAndCheckActive(BuildContext context) async {
    final InAppPurchase _iap = InAppPurchase.instance;
    StreamSubscription<List<PurchaseDetails>>?
    subscription; // Declare outside try
    final available = await _iap.isAvailable();
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("In-app purchases are not available on this device."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    print("Restoring purchases...");
    try {
      // Trigger the restore process
      await _iap.restorePurchases();

      // Listen to the purchase stream for restored purchases
      subscription = _iap.purchaseStream.listen(
        (purchases) async {
          bool hasActive = false;
          List<PurchaseDetails> restoredActivePurchases = [];

          for (final PurchaseDetails purchase in purchases) {
            print(
              "Purchase: ${purchase.productID}, Status: ${purchase.status}",
            );
            if ((purchase.productID == _monthlySubscriptionId ||
                        purchase.productID == _annualSubscriptionId) &&
                    purchase.status == PurchaseStatus.purchased ||
                purchase.status == PurchaseStatus.restored &&
                    !purchase.pendingCompletePurchase) {
              hasActive = true;
              restoredActivePurchases.add(purchase);
            }
            if (purchase.pendingCompletePurchase) {
              await _iap.completePurchase(purchase);
            }
          }

          print("Restored Purchases: $purchases");
          print("Has active subscription after restore: $hasActive");

          if (hasActive) {
            setPremium(true);
            final firebaseDatabaseService = FirebaseDatabaseService();
            await firebaseDatabaseService.updateUserPurchaseStatus(true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Active subscription restored."),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            print("No active subscription found after restore.");
            setPremium(false);
            final firebaseDatabaseService = FirebaseDatabaseService();
            await firebaseDatabaseService.updateUserPurchaseStatus(false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("No active subscription found after restoring."),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.black,
              ),
            );
          }

          // Cancel the subscription after processing restored purchases
          await subscription
              ?.cancel(); // Use ?. to avoid error if subscription is null
        },
        onDone: () {
          print("Purchase stream closed after restore.");
        },
        onError: (error) {
          print("Purchase stream error during restore: $error");
        },
      );
    } catch (e) {
      print("Error restoring purchases: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred while restoring purchases: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> setPremium(bool isPremium) async {
    print("Setting premium status to: $isPremium");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremiumPurchased', isPremium);
    await prefs.setBool('hasDisabledAds', isPremium);
    await _loadUserPremiumData(isPremium);
  }

  Future<void> _loadUserPremiumData(bool isPremium) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('is_unlock_frame1', isPremium);
    await prefs.setBool('is_unlock_frame4', isPremium);
    await prefs.setBool('is_unlock_frame6', isPremium);
    await prefs.setBool('is_unlock_avatar3', isPremium);
    await prefs.setBool('is_unlock_avatar4', isPremium);
    await prefs.setBool('is_unlock_avatar5', isPremium);
    await prefs.setBool('is_unlock_avatar7', isPremium);
  }

  void checkHasActiveSub() async {
    late StreamSubscription<List<PurchaseDetails>> _subscription;

    await _iap.restorePurchases();

    printIfSubscribed() {
      final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
      _subscription = purchaseUpdated.listen(
        (purchaseDetailsList) {},
        onDone: () {
          _subscription.cancel();
        },
        onError: (error) {
          // handle error here.
        },
      );
      _subscription.onData((data) {
        if (data.isNotEmpty) {
          print(data[0].status);
        }
      });
    }
  }
}
