// import 'package:bottlebucks/profileApi.dart';
// import 'package:bottlebucks/register.dart';
// import 'package:flutter/material.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   bool isEditing = false;
//   List<dynamic> profile = [];

//   // Controllers
//   TextEditingController nameController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController districtController = TextEditingController();
//   TextEditingController cityController = TextEditingController();
//   TextEditingController pincodeController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     getProfile();
//   }

//   Future<void> getProfile() async {
//     try {
//       List<dynamic> data = await fetchProfile();

//       setState(() {
//         profile = data;

//         nameController.text = profile[0]["Name"];
//         addressController.text = profile[0]["Address"];
//         emailController.text = profile[0]["Email"];
//         phoneController.text = profile[0]["Phno"].toString();
//         districtController.text = profile[0]["District"];
//         cityController.text = profile[0]["City"];
//         pincodeController.text = profile[0]["Pin"].toString();
//       });
//     } catch (e) {
//       print("Error loading profile: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.grey[200],
//         appBar: AppBar(
//           title: Text(isEditing ? "Edit Profile" : "Profile Page"),
//           centerTitle: true,
//           backgroundColor: Colors.blueAccent,
//           actions: [
//             IconButton(
//               icon: Icon(isEditing ? Icons.save : Icons.edit),
//               onPressed: () async {
//                 if (isEditing) {
//                   // 🔥 CALL UPDATE PROFILE API HERE
//                   await updateProfile(
//                     name: nameController.text,
//                     address: addressController.text,
//                     phone: phoneController.text,
//                     district: districtController.text,
//                     city: cityController.text,
//                     pin: pincodeController.text,
//                   );

//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("Profile Updated Successfully"),
//                     ),
//                   );

//                   setState(() {
//                     profile[0]["Name"] = nameController.text;
//                     profile[0]["Address"] = addressController.text;
//                     profile[0]["Phno"] = phoneController.text;
//                     profile[0]["District"] = districtController.text;
//                     profile[0]["City"] = cityController.text;
//                     profile[0]["Pin"] = pincodeController.text;
//                   });
//                 }

//                 setState(() {
//                   isEditing = !isEditing;
//                 });
//               },
//             ),
//           ],
//         ),

//         body: profile.isEmpty
//             ? const Center(child: CircularProgressIndicator())
//             : SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       CircleAvatar(
//                         radius: 60,
//                         backgroundImage: NetworkImage(
//                           '$base_url${profile[0]["Image"]}',
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       // Name
//                       isEditing
//                           ? buildTextField("Name", nameController)
//                           : buildInfoCard(
//                               icon: Icons.person,
//                               title: "Name",
//                               value: profile[0]['Name'],
//                             ),

//                       // Address
//                       isEditing
//                           ? buildTextField("Address", addressController)
//                           : buildInfoCard(
//                               icon: Icons.home,
//                               title: "Address",
//                               value: profile[0]['Address'],
//                             ),

//                       // Email
//                       isEditing
//                           ? Padding(
//                               padding: const EdgeInsets.only(bottom: 15),
//                               child: TextField(
//                                 readOnly: true,
//                                 controller: emailController,
//                                 decoration: InputDecoration(
//                                   labelText: 'Email',
//                                   border: const OutlineInputBorder(),
//                                 ),
//                               ),
//                             )
//                           : buildInfoCard(
//                               icon: Icons.email,
//                               title: "Email",
//                               value: profile[0]['Email'],
//                             ),

//                       // Phone
//                       isEditing
//                           ? buildTextField("Phone Number", phoneController)
//                           : buildInfoCard(
//                               icon: Icons.phone,
//                               title: "Phone Number",
//                               value: profile[0]['Phno'].toString(),
//                             ),

//                       // District
//                       isEditing
//                           ? buildTextField("District", districtController)
//                           : buildInfoCard(
//                               icon: Icons.location_city,
//                               title: "District",
//                               value: profile[0]['District'],
//                             ),

//                       // City
//                       isEditing
//                           ? buildTextField("City", cityController)
//                           : buildInfoCard(
//                               icon: Icons.location_city,
//                               title: "City",
//                               value: profile[0]['City'],
//                             ),

//                       // Pincode
//                       isEditing
//                           ? buildTextField("Pin Code", pincodeController)
//                           : buildInfoCard(
//                               icon: Icons.pin,
//                               title: "Pin Code",
//                               value: profile[0]['Pin'].toString(),
//                             ),
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }

