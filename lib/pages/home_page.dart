// ignore_for_file: prefer_const_constructors, prefer_conditional_assignment

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:zakat/pages/process_page.dart';
import 'package:zakat/pages/save_page.dart';
import 'package:zakat/pages/select_currency.dart';
import 'package:zakat/utils/routes.dart';
import '../utils/validation.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final String? initialCurrency;
  final String? selectedCurrency;
  final bool editMode;
  final Map<String, dynamic>? editData;
  final Function(Map<String, dynamic>)? onSave;
  final List<String> availableCurrencies;
  final Function(Map<String, dynamic>)? onSaveZakat;

  HomePage({
    Key? key,
    required this.selectedCurrency,
    this.initialCurrency,
    this.editMode = false,
    this.editData,
    this.onSave,
    required this.onSaveZakat,
    required this.availableCurrencies,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cash = TextEditingController();
  final TextEditingController _goldOwned = TextEditingController();

  final TextEditingController _silverOwned = TextEditingController();
  final TextEditingController _investment = TextEditingController();
  final TextEditingController _moneyOwed = TextEditingController();
  final TextEditingController _goods = TextEditingController();
  final TextEditingController _othersAssets = TextEditingController();

  final TextEditingController _expenses = TextEditingController();
  final TextEditingController _shortTermDebts = TextEditingController();
  final TextEditingController _otherExpenses = TextEditingController();

  List<Map<String, dynamic>> savedDataList = [];

  String? selectedCurrency;
  var res1;
  var assetsTotal;
  var expenseTotal;
  var res2;
  var res3;
  var zakat;
  bool isLoading = false;
  bool isZakatEligible = true;

  late String _selectedCurrency;
  bool _initialized = false;

  void didChangeDependencies() {
    super.didChangeDependencies();
    final String? currency =
        ModalRoute.of(context)?.settings.arguments as String?;
    setState(() {
      selectedCurrency = currency;
    });

    if (!_initialized) {
      _initializeCurrency();
      _initialized = true;
    }
  }

  Future<double> fetchUsdToCurrencyRate(
      String apiKey, String targetedCurrency) async {
    final String url = 'https://v6.exchangerate-api.com/v6/$apiKey/latest/USD';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      // print(data);
      double usdToBdt = data['conversion_rates']['$targetedCurrency'];
      return usdToBdt;
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }

  Future<double> getGoldPrice() async {
    var response = await http.get(
      Uri.https('www.goldapi.io', '/api/XAU/USD'),
      headers: {
        'x-access-token': 'goldapi-bjms19m0cp7xlt-io',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      if (jsonData.containsKey('price_gram_24k')) {
        double goldPrice24k = jsonData['price_gram_24k'];
        print('24k Gold price per gram: $goldPrice24k');
        return goldPrice24k;
      } else {
        print("price_gram_24k key not found in JSON response");
        throw Exception("price_gram_24k key not found");
      }
    } else {
      print("Error: ${response.statusCode}");
      throw Exception("Failed to fetch gold price");
    }
  }

  Future<double> getSilverPrice() async {
    var response = await http.get(
      Uri.https('www.goldapi.io', '/api/XAG/USD'),
      headers: {
        'x-access-token': 'goldapi-bjms19m0cp7xlt-io',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      if (jsonData.containsKey('price_gram_24k')) {
        double silverPrice24k = jsonData['price_gram_24k'];
        print('24k Silver price per gram: $silverPrice24k');
        return silverPrice24k;
      } else {
        print("price_gram_24k key not found in JSON response");
        throw Exception("price_gram_24k key not found");
      }
    } else {
      print("Error: ${response.statusCode}");
      throw Exception("Failed to fetch gold price");
    }
  }

  Future<void> calculateZakat() async {
    setState(() {
      isLoading = true;
    });

    const String apiKey = 'a15d03e2fb2667c30d398e6d';

    double currency = await fetchUsdToCurrencyRate(apiKey, selectedCurrency!);

    print('calculate Zakat: $selectedCurrency');

    try {
      res2 = assetsTotal! - expenseTotal!;
      var targetGoldPrice = await getGoldPrice();
      var validGoldPrice = targetGoldPrice * 87.48 * currency;
      var targetSilverPrice = await getSilverPrice();
      var validSilverPrice = targetSilverPrice * 612.36 * currency;

      totalAssets();
      totalExpenses();

      print("612.36 gram Silver Price: $validSilverPrice");
      print("87.48 gram Gold Price  : $validGoldPrice");

      double zakatAmount = 0;
      bool isEligible = false;

      if (res2 >= validGoldPrice || res2 >= validSilverPrice) {
        zakatAmount = res2 * 0.025;
        isEligible = true;
      }

      setState(() {
        zakat = zakatAmount;
        isZakatEligible = isEligible;
      });

      print("ZAKAT : $zakat");
    } catch (error) {
      print("Error calculating Zakat: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void totalExpenses() {
    setState(() {
      expenseTotal = [_expenses, _shortTermDebts, _otherExpenses]
          .map((controller) => double.tryParse(controller.text) ?? 0)
          .reduce((a, b) => a + b);
    });
  }

  void totalAssets() {
    setState(() {
      assetsTotal = [
        _cash,
        _goldOwned,
        _silverOwned,
        _investment,
        _moneyOwed,
        _goods,
        _othersAssets
      ]
          .map((controller) => double.tryParse(controller.text) ?? 0)
          .reduce((a, b) => a + b);
    });
  }


  @override
  void initState() {
    super.initState();
    selectedCurrency = widget.selectedCurrency;
    print("initState: $selectedCurrency");
    if (widget.editMode && widget.editData != null) {
      _loadEditData();
    }
    _cash.addListener(totalAssets);
    _goldOwned.addListener(totalAssets);
    _silverOwned.addListener(totalAssets);
    _investment.addListener(totalAssets);
    _moneyOwed.addListener(totalAssets);
    _goods.addListener(totalAssets);
    _othersAssets.addListener(totalAssets);

    _expenses.addListener(totalExpenses);
    _shortTermDebts.addListener(totalExpenses);
    _otherExpenses.addListener(totalExpenses);
  }

  final _formkey = GlobalKey<FormFieldState>();

  String? _cashField;
  String? _goldOwnedField;
  String? _silverOwnedField;
  String? _investmentField;
  String? _moneyOwedField;
  String? _goodsField;
  String? _otherAssetsField;

  String? _expensesField;
  String? _shortTermDebtsField;
  String? _otherExpensesField;

  String? _cashFieldError;
  String? _goldOwnedFieldError;
  String? _silverOwnedFieldError;
  String? _investmentFieldError;
  String? _moneyOwedFieldError;
  String? _goodsFieldError;
  String? ohterAssetsFieldError;

  String? _expensesFieldError;
  String? _shortTermDebtsFieldError;
  String? _otherExpensesFieldError;

  void _initializeCurrency() {
    final String? routeCurrency =
        ModalRoute.of(context)?.settings.arguments as String?;

    if (widget.editMode &&
        widget.editData != null &&
        widget.editData!['currency'] != null) {
      _selectedCurrency = widget.editData!['currency'];
    } else if (routeCurrency != null &&
        widget.availableCurrencies.contains(routeCurrency)) {
      _selectedCurrency = routeCurrency;
    } else if (widget.initialCurrency != null &&
        widget.availableCurrencies.contains(widget.initialCurrency)) {
      _selectedCurrency = widget.initialCurrency!;
    } else if (widget.availableCurrencies.isNotEmpty) {
      _selectedCurrency = widget.availableCurrencies.first;
    } else {
      _selectedCurrency = 'USD';
    }

    if (widget.editMode && widget.editData != null) {
      _loadEditData();
    }
  }

  void _loadEditData() {
    setState(() {
      _cash.text = widget.editData!['cash'].toString() ?? '';
      _goldOwned.text = widget.editData!['goldOwned'].toString() ?? '';
      _silverOwned.text = widget.editData!['silverOwned'].toString() ?? '';
      _investment.text = widget.editData!['investment'].toString() ?? '';
      _moneyOwed.text = widget.editData!['moneyOwed'].toString() ?? '';
      _goods.text = widget.editData!['goods'].toString();
      _othersAssets.text = widget.editData!['othersAssets'].toString() ?? '';

      _expenses.text = widget.editData!['expense'].toString() ?? '';
      _shortTermDebts.text =
          widget.editData!['shortTermDebts'].toString() ?? '';
      _otherExpenses.text = widget.editData!['otherExpenses'].toString() ?? '';

      if (widget.editData!.containsKey('currency') &&
          widget.editData!['currency'] != null) {
        selectedCurrency = widget.editData!['currency'];
      }
      print("Loaded currency: $selectedCurrency");
    });
  }


  void _zakatProcess() {
    if (zakat != null && selectedCurrency != null) {
      final zakatData = {
        'zakat': zakat,
        'currency': selectedCurrency,
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProcessPage(
            onSaveZakatProcess: widget.onSaveZakat,
          ),
          settings: RouteSettings(arguments: zakatData),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error: Unable to process Zakat. Please try again.')),
      );
    }
  }

  void _saveCalculation() {
    if (zakat != null && selectedCurrency != null) {
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
      final calculationData = {
        'date': formattedDate,
        'zakat': zakat,
        'currency': selectedCurrency,
        'assets': assetsTotal,
        'expenses': expenseTotal,
        'cash': _cashField,
        'goldOwned': _goldOwnedField,
        'silverOwned': _silverOwnedField,
        'investment': _investmentField,
        'moneyOwed': _moneyOwedField,
        'goods': _goodsField,
        'othersAssets': _otherAssetsField,
        'expense': _expensesField,
        'shortTermDebts': _shortTermDebtsField,
        'otherExpenses': _otherExpensesField,
      };

      print(
          "Saving calculation with currency: $selectedCurrency"); // Debug print

      if (widget.editMode && widget.onSave != null) {
        widget.onSave!(calculationData);
        Navigator.pop(context);
      } else if (widget.onSave != null) {
        widget.onSave!(calculationData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Calculation saved successfully!')),
        );
      }
    } else {
      print("Error: zakat or selectedCurrency is null"); // Debug print
    }
  }

  void _validateCash(String value) {
    setState(() {
      _cashFieldError = validateCash(value);
    });
  }

  void _validateGoldOwned(String value) {
    setState(() {
      _goldOwnedFieldError = validateCash(value);
    });
  }

  void _validateSilverOwned(String value) {
    setState(() {
      _silverOwnedFieldError = validateCash(value);
    });
  }

  void _validateInvestment(String value) {
    setState(() {
      _investmentFieldError = validateCash(value);
    });
  }

  void _validateMoneyOwed(String value) {
    setState(() {
      _moneyOwedFieldError = validateCash(value);
    });
  }

  void _validateGoods(String value) {
    setState(() {
      _goodsFieldError = validateCash(value);
    });
  }

  void _validateOtherAssets(String value) {
    setState(() {
      _otherExpensesFieldError = validateCash(value);
    });
  }

  void _validateExpenses(String value) {
    setState(() {
      _expensesFieldError = validateCash(value);
    });
  }

  void _validateShortTermDebts(String value) {
    setState(() {
      _shortTermDebtsFieldError = validateCash(value);
    });
  }

  void _validateOtherExpense(String value) {
    setState(() {
      _otherExpensesFieldError = validateCash(value);
    });
  }

  void _clearFormFields() {
    _cash.clear();
    _goldOwned.clear();
    _silverOwned.clear();
    _investment.clear();
    _moneyOwed.clear();
    _goods.clear();
    _othersAssets.clear();

    _expenses.clear();
    _shortTermDebts.clear();
    _otherExpenses.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Zakat in ${selectedCurrency ?? 'Currency'}",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green[400],
      ),
      // drawer: Drawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  "lib/images/zakat.jpg",
                  height: 250,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "What you own",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formkey,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cash,
                          onChanged: (value) {
                            _validateCash(value);
                            _cashField = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter a Amount",
                            label: Text("Cash at home and bank accounts"),
                            errorText: _cashFieldError,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _goldOwned,
                          onChanged: (value) {
                            _validateGoldOwned(value);
                            _goldOwnedField = value;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter A Amount",
                            label: Text("Value of Gold you own"),
                            errorText: _goldOwnedFieldError,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _silverOwned,
                        onChanged: (value) {
                          _validateSilverOwned(value);
                          _silverOwnedField = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter A Amount",
                          label: Text("Value of Sliver you own"),
                          errorText: _silverOwnedFieldError,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _investment,
                        onChanged: (value) {
                          _validateInvestment(value);
                          _investmentField = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter A Amount",
                          label: Text("Value of investment and Shares"),
                          errorText: _investmentFieldError,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _moneyOwed,
                        onChanged: (value) {
                          _validateMoneyOwed(value);
                          _moneyOwedField = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter a amount",
                          label: Text("Money owed to you"),
                          errorText: _moneyOwedFieldError,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _goods,
                        onChanged: (value) {
                          _validateGoods(value);
                          _goodsField = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter a amount",
                          label: Text("Value of goods in stock for share"),
                          errorText: _goodsFieldError,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _othersAssets,
                        onChanged: (value) {
                          _validateOtherAssets(value);
                          _otherAssetsField = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter a amount",
                          label: Text("Other assets"),
                          errorText: _otherExpensesFieldError,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Total asset ${assetsTotal?.toStringAsFixed(2) ?? 0} $selectedCurrency",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "What you owe",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _expenses,
                        onChanged: (value) {
                          _validateExpenses(value);
                          _expensesField = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter A Amount",
                          label: Text('Expenses(Tax,rent,bills)'),
                          errorText: _expensesFieldError,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _shortTermDebts,
                        onChanged: (value) {
                          _validateShortTermDebts(value);
                          _shortTermDebtsField = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter A Amount",
                          label: Text("Short term debts"),
                          errorText: _shortTermDebtsFieldError,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _otherExpenses,
                        onChanged: (value) {
                          _validateOtherExpense(value);
                          _otherExpensesField = value;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter A Amount",
                          label: Text('Other Expenses'),
                          errorText: _otherExpensesFieldError,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Total Expense ${expenseTotal?.toStringAsFixed(2) ?? 0} $selectedCurrency",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: calculateZakat,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 236, 200, 81),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      "Calculate",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'ZAKAT DUE',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                Center(
                  child: Text(
                    isLoading
                        ? "Loading..."
                        : isZakatEligible
                            ? "${zakat?.toStringAsFixed(2) ?? "0.00"} $selectedCurrency"
                            : "You don't have to pay Zakat!!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isZakatEligible ? Colors.green : Colors.red,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _saveCalculation,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 236, 200, 81),
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: _clearFormFields,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 236, 200, 81),
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text(
                              "Clear",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: _zakatProcess,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 236, 200, 81),
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Text(
                        "Procecs",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
