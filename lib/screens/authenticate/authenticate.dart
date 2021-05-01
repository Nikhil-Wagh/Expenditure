import 'dart:ui';

import 'package:expenditure/constants.dart';
import 'package:expenditure/screens/loaders/loading_auth.dart';
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
  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';

  bool loading = false;

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
            Visibility(
              visible: loading,
              child: LoadingAuth(),
            ),
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
          margin: EdgeInsets.symmetric(horizontal: 10),
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
              top: 40,
              bottom: 16,
            ),
            child: signIn ? _signInForm() : _signUpForm(),
          ),
        )
      ],
    );
  }

  Form _signInForm() {
    return Form(
      key: _signInFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          _emailFormField(),
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
          _loginWithOptionsRow(),
          ElevatedButton(
            child: Text(
              'Sign In',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              if (_signInFormKey.currentState.validate()) {
                setState(() => loading = true);
                dynamic result = await _auth.signInEmailAndPassword(email, password);
                if (result.hasErrors()) {
                  setState(() {
                    error = result.errorMessage();
                  });
                }
                setState(() => loading = false);
              }
            },
          ),
          _authErrorMessageBlock(),
        ],
      ),
    );
  }

  Form _signUpForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          _emailFormField(),
          SizedBox(height: mPadding),
          _passwordFormField(),
          SizedBox(height: mPadding),
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
          _loginWithOptionsRow(),
          ElevatedButton(
            child: Text(
              'Sign Up',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              if (_signUpFormKey.currentState.validate()) {
                setState(() => loading = true);
                dynamic result = await _auth.signUpEmailAndPassword(email, password);
                if (result.hasErrors()) {
                  setState(() {
                    error = result.errorMessage();
                  });
                }
                setState(() => loading = true);
              }
            },
          ),
          _authErrorMessageBlock(),
        ],
      ),
    );
  }

  TextFormField _emailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Email",
      ),
      validator: (value) => _auth.validateEmail(value),
      onChanged: (val) {
        setState(() => email = val.trim());
      },
    );
  }

  TextFormField _passwordFormField() {
    return TextFormField(
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
    );
  }

  Visibility _authErrorMessageBlock() {
    return Visibility(
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
    );
  }

  Row _loginWithOptionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          child: IconButton(
            icon: Image.asset(
              'assets/images/Google.png',
              height: 24,
            ),
            onPressed: () async {
              dynamic result = await _auth.signInWithGoogle();
              if (result.hasErrors()) {
                error = result.errorMessage();
              }
            },
          ),
        ),
        Card(
          child: IconButton(
            icon: Image.asset(
              'assets/images/Facebook.png',
              height: 24,
            ),
            onPressed: () async {
              dynamic result = await _auth.signInWithFacebook();
              if (result.hasErrors()) {
                error = result.errorMessage();
              }
            },
          ),
        ),
        Card(
          child: IconButton(
            icon: Image.asset(
              'assets/images/Twitter.png',
              height: 24,
            ),
            onPressed: () async {
              dynamic result = await _auth.signInWithTwitter();
              if (result.hasErrors()) {
                error = result.errorMessage();
              }
            },
          ),
        ),
      ],
    );
  }
}