//   // Display card
//   Widget buildInfoCard({
//     required IconData icon,
//     required String title,
//     required String value,
//   }) {
//     return Card(
//       elevation: 3,
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       child: ListTile(
//         leading: Icon(icon, size: 30, color: Colors.blueAccent),
//         title: Text(
//           title,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(value, style: const TextStyle(fontSize: 15)),
//       ),
//     );
//   }

//   // TextField for edit mode
//   Widget buildTextField(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 15),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//       ),
//     );
//   }

//   // 🔥 UPDATE PROFILE API
//   Future<void> updateProfile({
//     required String name,
//     required String address,
//     required String phone,
//     required String district,
//     required String city,
//     required String pin,
//   }) async {
//     try {
//       await editProfileApi({
//         "Name": name,
//         "Address": address,
//         "Phno": phone,
//         "District": district,
//         "City": city,
//         "Pin": pin,
//       });
//     } catch (e) {
//       print("Update profile error: $e");
//     }
//   }
// }

import 'dart:io';
import 'package:bottlebucks/profileApi.dart';
import 'package:bottlebucks/register.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  List<dynamic> profile = [];

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future<void> getProfile() async {
    try {
      List<dynamic> data = await fetchProfile();
      setState(() {
        profile = data;
        nameController.text = profile[0]["Name"];
        addressController.text = profile[0]["Address"];
        emailController.text = profile[0]["Email"];
        phoneController.text = profile[0]["Phno"].toString();
        districtController.text = profile[0]["District"];
        // cityController.text = profile[0]["City"];
        pincodeController.text = profile[0]["Pin"].toString();
      });
    } catch (e) {
      print("Error loading profile: $e");
    }
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text(isEditing ? "Edit Profile" : "Profile Page"),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          actions: [
            IconButton(
              icon: Icon(isEditing ? Icons.save : Icons.edit),
              onPressed: () async {
                if (isEditing) {
                  // 🔥 UPDATE PROFILE + IMAGE
                  await updateProfile(
                    name: nameController.text,
                    address: addressController.text,
                    phone: phoneController.text,
                    district: districtController.text,
                    city: cityController.text,
                    pin: pincodeController.text,
                    imageFile: _imageFile,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Profile Updated Successfully"),
                    ),
                  );

                  // Update local state
                  setState(() {
                    profile[0]["Name"] = nameController.text;
                    profile[0]["Address"] = addressController.text;
                    profile[0]["Phno"] = phoneController.text;
                    profile[0]["District"] = districtController.text;
                    // profile[0]["City"] = cityController.text;
                    profile[0]["Pin"] = pincodeController.text;
                  });
                }

                setState(() {
                  isEditing = !isEditing;
                });
              },
            ),
          ],
        ),
        body: profile.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Image
                      GestureDetector(
                        onTap: isEditing ? pickImage : null,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : NetworkImage(
                                      '$base_url${profile[0]["Image"] ?? ''}',
                                    )
                                    as ImageProvider,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Name
                      isEditing
                          ? buildTextField("Name", nameController)
                          : buildInfoCard(
                              icon: Icons.person,
                              title: "Name",
                              value: profile[0]['Name'],
                            ),

                      // Address
                      isEditing
                          ? buildTextField("Address", addressController)
                          : buildInfoCard(
                              icon: Icons.home,
                              title: "Address",
                              value: profile[0]['Address'],
                            ),

                      // Email (read-only)
                      isEditing
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: TextField(
                                readOnly: true,
                                controller: emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                            )
                          : buildInfoCard(
                              icon: Icons.email,
                              title: "Email",
                              value: profile[0]['Email'],
                            ),

                      // Phone
                      isEditing
                          ? buildTextField("Phone Number", phoneController)
                          : buildInfoCard(
                              icon: Icons.phone,
                              title: "Phone Number",
                              value: profile[0]['Phno'].toString(),
                            ),

                      // District
                      isEditing
                          ? buildTextField("District", districtController)
                          : buildInfoCard(
                              icon: Icons.location_city,
                              title: "District",
                              value: profile[0]['District'],
                            ),

                      // City
                      // isEditing
                      //     ? buildTextField("City", cityController)
                      //     : buildInfoCard(
                      //         icon: Icons.location_city,
                      //         title: "City",
                      //         value: profile[0]['City'],
                      //       ),

                      // Pincode
                      isEditing
                          ? buildTextField("Pin Code", pincodeController)
                          : buildInfoCard(
                              icon: Icons.pin,
                              title: "Pin Code",
                              value: profile[0]['Pin'].toString(),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // Display card
  Widget buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.blueAccent),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value, style: const TextStyle(fontSize: 15)),
      ),
    );
  }

  // TextField for edit mode
  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  // 🔥 UPDATE PROFILE API (with optional image)
  Future<void> updateProfile({
    required String name,
    required String address,
    required String phone,
    required String district,
    required String city,
    required String pin,
    File? imageFile,
  }) async {
    try {
      // Create FormData for multipart/form-data
      FormData formData = FormData.fromMap({
        "Name": name,
        "Address": address,
        "Phno": phone,
        "District": district,
        "City": city,
        "Pin": pin,
        if (imageFile != null)
          "Image": await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
      });

      await editProfileApi(formData);
    } catch (e) {
      print("Update profile error: $e");
    }
  }
}
