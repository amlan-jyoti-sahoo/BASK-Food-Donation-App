import 'dart:convert';
import 'package:bask_app/model/address.dart';
import 'package:bask_app/model/cityStateApiModel.dart';
import 'package:bask_app/model/user.dart';
import 'package:bask_app/services/auth.dart';
import 'package:bask_app/services/firestoreApi.dart';
import 'package:bask_app/widget/gradient_widget.dart';
import 'package:bask_app/widget/alret_dialog.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
    required this.isThirdpartySignup,
  }) : super(key: key);
  final bool isThirdpartySignup;
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  StateModel? selectedState;
  CityModel? selectedCity;
  List states = [];
  List cities = [];

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isTriedToSubmited = false;
  bool isLoading = false;
  bool isDisableEmail = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final numberController = TextEditingController();
  final pinCodeController = TextEditingController();
  final areaController = TextEditingController();
  final addressDetailsController = TextEditingController();

  GlobalKey<FormState> signupFormkey = GlobalKey<FormState>();

  // for sign in with email and password
  void signUp() async {
    if (signupFormkey.currentState!.validate()) {
      if (selectedState != null && selectedCity != null) {
        final database = Provider.of<FirestoreApi>(context, listen: false);
        try {
          setState(() {
            isLoading = true;
          });
          final user = User(
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              email: emailController.text,
              password: passwordController.text,
              role: 'user',
              phoneNumber: numberController.text,
              ratingCount: 0,
              avgRating: 0,
              donationCount: 0,
              defaultAddressId: 'first_address',
              joinedOn: DateTime.now(),
              cartItemCount: 0);
          final userAddress = Address(
            addressDetails: addressDetailsController.text,
            area: areaController.text,
            pinCode: pinCodeController.text,
            city: selectedCity!.cityName,
            state: selectedState!.stateName,
          );

          if (widget.isThirdpartySignup) {
            await database.userSignUpWithThirdparyProvider(
                user, userAddress, context);
            setState(() {
              isLoading = false;
            });
            await showNormalAlretDialog(
              context,
              title: 'Sign up success',
              message:
                  'you have successfully signed up. Now you can continue with BASK',
            );
            Navigator.of(context).pop();
          } else {
            await database.userSignUpWithEmail(user, userAddress, context);
            setState(() {
              isLoading = false;
            });
            await showNormalAlretDialog(
              context,
              title: 'Sign up success',
              message:
                  'you have successfully signed up. A varification link is sent to your email id , please verify before login',
            );
            Navigator.of(context).pop();
          }
        } on Exception catch (e) {
          setState(() {
            isLoading = false;
          });
          showExceptionAlertDialog(
            context,
            title: 'Sign up failed',
            exception: e,
          );
        }
      } else {
        //show flush bar to select one state
      }
    } else {
      setState(() {
        isTriedToSubmited = true;
      });
      //show flush bar to fill the form correctly
      print('not Validated');
    }
  }

  Future<bool?> showBackConformationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ct) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('You can\'t use BASK with out signing up'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ct).pop(false),
            child: Text('Cancle'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              // final auth = Provider.of<Auth>(context);
              // await auth.signOut();
              return Navigator.of(ct).pop(true);
            },
            child: Text(
              'Back to login',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadState();
    final auth = Provider.of<Auth>(context, listen: false);

    if (widget.isThirdpartySignup && auth.currentuser!.email != null) {
      isDisableEmail = true;
      emailController.text = auth.currentuser!.email!;
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    numberController.dispose();
    pinCodeController.dispose();
    areaController.dispose();
    addressDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isThirdpartySignup) {
          final shouldPop = await showBackConformationDialog(context);
          if (shouldPop == true) {
            final auth = Provider.of<Auth>(context, listen: false);
            setState(() {
              isLoading = true;
            });
            auth.signOut();
          }
          return shouldPop ?? false;
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      height: 180,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 10, top: 35),
                              child: IconButton(
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        if (widget.isThirdpartySignup) {
                                          bool? willback =
                                              await showBackConformationDialog(
                                                  context);
                                          if (willback == true) {
                                            final auth = Provider.of<Auth>(
                                                context,
                                                listen: false);
                                            setState(() {
                                              isLoading = true;
                                            });
                                            auth.signOut();
                                            setState(() {
                                              isLoading = false;
                                            });
                                            Navigator.pop(context);
                                          }
                                        } else {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              )),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, bottom: 5),
                            child: Text(
                              widget.isThirdpartySignup
                                  ? 'Fill the details'
                                  : 'SIGN UP',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20, bottom: 15),
                            child: Text(
                              'to continue with BASK',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          )
                        ],
                      )),
                  Container(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 170),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35),
                        )),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        autovalidateMode: isTriedToSubmited?AutovalidateMode.onUserInteraction:AutovalidateMode.disabled,
                        key: signupFormkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 60,
                            ),
                            TextFormField(
                              enabled: !isLoading,
                              controller: firstNameController,
                              decoration: InputDecoration(
                                labelText: 'First name',
                                prefixIcon: makeWidgetGradient(
                                  child: Icon(
                                    Icons.account_circle_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                              validator:
                                  RequiredValidator(errorText: 'Required'),
                              autocorrect: true,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              enabled: !isLoading,
                              controller: lastNameController,
                              decoration: InputDecoration(
                                labelText: 'Last name',
                                prefixIcon: makeWidgetGradient(
                                  child: Icon(
                                    Icons.account_circle_outlined,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                              validator:
                                  RequiredValidator(errorText: 'Required'),
                              autocorrect: true,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              enabled: !isLoading && !isDisableEmail,
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.black26,
                                  ),
                                ),
                                prefixIcon: makeWidgetGradient(
                                  child: Icon(
                                    Icons.email,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: 'Email required *'),
                                EmailValidator(errorText: 'not a valid email')
                              ]),
                              autocorrect: false,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            if (!widget.isThirdpartySignup)
                              TextFormField(
                                enabled: !isLoading,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: makeWidgetGradient(
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  suffixIcon: passwordController.text.isNotEmpty
                                      ? (isPasswordVisible
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  isPasswordVisible =
                                                      !isPasswordVisible;
                                                });
                                              },
                                              icon: makeWidgetGradient(
                                                child: Icon(
                                                  Icons.visibility_off,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  isPasswordVisible =
                                                      !isPasswordVisible;
                                                });
                                              },
                                              icon: makeWidgetGradient(
                                                child: Icon(
                                                  Icons.visibility,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ))
                                      : Container(
                                          width: 0,
                                        ),
                                ),
                                onChanged: (_) {
                                  setState(() {});
                                },
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: 'Passwprd required *'),
                                  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                                      errorText:
                                          'passwords must have at least one special character'),
                                  LengthRangeValidator(
                                      min: 6,
                                      max: 20,
                                      errorText:
                                          'Password must be 6 to 20 character long')
                                ]),
                                textInputAction: TextInputAction.next,
                                obscureText: !isPasswordVisible,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                            if (!widget.isThirdpartySignup)
                              SizedBox(
                                height: 20,
                              ),
                            if (!widget.isThirdpartySignup)
                              TextFormField(
                                enabled: !isLoading,
                                controller: confirmPasswordController,
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  prefixIcon: makeWidgetGradient(
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  suffixIcon:
                                      confirmPasswordController.text.isNotEmpty
                                          ? (isConfirmPasswordVisible
                                              ? IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      isConfirmPasswordVisible =
                                                          !isConfirmPasswordVisible;
                                                    });
                                                  },
                                                  icon: makeWidgetGradient(
                                                    child: Icon(
                                                      Icons.visibility_off,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      isConfirmPasswordVisible =
                                                          !isConfirmPasswordVisible;
                                                    });
                                                  },
                                                  icon: makeWidgetGradient(
                                                    child: Icon(
                                                      Icons.visibility,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ))
                                          : Container(
                                              width: 0,
                                            ),
                                ),
                                onChanged: (_) {
                                  setState(() {});
                                },
                                validator: (val) => MatchValidator(
                                        errorText: 'passwords do not match')
                                    .validateMatch(
                                        val!, passwordController.text),
                                textInputAction: TextInputAction.next,
                                obscureText: !isConfirmPasswordVisible,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                            if (!widget.isThirdpartySignup)
                              SizedBox(
                                height: 20,
                              ),
                            TextFormField(
                              controller: numberController,
                              enabled: !isLoading,
                              decoration: InputDecoration(
                                labelText: 'Mobile number',
                                prefixIcon: makeWidgetGradient(
                                  child: Icon(
                                    Icons.phone,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: 'mobile number required *'),
                                PatternValidator(r'^(?:[+0]91)?[0-9]{10}$',
                                    errorText: 'enter a valid phone number'),
                              ]),
                              autocorrect: true,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            customDorpDown(
                              child: DropdownButton<StateModel>(
                                underline: Container(
                                  height: 0,
                                ),
                                isExpanded: true,
                                hint: Text('Select your state'),
                                items: states.map<DropdownMenuItem<StateModel>>(
                                  (val) {
                                    return DropdownMenuItem<StateModel>(
                                      value: val,
                                      child: Text(val.stateName),
                                    );
                                  },
                                ).toList(),
                                value: selectedState,
                                onChanged: isLoading
                                    ? null
                                    : (StateModel? value) {
                                        setState(() {
                                          selectedState = value;
                                          setState(() {
                                            selectedCity = null;
                                          });
                                          loadCity();
                                        });
                                      },
                              ),
                              icon: Icon(
                                Icons.maps_home_work,
                                color: Colors.redAccent,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            customDorpDown(
                              child: DropdownButton<CityModel>(
                                underline: Container(
                                  height: 0,
                                ),
                                isExpanded: true,
                                hint: Text('Select your city'),
                                items: cities.map<DropdownMenuItem<CityModel>>(
                                  (val) {
                                    return DropdownMenuItem<CityModel>(
                                      value: val,
                                      child: Text(val.cityName),
                                    );
                                  },
                                ).toList(),
                                value: selectedCity,
                                onChanged: isLoading
                                    ? null
                                    : (CityModel? value) {
                                        setState(() {
                                          selectedCity = value;
                                        });
                                      },
                              ),
                              icon: Icon(
                                Icons.location_city,
                                color: Colors.redAccent,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: pinCodeController,
                              enabled: !isLoading,
                              decoration: InputDecoration(
                                labelText: 'pin code',
                                prefixIcon: makeWidgetGradient(
                                  child: Icon(
                                    Icons.push_pin_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: 'pin code required *'),
                                PatternValidator(r'^[0-9]{6}$',
                                    errorText:
                                        'pincode must be a 6 digit number'),
                              ]),
                              autocorrect: true,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: areaController,
                              enabled: !isLoading,
                              decoration: InputDecoration(
                                labelText: 'Area',
                                prefixIcon: makeWidgetGradient(
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                              validator:
                                  RequiredValidator(errorText: 'Required'),
                              autocorrect: true,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: addressDetailsController,
                              enabled: !isLoading,
                              decoration: InputDecoration(
                                labelText: 'plot no , street , socity',
                                prefixIcon: makeWidgetGradient(
                                  child: Icon(
                                    Icons.house,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                              validator:
                                  RequiredValidator(errorText: 'Required'),
                              autocorrect: true,
                              keyboardType: TextInputType.streetAddress,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  minimumSize: Size(150, 40),
                                  elevation: 8,
                                  shadowColor: Colors.green),
                              onPressed: isLoading ? () {} : signUp,
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.white,
                                    )
                                  : Text(
                                      'Submit',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customDorpDown({required Widget child, required Icon icon}) {
    return Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.black38,
            ),
          ),
        ),
        padding: EdgeInsets.only(left: 44.0, bottom: 7),
        child: child,
      ),
      Container(
        margin: EdgeInsets.only(top: 12, left: 13),
        child: makeWidgetGradient(child: icon),
      ),
    ]);
  }

  Future<void> loadState() async {
    var uri =
        Uri.parse('https://api.countrystatecity.in/v1/countries/IN/states');
    final response = await http.get(uri, headers: {
      "X-CSCAPI-KEY": "YklyVGdIZjJCUFhEQlExeGsxSWFBT3BhSWRDMDZiMnJGS3pPWktxeg=="
    });
    final body = json.decode(response.body);
    setState(() {
      states = body.map<StateModel>(StateModel.fromJson).toList();
    });
  }

  Future<void> loadCity() async {
    var uri = Uri.parse(
        'https://api.countrystatecity.in/v1/countries/IN/states/${selectedState!.stateId}/cities');
    final response = await http.get(uri, headers: {
      "X-CSCAPI-KEY": "YklyVGdIZjJCUFhEQlExeGsxSWFBT3BhSWRDMDZiMnJGS3pPWktxeg=="
    });
    final body = json.decode(response.body);
    setState(() {
      cities = body.map<CityModel>(CityModel.fromJson).toList();
    });
  }
}
