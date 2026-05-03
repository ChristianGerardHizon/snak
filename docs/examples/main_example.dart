/// Runnable Example: URL-Based Master-Detail Layout with Tab Routing
///
/// Run with: flutter run -t lib/main_example.dart
///
/// Features:
/// - URL reflects selected patient: /patients/1
/// - URL includes tab: /patients/1?tab=records
/// - Nested record detail: /patients/1/records/r1
/// - Deep linking support: share URLs directly to specific tabs or records
/// - Browser back/forward works (including tab changes)
/// - Tablet: Two-pane layout (list + detail)
/// - Mobile: Stack navigation
/// - context.push() for record detail (stacks on navigation)
/// - context.go() for tab changes (replaces current route)

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp.router(
        title: 'Master-Detail Example',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

// =============================================================================
// MODELS
// =============================================================================

class Patient {
  final String id;
  final String name;
  final String species;
  final String breed;
  final String ownerName;
  final String ownerPhone;

  const Patient({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.ownerName,
    required this.ownerPhone,
  });
}

class PatientRecord {
  final String id;
  final String patientId;
  final DateTime date;
  final String diagnosis;
  final String weight;
  final String temperature;
  final String? notes;

  const PatientRecord({
    required this.id,
    required this.patientId,
    required this.date,
    required this.diagnosis,
    required this.weight,
    required this.temperature,
    this.notes,
  });
}

class Prescription {
  final String id;
  final String recordId;
  final String medication;
  final String dosage;
  final String frequency;
  final String? duration;
  final String? instructions;

  const Prescription({
    required this.id,
    required this.recordId,
    required this.medication,
    required this.dosage,
    required this.frequency,
    this.duration,
    this.instructions,
  });

  Prescription copyWith({
    String? id,
    String? recordId,
    String? medication,
    String? dosage,
    String? frequency,
    String? duration,
    String? instructions,
  }) {
    return Prescription(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      medication: medication ?? this.medication,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      instructions: instructions ?? this.instructions,
    );
  }
}

// =============================================================================
// PROVIDERS
// =============================================================================

/// Sample patients list
final patientsProvider = Provider<List<Patient>>((ref) => const [
      Patient(
        id: '1',
        name: 'Max',
        species: 'Dog',
        breed: 'Golden Retriever',
        ownerName: 'John Doe',
        ownerPhone: '+1234567890',
      ),
      Patient(
        id: '2',
        name: 'Luna',
        species: 'Cat',
        breed: 'Persian',
        ownerName: 'Jane Smith',
        ownerPhone: '+0987654321',
      ),
      Patient(
        id: '3',
        name: 'Rocky',
        species: 'Dog',
        breed: 'German Shepherd',
        ownerName: 'Bob Wilson',
        ownerPhone: '+1122334455',
      ),
      Patient(
        id: '4',
        name: 'Whiskers',
        species: 'Cat',
        breed: 'Siamese',
        ownerName: 'Alice Brown',
        ownerPhone: '+5566778899',
      ),
      Patient(
        id: '5',
        name: 'Buddy',
        species: 'Dog',
        breed: 'Labrador',
        ownerName: 'Charlie Davis',
        ownerPhone: '+9988776655',
      ),
    ]);

/// Sample patient records
final patientRecordsProvider = Provider<List<PatientRecord>>((ref) => [
      // Records for Max (patient 1)
      PatientRecord(
        id: 'r1',
        patientId: '1',
        date: DateTime(2024, 1, 15, 10, 30),
        diagnosis: 'Annual checkup - All vitals normal',
        weight: '25kg',
        temperature: '38.5°C',
        notes: 'Patient is healthy. Recommended annual vaccination.',
      ),
      PatientRecord(
        id: 'r2',
        patientId: '1',
        date: DateTime(2024, 1, 10, 14, 0),
        diagnosis: 'Vaccination - Rabies booster',
        weight: '24.5kg',
        temperature: '38.2°C',
        notes: 'Administered rabies booster. No adverse reactions.',
      ),
      PatientRecord(
        id: 'r3',
        patientId: '1',
        date: DateTime(2023, 12, 5, 11, 0),
        diagnosis: 'Minor skin irritation - Prescribed ointment',
        weight: '24.8kg',
        temperature: '38.4°C',
        notes: 'Skin irritation on left hind leg. Prescribed topical treatment for 7 days.',
      ),
      // Records for Luna (patient 2)
      PatientRecord(
        id: 'r4',
        patientId: '2',
        date: DateTime(2024, 1, 20, 9, 0),
        diagnosis: 'Dental cleaning',
        weight: '4.2kg',
        temperature: '38.8°C',
        notes: 'Routine dental cleaning performed. Minor tartar buildup removed.',
      ),
      PatientRecord(
        id: 'r5',
        patientId: '2',
        date: DateTime(2023, 11, 15, 15, 30),
        diagnosis: 'Annual vaccination',
        weight: '4.0kg',
        temperature: '38.6°C',
      ),
    ]);

/// Sample prescriptions - StateProvider for mutability (add/edit/delete)
final prescriptionsProvider = StateProvider<List<Prescription>>((ref) => [
      // Prescriptions for record r1 (Max's annual checkup)
      const Prescription(
        id: 'p1',
        recordId: 'r1',
        medication: 'Heartworm Prevention',
        dosage: '1 tablet',
        frequency: 'Monthly',
        duration: '12 months',
        instructions: 'Give with food on the same day each month.',
      ),
      // Prescriptions for record r3 (Max's skin irritation)
      const Prescription(
        id: 'p2',
        recordId: 'r3',
        medication: 'Hydrocortisone Cream',
        dosage: 'Apply thin layer',
        frequency: '2x daily',
        duration: '7 days',
        instructions: 'Apply to affected area. Prevent licking for 10 minutes after application.',
      ),
      const Prescription(
        id: 'p3',
        recordId: 'r3',
        medication: 'Apoquel',
        dosage: '16mg',
        frequency: '1x daily',
        duration: '14 days',
        instructions: 'For itching relief. May be given with or without food.',
      ),
      // Prescription for record r4 (Luna's dental cleaning)
      const Prescription(
        id: 'p4',
        recordId: 'r4',
        medication: 'Amoxicillin',
        dosage: '50mg',
        frequency: '2x daily',
        duration: '7 days',
        instructions: 'Antibiotic post dental procedure. Give with food.',
      ),
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

  static bool isTabletOrLarger(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= mobile;
}

// =============================================================================
// TAB DEFINITIONS - Maps tab names to indices
// =============================================================================

/// Tab names for URL routing
enum PatientTab {
  details,
  records,
  treatments,
  appointments,
  files;

  /// Convert tab name string to enum
  static PatientTab fromString(String? name) {
    return PatientTab.values.firstWhere(
      (tab) => tab.name == name,
      orElse: () => PatientTab.details,
    );
  }
}

// =============================================================================
// ROUTER - URL-based with ShellRoute
// =============================================================================

final _router = GoRouter(
  initialLocation: '/patients',
  routes: [
    // ShellRoute wraps patient routes with adaptive layout
    ShellRoute(
      builder: (context, state, child) {
        // The shell provides the adaptive layout
        // child is either the list page or detail page based on route
        return AdaptivePatientsShell(
          currentPath: state.uri.path,
          queryParams: state.uri.queryParameters,
          child: child,
        );
      },
      routes: [
        // Patient list route
        GoRoute(
          path: '/patients',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: PatientListPage(),
          ),
          routes: [
            // Patient detail route - URL shows /patients/1?tab=records
            GoRoute(
              path: ':id',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                // Read tab from query parameter: ?tab=records
                final tabName = state.uri.queryParameters['tab'];
                final tab = PatientTab.fromString(tabName);
                return NoTransitionPage(
                  child: PatientDetailPage(
                    patientId: id,
                    initialTab: tab,
                  ),
                );
              },
              routes: [
                // Form route (full-screen, outside shell)
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => Scaffold(
                    appBar: AppBar(title: const Text('Edit Patient')),
                    body: const Center(
                      child: Text(
                        'Patient Edit Form\n(Full screen on all devices)',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                // Record detail route - /patients/:id/records/:recordId
                GoRoute(
                  path: 'records/:recordId',
                  builder: (context, state) {
                    final patientId = state.pathParameters['id']!;
                    final recordId = state.pathParameters['recordId']!;
                    return RecordDetailPage(
                      patientId: patientId,
                      recordId: recordId,
                    );
                  },
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
// ADAPTIVE SHELL - Handles two-pane on tablet
// =============================================================================

class AdaptivePatientsShell extends ConsumerWidget {
  final String currentPath;
  final Map<String, String> queryParams;
  final Widget child;

  const AdaptivePatientsShell({
    super.key,
    required this.currentPath,
    required this.queryParams,
    required this.child,
  });

  /// Extract patient ID from path like /patients/1
  String? _extractPatientId(String path) {
    final match = RegExp(r'/patients/(\w+)').firstMatch(path);
    return match?.group(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTabletOrLarger = Breakpoints.isTabletOrLarger(context);
    final selectedId = _extractPatientId(currentPath);
    final patients = ref.watch(patientsProvider);
    final isDetailRoute = selectedId != null;

    if (isTabletOrLarger) {
      // TABLET: Two-pane layout - list always visible + detail on right
      return Scaffold(
        body: Row(
          children: [
            // Navigation Rail
            const _NavigationRail(),

            // List Panel (always visible on tablet)
            SizedBox(
              width: 300,
              child: _PatientListPanel(
                patients: patients,
                selectedId: selectedId,
                onPatientTap: (patient) {
                  // Navigate to patient route - URL updates to /patients/1
                  context.go('/patients/${patient.id}');
                },
              ),
            ),

            const VerticalDivider(width: 1),

            // Detail Panel - shows child or empty state
            Expanded(
              child: isDetailRoute
                  ? child // GoRouter provides the detail page
                  : const _EmptyDetailState(),
            ),
          ],
        ),
      );
    }

    // MOBILE: Single pane - show either list or detail based on route
    if (isDetailRoute) {
      // Mobile showing detail - child is PatientDetailPage
      return child;
    }

    // Mobile showing list
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const _MobileDrawer(),
      body: _PatientListPanel(
        patients: patients,
        selectedId: null,
        onPatientTap: (patient) {
          // Navigate to detail - pushes on mobile
          context.go('/patients/${patient.id}');
        },
      ),
      bottomNavigationBar: const _MobileBottomNav(),
    );
  }
}

// =============================================================================
// PATIENT LIST PAGE (for GoRouter child)
// =============================================================================

class PatientListPage extends ConsumerWidget {
  const PatientListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This is rendered as the child when at /patients
    // On tablet, it's not directly shown (shell shows list panel)
    // On mobile, this is what gets displayed
    final patients = ref.watch(patientsProvider);

    return _PatientListPanel(
      patients: patients,
      selectedId: null,
      onPatientTap: (patient) {
        context.go('/patients/${patient.id}');
      },
    );
  }
}

// =============================================================================
// PATIENT DETAIL PAGE (for GoRouter child)
// =============================================================================

class PatientDetailPage extends HookConsumerWidget {
  final String patientId;
  final PatientTab initialTab;

  const PatientDetailPage({
    super.key,
    required this.patientId,
    this.initialTab = PatientTab.details,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(patientsProvider);
    final patient = patients.firstWhere(
      (p) => p.id == patientId,
      orElse: () => patients.first,
    );

    // Initialize tab controller with the tab from URL
    final tabController = useTabController(
      initialLength: 5,
      initialIndex: initialTab.index,
    );
    final isTablet = Breakpoints.isTabletOrLarger(context);

    // Sync tab changes to URL
    useEffect(() {
      void listener() {
        final newTab = PatientTab.values[tabController.index];
        // Only update URL if tab actually changed (avoid loops)
        final currentTabName = GoRouterState.of(context).uri.queryParameters['tab'];
        if (newTab.name != currentTabName && newTab != PatientTab.details) {
          // Update URL with new tab (details is default, so omit from URL)
          context.go('/patients/$patientId?tab=${newTab.name}');
        } else if (newTab == PatientTab.details && currentTabName != null) {
          // Remove tab param when going back to details
          context.go('/patients/$patientId');
        }
      }

      tabController.addListener(listener);
      return () => tabController.removeListener(listener);
    }, [tabController]);

    // Sync URL changes to tab (for browser back/forward)
    useEffect(() {
      if (tabController.index != initialTab.index) {
        tabController.animateTo(initialTab.index);
      }
      return null;
    }, [initialTab]);

    return Scaffold(
      appBar: AppBar(
        // On tablet, no back button (list is always visible)
        // On mobile, show back button
        automaticallyImplyLeading: !isTablet,
        leading: isTablet
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/patients'),
              ),
        title: Text('${patient.name} - ${patient.breed}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/patients/$patientId/edit'),
            tooltip: 'Edit Patient',
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
          const _PlaceholderTab(title: 'Treatments', icon: Icons.healing),
          const _PlaceholderTab(title: 'Appointments', icon: Icons.calendar_today),
          const _PlaceholderTab(title: 'Files', icon: Icons.folder),
        ],
      ),
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
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Row(
            children: [
              Text(
                'Patients',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              Text(
                '${patients.length} total',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),

        // Search
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search patients...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
              filled: true,
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
                  backgroundColor: patient.species == 'Dog'
                      ? Colors.brown.shade100
                      : Colors.orange.shade100,
                  child: Icon(
                    patient.species == 'Dog' ? Icons.pets : Icons.pest_control,
                    color: patient.species == 'Dog'
                        ? Colors.brown
                        : Colors.orange,
                  ),
                ),
                title: Text(
                  patient.name,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
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
// TAB CONTENT
// =============================================================================

class _DetailsTab extends StatelessWidget {
  final Patient patient;

  const _DetailsTab({required this.patient});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient info card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: patient.species == 'Dog'
                        ? Colors.brown.shade100
                        : Colors.orange.shade100,
                    child: Icon(
                      patient.species == 'Dog' ? Icons.pets : Icons.pest_control,
                      size: 40,
                      color: patient.species == 'Dog'
                          ? Colors.brown
                          : Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.name,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${patient.species} - ${patient.breed}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Owner section
          Text(
            'Owner Information',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(patient.ownerName),
                  subtitle: const Text('Owner'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(patient.ownerPhone),
                  subtitle: const Text('Phone'),
                  trailing: IconButton(
                    icon: const Icon(Icons.call),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Actions
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
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecordsTab extends ConsumerWidget {
  final Patient patient;

  const _RecordsTab({required this.patient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRecords = ref.watch(patientRecordsProvider);
    // Filter records for this patient
    final patientRecords = allRecords.where((r) => r.patientId == patient.id).toList();

    if (patientRecords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No records yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add record form would open here')),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add First Record'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: patientRecords.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final record = patientRecords[index];
        final dateStr = _formatDate(record.date);
        return _RecordCard(
          recordId: record.id,
          patientId: patient.id,
          date: dateStr,
          diagnosis: record.diagnosis,
          weight: record.weight,
          temperature: record.temperature,
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[date.month - 1];
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    return '$month ${date.day}, ${date.year} $hour:$minute $amPm';
  }
}

class _RecordCard extends StatelessWidget {
  final String recordId;
  final String patientId;
  final String date;
  final String diagnosis;
  final String weight;
  final String temperature;

  const _RecordCard({
    required this.recordId,
    required this.patientId,
    required this.date,
    required this.diagnosis,
    required this.weight,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Navigate to record detail using push (full-screen)
          context.push('/patients/$patientId/records/$recordId');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.medical_services,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 8),
              Text(diagnosis),
              const SizedBox(height: 8),
              Row(
                children: [
                  Chip(
                    avatar: const Icon(Icons.monitor_weight, size: 16),
                    label: Text(weight),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    avatar: const Icon(Icons.thermostat, size: 16),
                    label: Text(temperature),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// RECORD DETAIL PAGE - Full-screen page for viewing a single record
// =============================================================================

class RecordDetailPage extends ConsumerWidget {
  final String patientId;
  final String recordId;

  const RecordDetailPage({
    super.key,
    required this.patientId,
    required this.recordId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(patientsProvider);
    final records = ref.watch(patientRecordsProvider);

    final patient = patients.firstWhere(
      (p) => p.id == patientId,
      orElse: () => patients.first,
    );

    final record = records.firstWhere(
      (r) => r.id == recordId,
      orElse: () => records.first,
    );

    final dateStr = '${_monthName(record.date.month)} ${record.date.day}, ${record.date.year}';
    final timeStr = '${record.date.hour}:${record.date.minute.toString().padLeft(2, '0')} ${record.date.hour >= 12 ? 'PM' : 'AM'}';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('Record: $dateStr'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit form
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit record form would open here')),
              );
            },
            tooltip: 'Edit Record',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              // Show delete confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delete confirmation would show here')),
              );
            },
            tooltip: 'Delete Record',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient info header
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: patient.species == 'Dog'
                          ? Colors.brown.shade100
                          : Colors.orange.shade100,
                      child: Icon(
                        patient.species == 'Dog' ? Icons.pets : Icons.pest_control,
                        color: patient.species == 'Dog' ? Colors.brown : Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patient.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '${patient.species} - ${patient.breed}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Visit date & time
            Text(
              'Visit Information',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20),
                        const SizedBox(width: 12),
                        Text('$dateStr at $timeStr'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Vitals
            Text(
              'Vitals',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.monitor_weight, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            record.weight,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            'Weight',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.thermostat, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            record.temperature,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            'Temperature',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Diagnosis
            Text(
              'Diagnosis',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(record.diagnosis),
              ),
            ),

            if (record.notes != null) ...[
              const SizedBox(height: 24),

              // Notes
              Text(
                'Notes',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(record.notes!),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Prescriptions section
            _PrescriptionsSection(recordId: recordId),

            const SizedBox(height: 32),

            // Actions
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Print functionality would be here')),
                    );
                  },
                  icon: const Icon(Icons.print),
                  label: const Text('Print Record'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

// =============================================================================
// PRESCRIPTION WIDGETS
// =============================================================================

/// Section widget that displays prescriptions for a record
class _PrescriptionsSection extends ConsumerWidget {
  final String recordId;

  const _PrescriptionsSection({required this.recordId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allPrescriptions = ref.watch(prescriptionsProvider);
    final recordPrescriptions = allPrescriptions
        .where((p) => p.recordId == recordId)
        .toList();

    void deletePrescription(Prescription prescription) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Prescription'),
          content: Text('Delete "${prescription.medication}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                ref.read(prescriptionsProvider.notifier).state = allPrescriptions
                    .where((p) => p.id != prescription.id)
                    .toList();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Prescription deleted'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Prescriptions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            FilledButton.tonalIcon(
              onPressed: () => showPrescriptionSheet(
                context,
                recordId: recordId,
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (recordPrescriptions.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.medication_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No prescriptions',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap "Add" to create a prescription',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...recordPrescriptions.map(
            (prescription) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _PrescriptionCard(
                prescription: prescription,
                onEdit: () => showPrescriptionSheet(
                  context,
                  recordId: recordId,
                  existingPrescription: prescription,
                ),
                onDelete: () => deletePrescription(prescription),
              ),
            ),
          ),
      ],
    );
  }
}

/// Card widget displaying a single prescription
class _PrescriptionCard extends StatelessWidget {
  final Prescription prescription;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PrescriptionCard({
    required this.prescription,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.medication,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prescription.medication,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${prescription.dosage} • ${prescription.frequency}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (prescription.duration != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Duration: ${prescription.duration}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                  if (prescription.instructions != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      prescription.instructions!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet for adding/editing prescriptions
class _AddPrescriptionSheet extends HookConsumerWidget {
  final String recordId;
  final Prescription? existingPrescription; // null for new, non-null for edit

  const _AddPrescriptionSheet({
    required this.recordId,
    this.existingPrescription,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = existingPrescription != null;

    // Form controllers
    final medicationController = useTextEditingController(
      text: existingPrescription?.medication ?? '',
    );
    final dosageController = useTextEditingController(
      text: existingPrescription?.dosage ?? '',
    );
    final durationController = useTextEditingController(
      text: existingPrescription?.duration ?? '',
    );
    final instructionsController = useTextEditingController(
      text: existingPrescription?.instructions ?? '',
    );

    // Frequency dropdown state
    final selectedFrequency = useState<String>(
      existingPrescription?.frequency ?? '1x daily',
    );

    final formKey = useMemoized(() => GlobalKey<FormState>());

    void savePrescription() {
      if (!formKey.currentState!.validate()) return;

      final newPrescription = Prescription(
        id: existingPrescription?.id ?? 'p${DateTime.now().millisecondsSinceEpoch}',
        recordId: recordId,
        medication: medicationController.text.trim(),
        dosage: dosageController.text.trim(),
        frequency: selectedFrequency.value,
        duration: durationController.text.trim().isEmpty
            ? null
            : durationController.text.trim(),
        instructions: instructionsController.text.trim().isEmpty
            ? null
            : instructionsController.text.trim(),
      );

      final prescriptions = ref.read(prescriptionsProvider);

      if (isEditing) {
        // Update existing
        ref.read(prescriptionsProvider.notifier).state = prescriptions
            .map((p) => p.id == existingPrescription!.id ? newPrescription : p)
            .toList();
      } else {
        // Add new
        ref.read(prescriptionsProvider.notifier).state = [
          ...prescriptions,
          newPrescription,
        ];
      }

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing ? 'Prescription updated' : 'Prescription added'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                isEditing ? 'Edit Prescription' : 'Add Prescription',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),

              // Medication field
              TextFormField(
                controller: medicationController,
                decoration: const InputDecoration(
                  labelText: 'Medication *',
                  hintText: 'e.g., Amoxicillin',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medication),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter medication name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Dosage and Frequency row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dosage
                  Expanded(
                    child: TextFormField(
                      controller: dosageController,
                      decoration: const InputDecoration(
                        labelText: 'Dosage *',
                        hintText: 'e.g., 250mg',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Frequency dropdown
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedFrequency.value,
                      decoration: const InputDecoration(
                        labelText: 'Frequency *',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: '1x daily', child: Text('1x daily')),
                        DropdownMenuItem(value: '2x daily', child: Text('2x daily')),
                        DropdownMenuItem(value: '3x daily', child: Text('3x daily')),
                        DropdownMenuItem(value: '4x daily', child: Text('4x daily')),
                        DropdownMenuItem(value: 'Every 4 hours', child: Text('Every 4 hrs')),
                        DropdownMenuItem(value: 'Every 6 hours', child: Text('Every 6 hrs')),
                        DropdownMenuItem(value: 'Every 8 hours', child: Text('Every 8 hrs')),
                        DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                        DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
                        DropdownMenuItem(value: 'As needed', child: Text('As needed')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          selectedFrequency.value = value;
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Duration field
              TextFormField(
                controller: durationController,
                decoration: const InputDecoration(
                  labelText: 'Duration',
                  hintText: 'e.g., 7 days, 2 weeks',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Instructions field
              TextFormField(
                controller: instructionsController,
                decoration: const InputDecoration(
                  labelText: 'Instructions',
                  hintText: 'e.g., Take with food',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: savePrescription,
                      child: Text(isEditing ? 'Update' : 'Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows the add/edit prescription bottom sheet at the root level
void showPrescriptionSheet(
  BuildContext context, {
  required String recordId,
  Prescription? existingPrescription,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: true, // Show at root level, covers entire screen including side nav
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => _AddPrescriptionSheet(
      recordId: recordId,
      existingPrescription: existingPrescription,
    ),
  );
}

class _PlaceholderTab extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderTab({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            '$title Tab',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Content would go here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
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
            size: 80,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Select a patient',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a patient from the list to view details',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
      selectedIndex: 1,
      labelType: NavigationRailLabelType.all,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.local_hospital,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
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
        NavigationRailDestination(
          icon: Icon(Icons.point_of_sale_outlined),
          selectedIcon: Icon(Icons.point_of_sale),
          label: Text('Sales'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.business_outlined),
          selectedIcon: Icon(Icons.business),
          label: Text('Org'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('System'),
        ),
      ],
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CircleAvatar(
              child: Text('JD'),
            ),
          ),
        ),
      ),
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

class _MobileDrawer extends StatelessWidget {
  const _MobileDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.local_hospital,
                    size: 30,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Vet Clinic',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'Management System',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
          ),
          const ListTile(
            leading: Icon(Icons.pets),
            title: Text('Patients'),
            selected: true,
          ),
          const ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Appointments'),
          ),
          const ListTile(
            leading: Icon(Icons.inventory_2),
            title: Text('Products'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.point_of_sale),
            title: Text('Cashier'),
          ),
          const ListTile(
            leading: Icon(Icons.business),
            title: Text('Organization'),
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('System'),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
