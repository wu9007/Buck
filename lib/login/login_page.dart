import 'package:buck/basic_app.dart';
import 'package:buck/login/utility/color_utility.dart';
import 'package:buck/login/utility/login_constant.dart';
import 'package:buck/login/widgets/forward_button.dart';
import 'package:buck/login/widgets/header_text.dart';
import 'package:buck/login/widgets/login_top_bar.dart';
import 'package:buck/utils/login_client.dart';
import 'package:buck/widgets/loading/gradient_circular_progress_route.dart';
import 'package:buck/widgets/tips/tips_tool.dart';
import 'package:flutter/material.dart';
import 'package:pda_scanner/pda_listener_mixin.dart';

import 'login_animation.dart';

class LoginPage extends StatefulWidget {
  final String backgroundPath;
  final String logoPath;
  final String titleLabel;
  final String welcomeLabel;

  const LoginPage({
    Key key,
    @required this.backgroundPath,
    @required this.logoPath,
    @required this.titleLabel,
    @required this.welcomeLabel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin, PdaListenerMixin {
  LoginEnterAnimation enterAnimation;
  AnimationController animationController;

  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _userName;
  String _password;

  @override
  initState() {
    super.initState();
    animationController = new AnimationController(duration: const Duration(seconds: 1), vsync: this)
      ..addListener(() {
        setState(() {});
      });
    enterAnimation = new LoginEnterAnimation(animationController);
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Color(getColorHexFromStr(COLOR_LOGIN)),
      body: Builder(
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              _transTopView(size, textTheme),
              _transBottomView(size, textTheme, context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildForm(Size size, TextTheme textTheme) {
    return Padding(
        padding: EdgeInsets.only(top: size.height * 0.3, left: 24, right: 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: _buildTextFormUsername(textTheme),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: 12),
                  child: Container(
                    color: Colors.grey,
                    height: 1,
                    width: enterAnimation.dividerScale.value * size.width,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: _buildTextFormPassword(textTheme),
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildTextFormUsername(TextTheme textTheme) {
    return FadeTransition(
      opacity: enterAnimation.userNameOpacity,
      child: TextFormField(
        style: textTheme.headline6.copyWith(color: Colors.black87, letterSpacing: 1.2),
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: USER_NAME_HINT,
          hintStyle: textTheme.subtitle1.copyWith(color: Colors.grey),
          icon: Icon(Icons.person, color: Colors.black87),
          contentPadding: EdgeInsets.zero,
        ),
        keyboardType: TextInputType.text,
        controller: _userNameController,
        validator: (val) {
          if (val.length == 0) {
            return USER_NAME_VALIDATION_EMPTY;
          } else {
            return null;
          }
        },
        onSaved: (val) => _userName = val,
      ),
    );
  }

  Widget _buildTextFormPassword(TextTheme textTheme) {
    return FadeTransition(
      opacity: enterAnimation.passwordOpacity,
      child: TextFormField(
        style: textTheme.headline6.copyWith(color: Colors.black87, letterSpacing: 1.2),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: PASSWORD_HINT,
            hintStyle: textTheme.subtitle1.copyWith(color: Colors.grey),
            contentPadding: EdgeInsets.zero,
            icon: Icon(Icons.lock, color: Colors.black87)),
        keyboardType: TextInputType.text,
        controller: _passwordController,
        obscureText: true,
        validator: (val) {
          if (val.length == 0) {
            return USER_NAME_VALIDATION_EMPTY;
          } else {
            return null;
          }
        },
        onSaved: (val) => _password = val,
      ),
    );
  }

  Widget _buildSignButton(context) {
    return Transform(
      transform: Matrix4.translationValues(enterAnimation.translation.value * 200, enterAnimation.translation.value * 20, 0.0),
      child: ForwardButton(
        onPressed: () async {
          bool validate = _formKey.currentState.validate();
          if (validate) {
            _showLoading();
            _formKey.currentState.save();
            bool success;
            try {
              bool baseUrlAvailable = await LoginClient.getInstance().checkUrl();
              if(baseUrlAvailable) {
                success = await LoginClient.getInstance().login(_userName, _password);
              } else{
                TipsTool.warning('请检测网络是否正常\n\n或扫码设置服务器地址后重新尝试登录').show();
              }
            } catch (e) {
              print(e);
            } finally {
              Navigator.of(context).pop();
            }
            if (success ?? false) {
              await animationController.reverse();
              buck.navigatorKey.currentState.pushNamedAndRemoveUntil('homePage', (route) => route == null);
            }
          }
        },
        label: BUTTON_SIGN_IN,
      ),
    );
  }

  Widget _transTopView(Size size, TextTheme textTheme) {
    return Transform(
      transform: Matrix4.translationValues(0.0, -enterAnimation.yTranslation.value * size.height, 0.0),
      child: LoginTopBar(
          child: Container(
        height: size.height * 0.67,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: new AssetImage(widget.backgroundPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(-enterAnimation.xTranslation.value * size.width, 0.0, 0.0),
              child: Padding(
                padding: EdgeInsets.only(top: size.height * 0.15, left: 24, right: 24),
                child: HeaderText(text: widget.titleLabel, imagePath: widget.logoPath),
              ),
            ),
            _buildForm(size, textTheme),
          ],
        ),
      )),
    );
  }

  Widget _transBottomView(Size size, TextTheme textTheme, context) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.72),
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            FadeTransition(
              opacity: enterAnimation.titleLabelOpacity,
              child: Text(
                widget.welcomeLabel,
                style: textTheme.headline6.copyWith(fontFamily: 'shouji', color: Colors.black87, fontWeight: FontWeight.normal, wordSpacing: 1.2, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            _buildSignButton(context),
          ],
        ),
      ),
    );
  }

  _showLoading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return WillPopScope(
            child: GradientCircularProgressRoute(
              colors: [Colors.yellow, Colors.orange],
              label: Container(child: Text('登录中……', style: TextStyle(fontSize: 15, color: Colors.white70, decoration: TextDecoration.none))),
            ),
            onWillPop: () => Future.value(false),
          );
        });
  }

  @override
  void onError(Object error) {
    TipsTool.warning('扫描失败，请检查 PDA 的设置是否正确').show();
  }

  @override
  void onEvent(Object code) {
    if(code.toString().startsWith('http')) {
      String customBaseUrls = buck.cacheControl.customBaseUrls;
      if(customBaseUrls == null) customBaseUrls = code;
      if(!customBaseUrls.contains(code)) customBaseUrls += ',$code';
      buck.cacheControl.setCustomBaseUrls(customBaseUrls);
    } else{
      TipsTool.warning('扫描内容不合法').show();
    }
  }
}
