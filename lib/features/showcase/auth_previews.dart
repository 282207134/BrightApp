import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';
import 'demo_widgets.dart';

class SplashDemo extends StatelessWidget {
  const SplashDemo(this.variant, {super.key});
  final int variant;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => openPreview(context, 'onboarding', 0),
    child: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (variant == 0 || variant >= 3)
            ShoeImage(
              ['splash_city', '', '', 'splash_fashion', 'splash_suit'][variant],
              fit: BoxFit.cover,
            )
          else
            Container(
              decoration: BoxDecoration(
                color: variant == 2 ? Colors.black : null,
                gradient: variant == 1
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xffff699e), Color(0xff6643c8)],
                      )
                    : null,
              ),
            ),
          if (variant == 0) const ColoredBox(color: Color(0x66422661)),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (variant == 4)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Welcome to',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                if (variant == 3)
                  SizedBox(
                    width: 150,
                    height: 155,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Positioned(
                          top: 0,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: blue,
                          ),
                        ),
                        const Positioned(
                          left: 0,
                          bottom: 10,
                          child: CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.cyanAccent,
                          ),
                        ),
                        const Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.greenAccent,
                          ),
                        ),
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: BrightColors.pink.withValues(
                            alpha: .9,
                          ),
                          child: Text(
                            'B',
                            style: heading(80, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Text('Bright.', style: heading(76, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class OnboardingDemo extends StatelessWidget {
  const OnboardingDemo(this.variant, {super.key});
  final int variant;
  @override
  Widget build(BuildContext context) {
    if (variant == 0) {
      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            const ShoeImage('onboarding', fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(
                      'Huge collection of all\ntype of Sneakers in\nthe world.',
                      style: heading(31, color: Colors.white),
                    ),
                    const SizedBox(height: 36),
                    PrimaryButton(
                      'REGISTER',
                      onPressed: () => openPreview(context, 'register', 0),
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      'LOGIN',
                      onPressed: () => openPreview(context, 'login', 0),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: TextButton(
                        onPressed: () => toast(
                          context,
                          'Facebook sign-in is not connected.',
                        ),
                        child: const Text(
                          'Continue with Facebook',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    final dark = variant == 2;
    return Scaffold(
      backgroundColor: dark ? BrightColors.ink : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.all(variant == 1 ? 0 : 28),
                child: variant == 2
                    ? _phone()
                    : variant == 4
                    ? Container(
                        margin: const EdgeInsets.symmetric(vertical: 28),
                        decoration: BoxDecoration(
                          color: const Color(0xffd8d8d8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )
                    : DemoPhoto(
                        variant == 1 ? 'onboard_fashion' : 'onboard_red',
                        width: double.infinity,
                        fit: BoxFit.cover,
                        radius: variant == 1 ? 0 : 8,
                      ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 12),
                child: Column(
                  crossAxisAlignment: variant == 4
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    Text(
                      variant == 4
                          ? 'Huge collection of all\ntype of Sneakers in\nthe world.'
                          : 'Buy easily from anywhere',
                      textAlign: variant == 4
                          ? TextAlign.left
                          : TextAlign.center,
                      style: heading(
                        variant == 4 ? 30 : 25,
                        color: dark ? Colors.white : null,
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (variant != 4)
                      Text(
                        'After you have registered your number with Bright, you can explore the collection and connect with other people.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.8,
                          color: dark ? Colors.white70 : BrightColors.muted,
                        ),
                      ),
                    const Spacer(),
                    if (variant == 4)
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              'REGISTER',
                              onPressed: () =>
                                  openPreview(context, 'register', 0),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => openPreview(context, 'login', 0),
                              child: const Text('LOGIN'),
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => go(context, '/gallery'),
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: dark ? Colors.white : BrightColors.muted,
                              ),
                            ),
                          ),
                          Row(
                            children: List.generate(
                              3,
                              (i) => Container(
                                width: i == 0 ? 12 : 6,
                                height: 5,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: i == 0
                                      ? BrightColors.pink
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => variant < 4
                                ? openPreview(
                                    context,
                                    'onboarding',
                                    variant + 1,
                                  )
                                : go(context, '/gallery'),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                color: dark ? Colors.white : BrightColors.ink,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _phone() => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(36),
      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 24)],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: ColoredBox(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Discover', style: heading(30)),
              const SizedBox(height: 10),
              const Text(
                'Nike     Adidas     Jordan',
                style: TextStyle(color: BrightColors.muted),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: blue,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NIKE\nEPIC-REACT',
                        style: heading(23, color: Colors.white),
                      ),
                      const Expanded(child: ShoeImage('epic_react')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class AuthPreview extends StatefulWidget {
  const AuthPreview({super.key, required this.register, required this.variant});
  final bool register;
  final int variant;
  @override
  State<AuthPreview> createState() => _AuthPreviewState();
}

class _AuthPreviewState extends State<AuthPreview> {
  final form = GlobalKey<FormState>();
  final fields = <String, TextEditingController>{};
  bool obscure = true, accepted = true;
  String country = '+44';
  bool get detail => widget.variant.isOdd;
  bool get phone =>
      widget.register && (widget.variant == 4 || widget.variant == 5);
  bool get otp =>
      widget.register && (widget.variant == 6 || widget.variant == 7);
  bool get reset => widget.register && widget.variant >= 8;
  bool get outlined => widget.variant == 2 || widget.variant == 3;
  TextEditingController controller(String key) => fields.putIfAbsent(
    key,
    () => TextEditingController(
      text: detail
          ? switch (key) {
              'Email' => 'demo@bright.app',
              'Password' => 'bright123',
              'First Name' => 'Harry',
              'Last Name' => 'Bright',
              'Username' => 'bright_demo',
              'Date of Birth' => '1996-05-20',
              'Mobile Number' => '2454561234',
              'Code' => '5274',
              _ => '',
            }
          : '',
    ),
  );
  @override
  void dispose() {
    for (final c in fields.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = reset
        ? 'Forget Password'
        : widget.register
        ? 'Create New Account'
        : widget.variant >= 4
        ? ''
        : 'Login';
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            DemoTopBar(title),
            if (!widget.register && widget.variant >= 4)
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('SIGN IN'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () => openPreview(context, 'register', 0),
                      child: const Text('REGISTER'),
                    ),
                  ),
                ],
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 25, 24, 24),
                child: Form(
                  key: form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (phone ||
                          otp ||
                          reset ||
                          (!widget.register && widget.variant == 5)) ...[
                        _logo(),
                        const SizedBox(height: 55),
                      ],
                      if (phone) ...[
                        Row(
                          children: [
                            DropdownButton<String>(
                              value: country,
                              items: ['+44', '+1', '+81', '+86']
                                  .map(
                                    (v) => DropdownMenuItem(
                                      value: v,
                                      child: Text(v),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) setState(() => country = v);
                              },
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _field(
                                'Mobile Number',
                                keyboard: TextInputType.phone,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        const Text(
                          'We need your mobile number to verify your account and to be able to get in touch.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: BrightColors.muted,
                            height: 1.8,
                          ),
                        ),
                        const SizedBox(height: 28),
                        const DemoNote('Local demo. No SMS is sent.'),
                        const SizedBox(height: 28),
                        PrimaryButton(
                          'CONTINUE',
                          onPressed: () {
                            if (form.currentState!.validate()) {
                              openPreview(context, 'register', 6);
                            }
                          },
                        ),
                      ] else if (otp) ...[
                        _codeInput(),
                        const SizedBox(height: 28),
                        const Text(
                          'Check your SMS messages, we have sent you the pin at +44 6466334',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        const DemoNote(
                          'Demo verification code: 5274. No actual message was sent.',
                        ),
                        TextButton(
                          onPressed: () =>
                              toast(context, 'Use demo code 5274.'),
                          child: const Text('Didn’t receive SMS?'),
                        ),
                        const SizedBox(height: 28),
                        PrimaryButton(
                          'VERIFY DEMO CODE',
                          onPressed: () {
                            if (List.generate(
                                  4,
                                  (i) => _digit(i).text,
                                ).join() ==
                                '5274') {
                              toast(context, 'Demo verification complete.');
                              go(context, '/gallery');
                            } else {
                              toast(context, 'Enter the demo code 5274.');
                            }
                          },
                        ),
                      ] else if (reset) ...[
                        _field('Email', keyboard: TextInputType.emailAddress),
                        const SizedBox(height: 210),
                        PrimaryButton(
                          'CONTINUE',
                          onPressed: () {
                            if (form.currentState!.validate()) {
                              toast(
                                context,
                                'Local demo: no reset email is sent.',
                              );
                            }
                          },
                        ),
                      ] else ...[
                        if (widget.register) ...[
                          if (!outlined)
                            Row(
                              children: [
                                Expanded(child: _field('First Name')),
                                const SizedBox(width: 20),
                                Expanded(child: _field('Last Name')),
                              ],
                            )
                          else ...[
                            _field('First Name'),
                            const SizedBox(height: 20),
                            _field('Last Name'),
                          ],
                          const SizedBox(height: 20),
                          if (!outlined) ...[
                            _field('Username'),
                            const SizedBox(height: 20),
                          ],
                          if (!outlined) ...[
                            _field('Date of Birth'),
                            const SizedBox(height: 20),
                          ],
                        ],
                        _field('Email', keyboard: TextInputType.emailAddress),
                        const SizedBox(height: 24),
                        _field('Password', password: true),
                        if (widget.register && outlined) ...[
                          const SizedBox(height: 20),
                          _field('Date of Birth'),
                        ],
                        const SizedBox(height: 20),
                        if (widget.register)
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: accepted,
                            onChanged: (v) => setState(() => accepted = v!),
                            title: const Text(
                              'By signing up, you agree to Terms of Use',
                              style: TextStyle(fontSize: 11),
                            ),
                          )
                        else
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () =>
                                  openPreview(context, 'register', 8),
                              child: const Text(
                                'Forget Password?',
                                style: TextStyle(
                                  color: BrightColors.muted,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 44),
                        PrimaryButton(
                          widget.register ? 'REGISTER NOW' : 'LOGIN',
                          onPressed: () {
                            if (!form.currentState!.validate()) return;
                            if (!accepted) {
                              toast(context, 'Please accept the terms.');
                              return;
                            }
                            final store = ShopScope.of(context);
                            store.email = controller('Email').text.trim();
                            store.signedIn = true;
                            store.save();
                            go(context, '/gallery');
                          },
                        ),
                        const SizedBox(height: 16),
                        if (!widget.register && widget.variant >= 2)
                          OutlinedButton(
                            onPressed: () =>
                                openPreview(context, 'register', 0),
                            child: const Text('JOIN NOW !'),
                          ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.register
                                  ? 'Already a member?'
                                  : 'Don’t have an account?',
                              style: const TextStyle(fontSize: 11),
                            ),
                            TextButton(
                              onPressed: () => openPreview(
                                context,
                                widget.register ? 'login' : 'register',
                                0,
                              ),
                              child: Text(
                                widget.register ? 'Sign in' : 'Register Now',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        if (!outlined) ...[
                          const SizedBox(height: 30),
                          Center(
                            child: Text(
                              widget.register
                                  ? 'Or Register with'
                                  : 'Or Login with',
                              style: const TextStyle(
                                fontSize: 12,
                                color: BrightColors.muted,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _social(
                                  'FACEBOOK',
                                  const Color(0xff405c99),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _social(
                                  'GOOGLE',
                                  const Color(0xffe74035),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                      const SizedBox(height: 20),
                      const Text(
                        'LOCAL DEMO · No server authentication',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9,
                          color: BrightColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logo() => Center(child: Text('Bright.', style: heading(58)));
  Widget _social(String name, Color color) => FilledButton(
    style: FilledButton.styleFrom(
      backgroundColor: color,
      padding: EdgeInsets.zero,
    ),
    onPressed: () => toast(context, '$name sign-in is not connected.'),
    child: Text(name, style: const TextStyle(fontSize: 11)),
  );
  TextEditingController _digit(int i) => fields.putIfAbsent(
    'Digit$i',
    () => TextEditingController(text: detail ? '5274'[i] : ''),
  );
  Widget _codeInput() => Row(
    children: List.generate(
      4,
      (i) => Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: i == 3 ? 0 : 18),
          child: TextFormField(
            controller: _digit(i),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: const TextStyle(fontSize: 24),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              counterText: '',
              filled: true,
              fillColor: BrightColors.canvas,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: BrightColors.line),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: BrightColors.line),
              ),
            ),
            onChanged: (v) {
              if (v.isNotEmpty && i < 3) FocusScope.of(context).nextFocus();
            },
          ),
        ),
      ),
    ),
  );
  Widget _field(
    String name, {
    bool password = false,
    TextInputType? keyboard,
  }) => TextFormField(
    controller: controller(name),
    obscureText: password && obscure,
    keyboardType: keyboard,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      labelText: name.toUpperCase(),
      border: outlined ? const OutlineInputBorder() : null,
      enabledBorder: outlined
          ? const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffcccccc)),
            )
          : null,
      focusedBorder: outlined
          ? const OutlineInputBorder(
              borderSide: BorderSide(color: BrightColors.pink),
            )
          : null,
      suffixIcon: password
          ? IconButton(
              tooltip: 'Show password',
              onPressed: () => setState(() => obscure = !obscure),
              icon: Icon(
                obscure ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                size: 18,
              ),
            )
          : null,
    ),
    validator: (v) {
      if (v == null || v.trim().isEmpty) return 'Please complete this field';
      if (name == 'Email' &&
          !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v.trim())) {
        return 'Enter a valid email';
      }
      if (password && v.length < 6) return 'Use at least 6 characters';
      if (name == 'Mobile Number' && !RegExp(r'^\d{7,15}$').hasMatch(v)) {
        return 'Enter 7–15 digits';
      }
      return null;
    },
  );
}
