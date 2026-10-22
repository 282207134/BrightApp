import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../shared/widgets.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/onboarding.webp', fit: BoxFit.cover),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x663a234f), Color(0xe63d2357)],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                const Spacer(),
                Text('Bright.', style: heading(76, color: Colors.white)),
                const SizedBox(height: 12),
                const Text(
                  'FIND YOUR NEXT STEP',
                  style: TextStyle(
                    color: Colors.white70,
                    letterSpacing: 4,
                    fontSize: 10,
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  'GET STARTED',
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/onboarding'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/home'),
                  child: const Text(
                    'Explore the collection',
                    style: TextStyle(color: Colors.white),
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

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/onboarding.webp', fit: BoxFit.cover),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Color(0xcc000000)],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/home'),
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Huge collection of all\ntype of Sneakers in\nthe world.',
                  style: heading(32, color: Colors.white),
                ),
                const SizedBox(height: 28),
                Row(
                  children: List.generate(
                    3,
                    (i) => Container(
                      margin: const EdgeInsets.only(right: 7),
                      height: 5,
                      width: i == 0 ? 28 : 7,
                      decoration: BoxDecoration(
                        color: i == 0 ? BrightColors.pink : Colors.white54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 38),
                PrimaryButton('LOGIN', onPressed: () => go(context, '/login')),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: () => go(context, '/register'),
                    child: const Text('REGISTER'),
                  ),
                ),
                const SizedBox(height: 14),
                const Center(
                  child: Text(
                    'A world of sneakers, one step away.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, this.register = false, this.reset = false});
  final bool register, reset;
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController(),
      _password = TextEditingController(),
      _name = TextEditingController();
  bool _obscure = true, _accepted = true;
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    if (widget.register && !_accepted) {
      toast(context, 'Please accept the terms to continue.');
      return;
    }
    if (widget.reset) {
      showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text('Demo reset request'),
          content: const Text(
            'This app uses a local demo account. No email is sent. You can sign in with any valid email and a password of 6+ characters.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(c);
                Navigator.pop(context);
              },
              child: const Text('BACK TO LOGIN'),
            ),
          ],
        ),
      );
      return;
    }
    final store = ShopScope.of(context);
    store.email = _email.text.trim();
    if (_name.text.trim().isNotEmpty) store.name = _name.text.trim();
    store.signedIn = true;
    store.save();
    Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.reset
        ? 'Reset Password'
        : widget.register
        ? 'Create New Account'
        : 'Login';
    return PageFrame(
      title: title,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text('Bright.', style: heading(46)),
              const SizedBox(height: 8),
              Text(
                widget.reset
                    ? 'Let’s get you back on your feet.'
                    : widget.register
                    ? 'Your next favorite pair is waiting.'
                    : 'Welcome back. Find your next step.',
                style: const TextStyle(color: BrightColors.muted),
              ),
              const SizedBox(height: 30),
              if (widget.register)
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      v!.trim().isEmpty ? 'Enter your name' : null,
                ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: (v) =>
                    RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v!.trim())
                    ? null
                    : 'Enter a valid email',
              ),
              if (!widget.reset) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _password,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      tooltip: 'Show password',
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure
                            ? CupertinoIcons.eye
                            : CupertinoIcons.eye_slash,
                      ),
                    ),
                  ),
                  validator: (v) =>
                      v!.length < 6 ? 'Use at least 6 characters' : null,
                ),
                const SizedBox(height: 8),
                if (!widget.register)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => go(context, '/reset'),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  )
                else
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _accepted,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text(
                      'I agree to the Terms of Use',
                      style: TextStyle(fontSize: 12),
                    ),
                    onChanged: (v) => setState(() => _accepted = v!),
                  ),
              ],
              const SizedBox(height: 24),
              PrimaryButton(
                widget.reset
                    ? 'CONTINUE'
                    : widget.register
                    ? 'CREATE ACCOUNT'
                    : 'LOGIN',
                onPressed: _submit,
              ),
              const SizedBox(height: 22),
              const DemoNote(
                'Local demo account. No server authentication or social sign-in is connected. Do not use a real password.',
              ),
              if (!widget.reset) ...[
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.register
                          ? 'Already a member?'
                          : 'Don’t have an account?',
                      style: const TextStyle(fontSize: 12),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        widget.register ? '/login' : '/register',
                      ),
                      child: Text(
                        widget.register ? 'Sign in' : 'Register Now',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (_) => false,
                  ),
                  child: const Text('Continue as guest'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
