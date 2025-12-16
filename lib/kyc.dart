import 'package:bottlebucks/login.dart';
import 'package:bottlebucks/mykyc.dart';
import 'package:bottlebucks/register.dart' hide dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class KycFormPage extends StatefulWidget {
  const KycFormPage({super.key});

  @override
  State<KycFormPage> createState() => _KycFormPageState();
}

class _KycFormPageState extends State<KycFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController nameController = TextEditingController();

  final TextEditingController bankAccController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final TextEditingController upiController = TextEditingController();

  // List of Indian Banks
  final List<String> banks = [
    "Axis Bank",
    "Bank of Baroda",
    "Bank of India",
    "Canara Bank",
    "Central Bank of India",
    "HDFC Bank",
    "ICICI Bank",
    "IDBI Bank",
    "Indian Bank",
    "IndusInd Bank",
    "Kotak Mahindra Bank",
    "Punjab National Bank",
    "State Bank of India (SBI)",
    "UCO Bank",
    "Union Bank of India",
    "Yes Bank",
  ];

  String? selectedBank;

  Future<void> KycAPI(context) async {
    try {
      final response = await dio.post(
        '$base_url/KycAPI/$LID',
        data: {
          'Name': nameController.text,
          'ACno': bankAccController.text,
          'Bankname': selectedBank,
          'IFSCcode': ifscController.text,
          'UPI': upiController.text,
        },
      );

      print(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.data['message'] ?? 'KYC submitted Successfully',
            ),
          ),
        );

        setState(() {
          nameController.clear();
          bankAccController.clear();
          selectedBank = null;
          ifscController.clear();
          upiController.clear();
        });
      }
    } catch (e) {
      if (e is DioException) {
        final apiMessage =
            e.response?.data['message'] ?? "Something went wrong";

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(apiMessage)));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Unexpected error")));
      }
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KYC Details Form"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Simple Dropdown (No Search)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Select Bank",
                  border: OutlineInputBorder(),
                ),
                value: selectedBank,
                items: banks
                    .map(
                      (bank) =>
                          DropdownMenuItem(value: bank, child: Text(bank)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBank = value;
                  });
                },
                validator: (value) =>
                    value == null ? "Please select your bank" : null,
              ),
              const SizedBox(height: 20),

              // Account Number
              TextFormField(
                controller: bankAccController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Bank Account Number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 8) {
                    return "Enter a valid account number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // IFSC Code
              TextFormField(
                controller: ifscController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: "IFSC Code",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().length != 11) {
                    return "Enter a valid 11-character IFSC code";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // UPI ID
              TextFormField(
                controller: upiController,
                decoration: const InputDecoration(
                  labelText: "UPI ID",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || !value.contains("@")) {
                    return "Enter a valid UPI ID (example@upi)";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    KycAPI(context);
                  }
                },
                child: const Text("Submit KYC", style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyKycPage()),
                  );
                },
                child: const Text("View KYC", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
