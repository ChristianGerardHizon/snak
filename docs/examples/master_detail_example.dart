/// Example: State-Based Master-Detail Layout for Tablet
///
/// This demonstrates how the two-pane layout works on tablet while
/// maintaining stack-based navigation on mobile.
///
/// Key concepts:
/// 1. Single route `/patients` handles both mobile and tablet
/// 2. On tablet: selecting patient updates StateProvider (no navigation)
/// 3. On mobile: selecting patient pushes to `/patients/:id`
/// 4. Forms always push full-screen on both platforms

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

// =============================================================================
// MODELS
// =============================================================================

class Patient {
  final String id;
  final String name;
  final String species;
  final String breed;

  const Patient({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
  });
}

// =============================================================================
// PROVIDERS
// =============================================================================

/// Holds the currently selected patient for tablet master-detail view
final selectedPatientProvider = StateProvider<Patient?>((ref) => null);

/// Sample patients list
final patientsProvider = Provider<List<Patient>>((ref) => [
      const Patient(
          id: '1', name: 'Max', species: 'Dog', breed: 'Golden Retriever'),
      const Patient(id: '2', name: 'Luna', species: 'Cat', breed: 'Persian'),
      const Patient(
          id: '3', name: 'Rocky', species: 'Dog', breed: 'German Shepherd'),
    ]);

// =============================================================================
// BREAKPOINTS
// =============================================================================

class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= mobile && width < desktop;
  }

  static bool isTabletOrLarger(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= mobile;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktop;
}

// =============================================================================
// MAIN ADAPTIVE LAYOUT
// =============================================================================

/// This widget handles the adaptive layout for the patients section.
/// - Mobile: Shows only the list, tapping navigates to detail page
/// - Tablet: Shows list + detail side by side, tapping updates state
class AdaptivePatientsLayout extends HookConsumerWidget {
  const AdaptivePatientsLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTabletOrLarger = Breakpoints.isTabletOrLarger(context);
    final selectedPatient = ref.watch(selectedPatientProvider);
    final patients = ref.watch(patientsProvider);

    if (isTabletOrLarger) {
      // TABLET/DESKTOP: Two-pane layout
      return Row(
        children: [
          // Navigation Rail (simplified for example)
          const _NavigationRail(),

          // List Panel (fixed width)
          SizedBox(
            width: 280,
            child: _PatientListPanel(
              patients: patients,
              selectedId: selectedPatient?.id,
              onPatientTap: (patient) {
                // Update state, don't navigate
                ref.read(selectedPatientProvider.notifier).state = patient;
              },
            ),
          ),

          const VerticalDivider(width: 1),

          // Detail Panel (remaining space)
          Expanded(
            child: selectedPatient != null
                ? _PatientDetailPanel(
                    patient: selectedPatient,
                    onEditTap: () {
                      // Forms push full-screen even on tablet
                      context.push('/patients/${selectedPatient.id}/form');
                    },
                  )
                : const _EmptyDetailState(),
          ),
        ],
      );
    }

    // MOBILE: Single pane, navigation-based
    return Scaffold(
      appBar: AppBar(title: const Text('Patients')),
      body: _PatientListPanel(
        patients: patients,
        selectedId: null,
        onPatientTap: (patient) {
          // Navigate to detail page
          context.push('/patients/${patient.id}');
        },
      ),
      bottomNavigationBar: const _MobileBottomNav(),
    );
  }
}

// =============================================================================
// LIST PANEL
// =============================================================================

class _PatientListPanel extends StatelessWidget {
  final List<Patient> patients;
  final String? selectedId;
  final ValueChanged<Patient> onPatientTap;

  const _PatientListPanel({
    required this.patients,
    required this.selectedId,
    required this.onPatientTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search header
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
            ),
          ),
        ),

        // Patient list
        Expanded(
          child: ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              final isSelected = patient.id == selectedId;

              return ListTile(
                leading: CircleAvatar(
                  child: Text(patient.name[0]),
                ),
                title: Text(patient.name),
                subtitle: Text('${patient.species} - ${patient.breed}'),
                selected: isSelected,
                selectedTileColor:
                    Theme.of(context).colorScheme.primaryContainer,
                trailing: isSelected ? const Icon(Icons.chevron_right) : null,
                onTap: () => onPatientTap(patient),
              );
            },
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// DETAIL PANEL (for tablet)
// =============================================================================

