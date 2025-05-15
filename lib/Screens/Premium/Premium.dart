import 'package:flutter/material.dart';
import 'package:FapFree/Theme/colors.dart';
import 'dart:async';
import 'package:FapFree/Services/IAPService.dart';
import 'package:FapFree/UI/ProductListScreen.dart';

class Premium extends StatefulWidget {
  const Premium({super.key});

  @override
  _PremiumState createState() => _PremiumState();
}

class _PremiumState extends State<Premium> {
  final PageController _pageController = PageController(
    viewportFraction: 1,
    initialPage: 0,
  );
  late Timer _timer;
  int _currentPage = 0;
  final IAPService _iapService = IAPService();
  String _monthlyPrice = '';
  String _annualPrice = '';

  List<FeatureRow> get _features => [
    FeatureRow(
      iconPath: 'Assets/Icons/block.png',
      title: "Ad-Free Experience",
      description:
          "Enjoy uninterrupted usage with no ads to distract you from your journey.",
    ),
    FeatureRow(
      iconPath: 'Assets/Icons/verified.png',
      title: "Get Verified Badge",
      description:
          "Showcase your commitment with a verified badge that highlights your dedication to growth.",
    ),
    FeatureRow(
      iconPath: 'Assets/Icons/gift.png',
      title: "Exclusive Avatars and Frames",
      description:
          "Personalize your profile with unique avatars and frames available only to premium members.",
    ),
    FeatureRow(
      iconPath: 'Assets/Icons/trophy.png',
      title: "Enhanced Commitment",
      description:
          "Gain access to tools that help you stay strict and focused on your No Fap journey.",
    ),
    FeatureRow(
      iconPath: 'Assets/Icons/support.png',
      title: "Support the App",
      description:
          "Your subscription helps us maintain and improve the app for all users.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchPrices();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _fetchPrices() async {
    try {
      final products = await _iapService.queryAllProducts();
      for (final product in products) {
        if (product.id == 'monthly_subscription') {
          setState(() {
            _monthlyPrice = product.price;
          });
        } else if (product.id == 'annual_subscription') {
          setState(() {
            _annualPrice = product.price;
          });
        }
      }
    } catch (e) {
      // Optionally handle error
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildAnnualButton() {
    return Stack(
      children: [
        OutlinedButton(
          onPressed: () async {
            try {
              await _iapService.buyAnnualSubscription();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Annual subscription purchased!")),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Purchase failed: $e"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.darkGray, width: 2),
            minimumSize: Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: _annualPrice.isNotEmpty ? _annualPrice : "\$30.99",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextSpan(
                  text: "/annually",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 10,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "40% Off",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyButton() {
    return Stack(
      children: [
        ElevatedButton(
          onPressed: () async {
            try {
              await _iapService.buyMonthlySubscription();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Monthly subscription purchased!")),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Purchase failed: $e"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.red,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 70),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: _monthlyPrice.isNotEmpty ? _monthlyPrice : "\$3.99",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                TextSpan(
                  text: "/monthly",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 10,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "Most Selling",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLifetimeButton() {
    return OutlinedButton(
      onPressed: () async {
        try {
          MaterialPageRoute(builder: (context) => ProductListScreen());
          // await _iapService.buyLifetimePlan();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Lifetime plan purchased!")));
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Purchase failed: $e")));
        }
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.darkGray, width: 2),
        minimumSize: Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        "\$99.99/Lifetime",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('Assets/Avatars/avatar3.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.9),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Boost Your Confidence",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text:
                                      "Transform into the Best Version of You: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Upgrade Now!",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Display FeatureRows vertically
                  ..._features,
                  SizedBox(height: 30),
                  _buildAnnualButton(),
                  SizedBox(height: 10),
                  _buildMonthlyButton(),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () async {
                      // Handle restore purchases
                      await _iapService.restorePurchasesAndCheckActive(context);
                    },
                    child: Text(
                      "Restore Purchases",
                      style: TextStyle(color: AppColors.darkGray2),
                    ),
                  ),
                  // _buildLifetimeButton(),
                  Text(
                    "You can cancel your subscription at any time",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: AppColors.darkGray2,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureRow extends StatelessWidget {
  final String iconPath;
  final String title;
  final String description;

  const FeatureRow({
    required this.iconPath,
    required this.title,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 50, height: 50),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray,
                  ),
                ),
                SizedBox(
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColors.darkGray,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
