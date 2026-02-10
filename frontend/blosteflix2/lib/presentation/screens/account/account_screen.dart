import 'package:blosteflix2/presentation/providers/auth_providers.dart';
import 'package:blosteflix2/presentation/providers/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  bool _didLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoad) {
      _didLoad = true;
      Future.microtask(() => ref.read(authControllerProvider.notifier).refreshUserDetails());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    return SafeArea(
      top: true,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  child: Icon(Icons.person, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Usuario',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? 'Sin email',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (authState.status == AuthStatus.loading)
              const Center(child: CircularProgressIndicator()),
            if (authState.errorMessage != null) ...[
              Text(
                authState.errorMessage!,
                style: TextStyle(color: Colors.redAccent.shade100),
              ),
              const SizedBox(height: 8),
            ],
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.badge_outlined),
                    title: const Text('Nombre'),
                    subtitle: Text(user?.name ?? 'No disponible'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.alternate_email),
                    title: const Text('Email'),
                    subtitle: Text(user?.email ?? 'No disponible'),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => ref.read(authControllerProvider.notifier).logout(),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