class _PatientDetailPanel extends HookWidget {
  final Patient patient;
  final VoidCallback onEditTap;

  const _PatientDetailPanel({
    required this.patient,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    // Tab controller for the 5 tabs
    final tabController = useTabController(initialLength: 5);

    return Scaffold(
      appBar: AppBar(
        title: Text('${patient.name} - ${patient.breed}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEditTap,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Details'),
            Tab(text: 'Records'),
            Tab(text: 'Treatments'),
            Tab(text: 'Appointments'),
            Tab(text: 'Files'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          _DetailsTab(patient: patient),
          _RecordsTab(patient: patient),
          const Center(child: Text('Treatments Tab')),
          const Center(child: Text('Appointments Tab')),
          const Center(child: Text('Files Tab')),
        ],
      ),
    );
  }
}

// =============================================================================
// TAB CONTENT EXAMPLES
// =============================================================================

class _DetailsTab extends StatelessWidget {
  final Patient patient;

  const _DetailsTab({required this.patient});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient avatar and info
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                child:
                    Text(patient.name[0], style: const TextStyle(fontSize: 32)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(patient.name,
                      style: Theme.of(context).textTheme.headlineSmall),
                  Text('${patient.species} - ${patient.breed}'),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Owner section (expandable)
          ExpansionTile(
            title: const Text('Owner Information'),
            initiallyExpanded: true,
            children: const [
              ListTile(
                leading: Icon(Icons.person),
                title: Text('John Doe'),
                subtitle: Text('Owner'),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('+1234567890'),
                subtitle: Text('Phone'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text('Edit Details'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecordsTab extends StatelessWidget {
  final Patient patient;

  const _RecordsTab({required this.patient});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Sample record cards
        _RecordCard(
          date: 'Jan 15, 2024 10:30 AM',
          diagnosis: 'Annual checkup',
          weight: '25kg',
          onTap: () {
            // This would push to record detail (full-screen)
            context.push('/patients/${patient.id}/records/123');
          },
        ),
        const SizedBox(height: 8),
        _RecordCard(
          date: 'Jan 10, 2024 2:00 PM',
          diagnosis: 'Vaccination',
          weight: '24.5kg',
          onTap: () {},
        ),
      ],
    );
  }
}

class _RecordCard extends StatelessWidget {
  final String date;
  final String diagnosis;
  final String weight;
  final VoidCallback onTap;

  const _RecordCard({
    required this.date,
    required this.diagnosis,
    required this.weight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.medical_services),
        title: Text(date),
        subtitle: Text('$diagnosis\nWeight: $weight'),
        isThreeLine: true,
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(child: Text('View')),
            const PopupMenuItem(child: Text('Edit')),
            const PopupMenuItem(child: Text('Delete')),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

// =============================================================================
// EMPTY STATE
// =============================================================================

class _EmptyDetailState extends StatelessWidget {
  const _EmptyDetailState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pets,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Select a patient',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// NAVIGATION COMPONENTS
// =============================================================================

class _NavigationRail extends StatelessWidget {
  const _NavigationRail();

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: 1, // Patients selected
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.pets_outlined),
          selectedIcon: Icon(Icons.pets),
          label: Text('Patients'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.calendar_today_outlined),
          selectedIcon: Icon(Icons.calendar_today),
          label: Text('Appts'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2),
          label: Text('Products'),
        ),
      ],
      onDestinationSelected: (index) {
        // Handle navigation
      },
    );
  }
}

class _MobileBottomNav extends StatelessWidget {
  const _MobileBottomNav();

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: 1,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.dashboard), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.pets), label: 'Patients'),
        NavigationDestination(icon: Icon(Icons.calendar_today), label: 'Appts'),
        NavigationDestination(icon: Icon(Icons.inventory_2), label: 'Products'),
        NavigationDestination(icon: Icon(Icons.more_horiz), label: 'More'),
      ],
      onDestinationSelected: (index) {
        // Handle navigation
      },
    );
  }
}

