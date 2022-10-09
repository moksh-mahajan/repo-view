import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show Provider, StateNotifierProvider;
import 'package:repo_viewer/auth/application/auth_notifier.dart';
import 'package:repo_viewer/auth/infrastructure/credentials_storage/credentials_storage.dart';
import 'package:repo_viewer/auth/infrastructure/credentials_storage/secure_storage_credentials.dart';
import 'package:repo_viewer/auth/infrastructure/github_authenticator.dart';

final flutterSecureStorageProvider = Provider(
  (_) => const FlutterSecureStorage(),
);

final dioProvider = Provider(
  (_) => Dio(),
);

final credentialsStorageProvider = Provider<CredentialsStorage>(
  (ref) => SecureCredentialsStorage(
    ref.read(flutterSecureStorageProvider),
  ),
);

final githubAuthenticatorProvider = Provider(
  (ref) => GithubAuthenticator(
    ref.read(credentialsStorageProvider),
    ref.read(dioProvider),
  ),
);

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(
    ref.read(githubAuthenticatorProvider),
  ),
);