import 'dart:io';
import 'package:bottlebucks/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Registerscreen extends StatefulWidget {
  Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

File? _image;
final ImagePicker _picker = ImagePicker();
final base_url = 'http://192.168.29.122:5000';
Dio dio = Dio();

class _RegisterscreenState extends State<Registerscreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phno = TextEditingController();
  TextEditingController pin = TextEditingController();
  TextEditingController password = TextEditingController();

  // Districts only (City removed)
  List<String> districts = [
    "Thiruvananthapuram",
    "Kollam",
    "Pathanamthitta",
    "Alappuzha",
    "Kottayam",
    "Idukki",
    "Ernakulam",
    "Thrissur",
    "Palakkad",
    "Malappuram",
    "Kozhikode",
    "Wayanad",
    "Kannur",
    "Kasargod",
  ];

  String? selectedDistrict;

  // API CALL
  Future<void> RegistrationAPI(context) async {
    try {
      final formdata = FormData.fromMap({
        'Username': email.text,
        'Name': name.text,
        'Address': address.text,
        'Email': email.text,
        'Phno': phno.text,
        'District': selectedDistrict,
        'Pin': pin.text,
        'Password': password.text,
        'Image': _image != null
            ? await MultipartFile.fromFile(
                _image!.path,
                filename: _image!.path.split('/').last,
              )
            : null,
      });

      final response = await dio.post('$base_url/UserAPI', data: formdata);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Loginscreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Registration failed')));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Register'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image Picker
              InkWell(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepPurple.shade100,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(Icons.camera_alt, size: 40, color: Colors.black54)
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              // Full Name
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 12),

              // Address
              TextFormField(
                controller: address,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter address" : null,
              ),
              const SizedBox(height: 12),

              // Email
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    !v!.contains("@") ? "Enter valid email" : null,
              ),
              const SizedBox(height: 12),

              // Phone Number
              TextFormField(
                controller: phno,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.length != 10
                    ? "Enter valid 10-digit phone number"
                    : null,
              ),
              const SizedBox(height: 12),

              // District Dropdown (City Removed)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "District",
                  border: OutlineInputBorder(),
                ),
                value: selectedDistrict,
                items: districts
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedDistrict = value);
                },
                validator: (v) => v == null ? "Select district" : null,
              ),
              const SizedBox(height: 12),

              // PIN
              TextFormField(
                controller: pin,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'PIN Code',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v!.length != 6 ? "Enter valid 6-digit PIN" : null,
              ),
              const SizedBox(height: 12),

              // Password
              TextFormField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v!.length < 6 ? "Minimum 6 characters required" : null,
              ),
              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        RegistrationAPI(context);
                      }
                    },
                    child: Text("Submit"),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