// =============================================================================
// MOBILE DETAIL PAGE (separate route)
// =============================================================================

/// This is the full-screen detail page used on MOBILE only.
/// On tablet, the detail is shown inline in the right panel.
class MobilePatientDetailPage extends HookConsumerWidget {
  final String patientId;

  const MobilePatientDetailPage({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(patientsProvider);
    final patient = patients.firstWhere((p) => p.id == patientId);
    final tabController = useTabController(initialLength: 5);

    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/patients/$patientId/form'),
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Details'),
            Tab(text: 'Records'),
            Tab(text: 'Treatments'),
            Tab(text: 'Appointments'),
            Tab(text: 'Files'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          _DetailsTab(patient: patient),
          _RecordsTab(patient: patient),
          const Center(child: Text('Treatments Tab')),
          const Center(child: Text('Appointments Tab')),
          const Center(child: Text('Files Tab')),
        ],
      ),
    );
  }
}

// =============================================================================
// ROUTER CONFIGURATION
// =============================================================================

/// Example router setup showing how routes work for both mobile and tablet
final exampleRouter = GoRouter(
  routes: [
    // Main shell with navigation
    ShellRoute(
      builder: (context, state, child) {
        // The shell handles the adaptive layout
        return child;
      },
      routes: [
        // Dashboard
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Dashboard')),
          ),
        ),

        // Patients - this is where the magic happens
        GoRoute(
          path: '/patients',
          builder: (context, state) {
            // AdaptivePatientsLayout handles both mobile list
            // and tablet master-detail
            return const AdaptivePatientsLayout();
          },
          routes: [
            // Mobile-only detail page (tablet shows inline)
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;

                // On tablet, redirect back to /patients and set selection
                if (Breakpoints.isTabletOrLarger(context)) {
                  // This could also be handled with a redirect
                  return const AdaptivePatientsLayout();
                }

                return MobilePatientDetailPage(patientId: id);
              },
              routes: [
                // Form routes (always full-screen)
                GoRoute(
                  path: 'form',
                  builder: (context, state) => const Scaffold(
                    body: Center(child: Text('Patient Form (Full Screen)')),
                  ),
                ),
                GoRoute(
                  path: 'records/:recordId',
                  builder: (context, state) => const Scaffold(
                    body: Center(child: Text('Record Detail (Full Screen)')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

// =============================================================================
// USAGE EXAMPLE
// =============================================================================

/// To run this example:
///
/// ```dart
/// void main() {
///   runApp(
///     ProviderScope(
///       child: MaterialApp.router(
///         routerConfig: exampleRouter,
///         theme: ThemeData(useMaterial3: true),
///       ),
///     ),
///   );
/// }
/// ```
///
/// BEHAVIOR SUMMARY:
///
/// TABLET (width >= 600px):
/// ┌────┬─────────────────┬────────────────────────────────────┐
/// │Rail│   List Panel    │       Detail Panel                 │
/// │    │                 │  (updates via StateProvider)       │
/// │    │  [Max] ← tap    │  Shows Max's details + tabs        │
/// │    │  [Luna]         │                                    │
/// │    │  [Rocky]        │                                    │
/// └────┴─────────────────┴────────────────────────────────────┘
/// - Tapping patient updates selectedPatientProvider
/// - Detail panel reacts and shows patient
/// - URL stays at /patients (no change)
/// - Forms push to /patients/:id/form (full screen)
///
/// MOBILE (width < 600px):
/// ┌─────────────────┐     ┌─────────────────────────────────┐
/// │ Patients        │     │ ← Patient: Max                  │
/// ├─────────────────┤     ├─────────────────────────────────┤
/// │ [Max] ← tap ────────▶ │ Details│Records│...             │
/// │ [Luna]          │     │                                 │
/// │ [Rocky]         │     │ Max's details with tabs         │
/// └─────────────────┘     └─────────────────────────────────┘
///     /patients                /patients/123
/// - Tapping patient navigates via context.push
/// - Full screen detail page
/// - Back button returns to list
