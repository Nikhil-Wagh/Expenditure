import 'package:expenditure/constants.dart';
import 'package:expenditure/services/auth.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> with SingleTickerProviderStateMixin {
  final List<Tab> authTabs = <Tab>[
    Tab(text: 'Sign in'),
    Tab(text: 'Sign up')
  ];
  TabController _tabController;

  final AuthService _auth = AuthService();
  final _SignInFormKey = GlobalKey<FormState>();
  final _SignUpFormKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';

  String passwordError = null;
  String emailError = null;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: authTabs.length);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            _buildConstWelcomeComponent(),
            _buildTabBarView(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      bottom: PreferredSize(
        preferredSize: Size(double.infinity, 0.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: TabBar(
                isScrollable: true,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 4, color: Colors.white),
                  insets: EdgeInsets.only(left: -7, right: 8, bottom: 4),
                ),
                labelPadding: EdgeInsets.only(left: 0, right: 16),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: authTabs,
                controller: _tabController,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConstWelcomeComponent() {
    return Container(
      padding: EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              helloString,
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                createAccountString,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      // color: Colors.red,
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _authSkeleton(signIn: true),
        _authSkeleton(signIn: false),
      ],
    );
  }

  Column _authSkeleton({signIn: true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 32,
              right: 32,
              top: 48,
              bottom: 24,
            ),
            child: signIn ? _signInForm() : _signUpForm(),
          ),
        )
      ],
    );
  }

  Form _signInForm() {
    return Form(
      key: _SignInFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Email",
            ),
            validator: (value) => _auth.validateEmail(value),
            onChanged: (val) {
              setState(() => email = val.trim());
            },
          ),
          SizedBox(height: 8.0),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelStyle: TextStyle(fontSize: 14),
              labelText: "Password",
            ),
            validator: (value) => _auth.validatePassword(value),
            onChanged: (val) {
              setState(() => password = val.trim());
            },
          ),
          SizedBox(height: 10.0),
          RaisedButton(
            color: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              'Sign In',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              if (_SignInFormKey.currentState.validate()) {
                dynamic result = await _auth.signInEmailAndPassword(email, password);
                if (result.hasErrors()) {
                  setState(() {
                    error = result.errorMessage();
                  });
                }
              }
            },
          ),
          Visibility(
            visible: error.isNotEmpty,
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Form _signUpForm() {
    return Form(
      key: _SignUpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Email",
              errorText: emailError,
            ),
            validator: (value) => _auth.validateEmail(value),
            onChanged: (val) {
              setState(() => email = val.trim());
            },
          ),
          SizedBox(height: 8.0),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelStyle: TextStyle(fontSize: 14),
              labelText: "Password",
            ),
            validator: (value) => _auth.validatePassword(value),
            onChanged: (val) {
              setState(() => password = val.trim());
            },
          ),
          SizedBox(height: 8),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelStyle: TextStyle(fontSize: 14),
              labelText: "Confirm Password",
            ),
            validator: (value) => _auth.validateConfirmPassword(password, value),
            onChanged: (val) {
              setState(() => confirmPassword = val.trim());
            },
          ),
          SizedBox(height: 10.0),
          RaisedButton(
            color: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              'Sign Up',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              if (_SignUpFormKey.currentState.validate()) {
                dynamic result = await _auth.signUpEmailAndPassword(email, password);
                if (result.hasErrors()) {
                  setState(() {
                    error = result.errorMessage();
                  });
                }
              }
            },
          ),
          Visibility(
            visible: error.isNotEmpty,
            child: Column(
              children: [
                SizedBox(height: 16),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
