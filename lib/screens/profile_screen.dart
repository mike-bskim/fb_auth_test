import 'package:fb_auth_test/providers/profile/profile_state.dart';
import 'package:fb_auth_test/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../providers/profile/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileProvider profileProvider;
  late final void Function() _removeListener;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileProvider = context.read<ProfileProvider>();
    _removeListener = profileProvider.addListener(errorDialogListener,
        fireImmediately: false);
    _getProfile();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // profileProvider.removeListener(errorDialogListener);
    _removeListener();
    super.dispose();
  }

  void errorDialogListener(ProfileState state) {
    if (state.profileStatus == ProfileStatus.error) {
      // errorDialog(context, profileProvider.state.error);
      errorDialog(context, state.error);
    }
  }

  void _getProfile() {
    final String uid = context.read<fb_auth.User?>()!.uid;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().getProfile(uid: uid);
    });
  }

  Widget _buildProfile() {
    // final profileState = context.watch<ProfileProvider>().state;
    final profileState = context.watch<ProfileState>();
    if (profileState.profileStatus == ProfileStatus.initial) {
      return Container();
    } else if (profileState.profileStatus == ProfileStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (profileState.profileStatus == ProfileStatus.error) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/error.png',
                width: 75, height: 75, fit: BoxFit.cover),
            const SizedBox(width: 20.0),
            const Text(
              'Ooops!\nTry again',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, color: Colors.red),
            ),
          ],
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInImage.assetNetwork(
              placeholder: 'assets/images/loading.gif',
              image: profileState.user.profileImage,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('- id: ${profileState.user.id}',
                      style: const TextStyle(fontSize: 18.0)),
                  const SizedBox(height: 10.0),
                  Text('- name: ${profileState.user.name}',
                      style: const TextStyle(fontSize: 18.0)),
                  const SizedBox(height: 10.0),
                  Text('- email: ${profileState.user.email}',
                      style: const TextStyle(fontSize: 18.0)),
                  const SizedBox(height: 10.0),
                  Text('- point: ${profileState.user.point}',
                      style: const TextStyle(fontSize: 18.0)),
                  const SizedBox(height: 10.0),
                  Text('- rank: ${profileState.user.rank}',
                      style: const TextStyle(fontSize: 18.0)),
                  const SizedBox(height: 10.0),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _buildProfile(),
    );
  }
}
