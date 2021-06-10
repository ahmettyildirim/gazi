// import 'package:flutter/material.dart';

// class AddKurban extends StatefulWidget {
//   @override
//   _AddKurbanState createState() => _AddKurbanState();
// }

// class _AddKurbanState extends State<AddKurban> {
//   final _formKey = GlobalKey<FormState>(debugLabel: '_AddCustomerFormState');
//   @override
//   Widget build(BuildContext context) {
//     var screenInfo = MediaQuery.of(context);
//     final screenWidth = screenInfo.size.width;
//     final screenHeight = screenInfo.size.height;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Yeni Kurban Ekle"),
//       ),
//       body: Center(
//           child: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(screenHeight / 30),
//                 child: TextFormField(
//                   keyboardType: TextInputType.phone,
//                   controller: _phoneController,
//                   inputFormatters: [maskFormatter],
//                   decoration: InputDecoration(hintText: 'Cep Telefonu'),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(screenHeight / 30),
//                 child: TextFormField(
//                   controller: _nameController,
//                   decoration: InputDecoration(hintText: 'Ad-Soyad'),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(screenHeight / 30),
//                 child: TextFormField(
//                   keyboardType: TextInputType.emailAddress,
//                   controller: _emailController,
//                   decoration: InputDecoration(hintText: 'Mail Adresi'),
//                 ),
//               ),
//               Padding(
//                   padding: EdgeInsets.all(screenHeight / 30),
//                   child: ElevatedButton(
//                       onPressed: addCustomer, child: Text("Ekle"))),
//             ],
//           ),
//         ),
//       )),
//     );
//   }
// }
