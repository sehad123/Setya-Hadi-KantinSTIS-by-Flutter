import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kantin_stis/API/configAPI.dart';
import 'package:kantin_stis/Screens/Login/LoginScreens.dart';
import 'package:kantin_stis/Screens/Register/Registrasi.dart';
import 'package:kantin_stis/Screens/Admin/HomeAdminScreen.dart';
import 'package:kantin_stis/Screens/User/UserScreen.dart';
import 'package:kantin_stis/Utils/constants.dart';

class SignInform extends StatefulWidget {
  @override
  _SignInForm createState() => _SignInForm();
}

class _SignInForm extends State<SignInform> {
  final formKey = GlobalKey<FormState>();
  String? username;
  String? Password;
  bool? remember = false;

  TextEditingController txtUsername = TextEditingController(),
      txtPassword = TextEditingController();

  FocusNode focusNode = new FocusNode();

  Response? response;
  var dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          buildUserName(),
          SizedBox(height: 30),
          buildPassword(),
          SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                prosesLogin(txtUsername.text, txtPassword.text);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Ganti dengan warna yang diinginkan
              ),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white), // Atur warna teks tombol
              ),
            ),
          ),
          SizedBox(
              height: 20), // Memberikan jarak antara tombol 'Login' dan 'Row'

          Row(
            children: [
              Checkbox(
                  value: remember,
                  onChanged: (value) {
                    setState(() {
                      remember = value;
                    });
                  }),
              Text("Tetap Masuk"),
              Spacer(),
              GestureDetector(
                onTap: () {
                  showForgetPasswordDialog();
                },
                child: Text(
                  "Lupa Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),

          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RegisterScreen.routeName);
            },
            child: Text(
              "Belum Punya Akun ? Daftar Dulu",
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildUserName() {
    return TextFormField(
      controller: txtUsername,
      keyboardType: TextInputType.text,
      style: mTitleStyle,
      decoration: InputDecoration(
          labelText: 'Usename',
          hintText: 'Masukkan username anda',
          labelStyle: TextStyle(
              color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.people)),
    );
  }

  TextFormField buildPassword() {
    return TextFormField(
      controller: txtPassword,
      obscureText: true,
      style: mTitleStyle,
      decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Masukkan password anda',
          labelStyle: TextStyle(
              color: focusNode.hasFocus ? mSubtitleColor : kPrimaryColor),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.password)),
    );
  }

  void prosesLogin(userName, password) async {
    bool status;
    var msg;
    var dataUser;
    try {
      response = await dio.post(urlsignIn, data: {
        'username': userName,
        'password': password,
      });

      status = response!.data['sukses'];
      msg = response!.data['msg'];
      if (status) {
        // print("Berhasil Registrasi");
        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.success,
          title: 'Peringatan ',
          desc: 'Berhasil Login',
          btnOkOnPress: () {
            dataUser = response!.data['data'];
            if (dataUser['role'] == 1) {
              Navigator.pushNamed(context, UserScreen.routeName,
                  arguments: dataUser);
              print("ke halaman user");
            } else if (dataUser['role'] == 2) {
              Navigator.pushNamed(context, HomeAdminScreen.routeName);
              print("ke halaman admin ");
            } else {
              print("Halaman tidak tersedia");
            }
          },
        ).show();
      } else {
        // print("Gagal");
        AwesomeDialog(
          context: context,
          animType: AnimType.rightSlide,
          dialogType: DialogType.error,
          title: 'Peringatan ',
          desc: 'gagal Login => $msg',
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      AwesomeDialog(
        context: context,
        animType: AnimType.rightSlide,
        dialogType: DialogType.error,
        title: 'Peringatan ',
        desc: 'Terjadi Kesalahan Server',
        btnOkOnPress: () {},
      ).show();
    }
  }

  bool containsLetterAndDigit(String value) {
    bool hasLetter = false;
    bool hasDigit = false;

    for (int i = 0; i < value.length; i++) {
      if (value[i].toUpperCase() != value[i].toLowerCase()) {
        // Karakter adalah huruf
        hasLetter = true;
      } else if (int.tryParse(value[i]) != null) {
        // Karakter adalah angka
        hasDigit = true;
      }
    }

    return hasLetter && hasDigit;
  }

  void showForgetPasswordDialog() {
    TextEditingController usernameController = TextEditingController();

    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      title: 'Lupa Password',
      desc: 'Masukkan Username',
      body: Column(
        children: [
          TextFormField(
            controller: usernameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Username',
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              checkUsername(usernameController.text);
            },
            child: Text('Next'),
          ),
        ],
      ),
    ).show();
  }

  void checkUsername(String username) async {
    try {
      Response response = await Dio().post(
        "$urlforgotpass",
        data: {
          'username': username,
        },
      );

      if (response.statusCode == 200) {
        var userData = response.data['data'];
        showResetPasswordDialog(username, userData['_id']);
      } else {
        showErrorDialog(
            'Username tidak terdaftar', 'Username tidak terdaftar.');
      }
    } catch (e) {
      showErrorDialog('Error', 'Username tidak ditemukan ');
    }
  }

  void showResetPasswordDialog(String username, String userId) {
    TextEditingController newPasswordController = TextEditingController();

    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      title: 'Reset Password',
      desc: 'Masukkan Password Baru untuk $username',
      body: Column(
        children: [
          TextFormField(
            controller: newPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password Baru',
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text.length < 8)
                showErrorDialog("Error", "Password minimal harus 8 karakter ");
              else if (!containsLetterAndDigit(newPasswordController.text))
                showErrorDialog(
                    "Error", "Password harus berupa huruf dan angka ");
              else
                updatePassword(userId, newPasswordController.text);
            },
            child: Text('Reset Password'),
          ),
        ],
      ),
    ).show();
  }

  void updatePassword(String userId, String newPassword) async {
    try {
      Response response = await Dio().put(
        "$urlresetpass/$userId",
        data: {
          'newPassword': newPassword,
        },
      );

      if (response.statusCode == 200) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: "Berhasil",
          desc: "Password berhasil di reset, silahkan login",
          btnOkOnPress: () {
            Navigator.pushNamed(context, LoginScreen.routeName);
          },
        ).show();
      } else {
        showErrorDialog('Gagal mereset password',
            'Terjadi kesalahan saat mereset password.');
      }
    } catch (e) {
      showErrorDialog('Error', 'Terjadi kesalahan saat memproses permintaan.');
    }
  }

  void showErrorDialog(String title, String desc) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      title: title,
      desc: desc,
      btnOkOnPress: () {},
    ).show();
  }

  void showSuccessDialog(String title, String desc) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: title,
      desc: desc,
      btnOkOnPress: () {},
    ).show();
  }
}
