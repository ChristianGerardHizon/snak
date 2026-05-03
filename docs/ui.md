# UI Structure - Tablet & Mobile

This document outlines the responsive UI structure for tablet and mobile devices, including navigation patterns and routing architecture.

---

## Table of Contents
- [Responsive Breakpoints](#responsive-breakpoints)
- [Mobile Layout](#mobile-layout)
- [Tablet Layout](#tablet-layout)
- [Navigation Hierarchy](#navigation-hierarchy)
- [Routing Structure](#routing-structure)
- [Component Architecture](#component-architecture)
- [Navigation Configuration](#navigation-configuration)

---

## Responsive Breakpoints

```
┌─────────────────────────────────────────────────────────────────┐
│                        BREAKPOINTS                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  0px          600px         900px        1200px       1600px    │
│  │             │             │             │             │      │
│  │   MOBILE    │   TABLET    │   TABLET    │  DESKTOP    │      │
│  │  (compact)  │  (medium)   │   (large)   │  (expanded) │      │
│  │             │             │             │             │      │
│  │ Bottom Nav  │   Nav Rail  │ Expanded    │ Full Side   │      │
│  │ + Drawer    │   (icons)   │ Rail+labels │ Menu        │      │
│  │             │             │             │             │      │
│  │ Single Col  │ Master-Det  │ Master-Det  │ Multi-panel │      │
│  │ Layout      │ Optional    │ Always      │ Layout      │      │
│  │             │             │             │             │      │
└─────────────────────────────────────────────────────────────────┘
```

| Breakpoint | Range | Layout Type | Navigation |
|------------|-------|-------------|------------|
| Mobile     | 0-599px | Single column | Bottom Nav + Drawer |
| Tablet Medium | 600-899px | Master-detail (optional) | Navigation Rail (icons) |
| Tablet Large | 900-1199px | Master-detail (always) | Expanded Rail (icons + labels) |
| Desktop | 1200px+ | Multi-panel | Collapsible Side Menu |

---

## Mobile Layout

### Main Structure (< 600px)

```
┌─────────────────────────────────────┐
│ ☰  Page Title              [Actions]│  <- App Bar with hamburger menu
├─────────────────────────────────────┤
│                                     │
│                                     │
│                                     │
│           CONTENT AREA              │
│                                     │
│                                     │
│                                     │
│                                     │
├─────────────────────────────────────┤
│  🏠    👤    📅    📦    ⋯         │  <- Bottom Navigation (5 items)
│ Home Patient Appts Prods More       │
└─────────────────────────────────────┘
```

### Mobile Drawer (accessed via hamburger or "More")

```
┌───────────────────────┐
│  ╭─────╮              │
│  │ LOGO│   App Name   │
│  ╰─────╯              │
├───────────────────────┤
│ 🏠 Dashboard          │
├───────────────────────┤
│ 👤 Patients        ▶  │
│   ├─ All Patients     │
│   ├─ Records          │
│   └─ Treatments       │
├───────────────────────┤
│ ⚙️ Patient Config  ▶  │
│   ├─ Species          │
│   └─ Treatments       │
├───────────────────────┤
│ 📅 Appointments    ▶  │
│   ├─ All              │
│   └─ Calendar         │
├───────────────────────┤
│ 📦 Products        ▶  │
│   ├─ All Products     │
│   ├─ Inventories      │
│   ├─ Categories       │
│   └─ Adjustments      │
├───────────────────────┤
│ 💰 Sales              │
│   └─ Cashier          │
├───────────────────────┤
│ 🏢 Organization    ▶  │
│   ├─ Admins           │
│   ├─ Users            │
│   └─ Branches         │
├───────────────────────┤
│ ⚙️ System          ▶  │
│   ├─ Settings         │
│   ├─ Change Logs      │
│   └─ Your Account     │
├───────────────────────┤
│ 🚪 Logout             │
└───────────────────────┘
```

---

## Tablet Layout

### Portrait Mode - Navigation Rail + Content (600px - 900px)

```
┌────┬──────────────────────────────────────────┐
│    │  Page Title                    [Actions] │
│ 🏠 ├──────────────────────────────────────────┤
│    │                                          │
│ 👤 │                                          │
│    │                                          │
│ 📅 │              CONTENT AREA                │
│    │                                          │
│ 📦 │                                          │
│    │                                          │
│ 💰 │                                          │
│    │                                          │
│ 🏢 │                                          │
│    │                                          │
│ ⚙️ │                                          │
│    │                                          │
│────│                                          │
│ 👤 │                                          │  <- User avatar at bottom
└────┴──────────────────────────────────────────┘
  ↑
Navigation Rail (72px width, icons only)
```

### Landscape Mode - Expanded Rail + Content (900px - 1200px)

```
┌──────────┬────────────────────────────────────────────────────┐
│          │  Page Title                              [Actions] │
│ 🏠 Home  ├────────────────────────────────────────────────────┤
│          │                                                    │
│ 👤 Patie │                                                    │
│          │                                                    │
│ 📅 Appts │                                                    │
│          │                 CONTENT AREA                       │
│ 📦 Prods │                                                    │
│          │                                                    │
│ 💰 Sales │                                                    │
│          │                                                    │
│ 🏢 Org   │                                                    │
│          │                                                    │
│ ⚙️ Syst  │                                                    │
│──────────│                                                    │
│ 👤 User  │                                                    │
└──────────┴────────────────────────────────────────────────────┘
     ↑
Navigation Rail Expanded (160px width, icons + labels)
```

### Tablet Master-Detail Layout (List Views)

```
┌────┬─────────────────┬────────────────────────────────────┐
│    │ Patients        │  Patient Detail                    │
│ 🏠 ├─────────────────┤────────────────────────────────────┤
│    │ 🔍 Search...    │  Name: Max                         │
│ 👤 ├─────────────────┤  Species: Dog                      │
│    │ ┌─────────────┐ │  Breed: Golden Retriever           │
│ 📅 │ │ Max       ▶ │ │                                    │
│    │ │ Dog         │ │  ┌────────────────────────────┐    │
│ 📦 │ └─────────────┘ │  │ Records  Appts  Files      │    │
│    │ ┌─────────────┐ │  └────────────────────────────┘    │
│ 💰 │ │ Luna        │ │                                    │
│    │ │ Cat         │ │  Recent Records:                   │
│ 🏢 │ └─────────────┘ │  ┌──────────────────────────────┐  │
│    │ ┌─────────────┐ │  │ Vaccination - 2024-01-15     │  │
│ ⚙️ │ │ Rocky       │ │  │ Checkup - 2024-01-10         │  │
│    │ │ Dog         │ │  └──────────────────────────────┘  │
└────┴─────────────────┴────────────────────────────────────┘
 Rail    List Panel          Detail Panel
(72px)    (280px)            (Remaining)
```

---

## Navigation Hierarchy

```
                              ┌─────────────────┐
                              │   App Shell     │
                              │  (StatefulShell)│
                              └────────┬────────┘
                                       │
        ┌──────────────────────────────┼──────────────────────────────┐
        │                              │                              │
        ▼                              ▼                              ▼
┌───────────────┐          ┌───────────────────┐          ┌───────────────┐
│   Primary     │          │    Secondary      │          │    System     │
│  Navigation   │          │   Navigation      │          │   Navigation  │
└───────┬───────┘          └─────────┬─────────┘          └───────┬───────┘
        │                            │                            │
   ┌────┴────┐                  ┌────┴────┐                  ┌────┴────┐
   │         │                  │         │                  │         │
   ▼         ▼                  ▼         ▼                  ▼         ▼
┌──────┐ ┌────────┐      ┌──────────┐ ┌────────┐      ┌────────┐ ┌──────────┐
│ Home │ │Patients│      │ Products │ │  Appts │      │ Org    │ │ System   │
└──────┘ └────┬───┘      └────┬─────┘ └────┬───┘      └────┬───┘ └────┬─────┘
              │               │            │               │          │
         ┌────┴────┐     ┌────┴────┐   ┌───┴───┐      ┌────┴────┐  ┌──┴───┐
         │         │     │         │   │       │      │         │  │      │
         ▼         ▼     ▼         ▼   ▼       ▼      ▼         ▼  ▼      ▼
      ┌─────┐ ┌───────┐ ┌────┐ ┌─────┐ List Calendar  Admins  Users Settings
      │List │ │Config │ │Inv │ │Cats │                Branches     Account
      └─────┘ └───────┘ └────┘ └─────┘
```

---

## Routing Structure

### Complete Route Tree

```
/                                    -> Dashboard
│
├── /patients                        -> Patients List
│   ├── /patients/:id                -> Patient Detail
│   ├── /patients/form               -> Patient Form
│   ├── /patients/records/:id        -> Record Detail
│   ├── /patients/records/form       -> Record Form
│   ├── /patients/treatment-records  -> Treatment Records List
│   ├── /patients/treatment-records/:id -> Treatment Record Detail
│   ├── /patients/treatment-records/form -> Treatment Record Form
│   ├── /patients/prescriptions/form -> Prescription Form
│   ├── /patients/files/form         -> File Form
│   └── /patients/appointments       -> Patient Appointments
│
├── /patient-config                  -> Patient Config Landing
│   ├── /patient-config/species      -> Species List
│   ├── /patient-config/species/:id  -> Species Detail
│   ├── /patient-config/species/form -> Species Form
│   ├── /patient-config/breeds/form  -> Breed Form
│   ├── /patient-config/treatments   -> Treatments List
│   └── /patient-config/treatments/form -> Treatment Form
│
├── /products                        -> Products List
│   ├── /products/:id                -> Product Detail
│   ├── /products/form               -> Product Form
│   ├── /products/inventories        -> Inventories List
│   ├── /products/stocks/:id         -> Stock Detail
│   ├── /products/stocks/form        -> Stock Form
│   ├── /products/categories         -> Categories List
│   ├── /products/categories/:id     -> Category Detail
│   ├── /products/categories/form    -> Category Form
│   ├── /products/adjustments        -> Adjustments List
│   └── /products/adjustments/form   -> Adjustment Form
│
├── /appointments                    -> Appointments List
│   ├── /appointments/:id            -> Appointment Detail
│   ├── /appointments/form           -> Appointment Form
│   ├── /appointments/by-date        -> By Date View
│   └── /appointments/calendar       -> Calendar View
│
├── /organization                    -> Organization Landing
│   ├── /organization/admins         -> Admins List
│   ├── /organization/admins/:id     -> Admin Detail
│   ├── /organization/admins/form    -> Admin Form
│   ├── /organization/users          -> Users List
│   ├── /organization/users/:id      -> User Detail
│   ├── /organization/users/form     -> User Form
│   ├── /organization/branches       -> Branches List
│   ├── /organization/branches/:id   -> Branch Detail
│   └── /organization/branches/form  -> Branch Form
│
├── /system                          -> System Landing
│   ├── /system/settings             -> Settings
│   ├── /system/domain               -> Domain Config
│   ├── /system/change-logs          -> Change Logs List
│   ├── /system/change-logs/:id      -> Change Log Detail
│   ├── /system/change-logs/form     -> Change Log Form
│   └── /system/account              -> Your Account
│
├── /cashier                         -> Cashier/POS
│
└── /auth (non-shell routes)
    ├── /login/user                  -> User Login
    ├── /login/admin                 -> Admin Login
    ├── /email/validation            -> Email Validation
    ├── /recovery                    -> Account Recovery
    └── /account                     -> Account Page
```

### Shell Branches (8 Total)

| Branch | Base Route | Description |
|--------|------------|-------------|
| Dashboard | `/` | Home/entry point |
| Patients | `/patients` | Patient management |
| Patient Config | `/patient-config` | Species, breeds, treatments catalog |
| Products | `/products` | Inventory management |
| Appointments | `/appointments` | Scheduling |
| Organization | `/organization` | Admin, users, branches |
| System | `/system` | Settings, change logs, account |
| Sales | `/cashier` | Cashier/POS operations |

---

## Component Architecture

### Shell Widget Structure

```
AdaptiveShell
├── MobileShell (< 600px)
│   ├── Scaffold
│   │   ├── AppBar (with drawer toggle)
│   │   ├── Body (content)
│   │   ├── BottomNavigationBar (5 items)
│   │   └── Drawer (MobileDrawer)
│
├── TabletShell (600px - 1200px)
│   ├── Row
│   │   ├── NavigationRail
│   │   │   ├── Leading (Logo)
│   │   │   ├── Destinations (7 items)
│   │   │   └── Trailing (User Avatar)
│   │   └── Expanded
│   │       └── Scaffold
│   │           ├── AppBar
│   │           └── Body (content or Master-Detail)
│
└── DesktopShell (> 1200px)
    └── Row
        ├── SideMenu (collapsible, 80-200px)
        └── Expanded
            └── Scaffold
                ├── AppBar
                └── Body (content)
```

### Adaptive List-Detail Layout

```
AdaptiveListDetail
├── Mobile: Stack-based navigation (push detail)
│   ┌─────────────────┐     ┌─────────────────┐
│   │     List        │ --> │     Detail      │
│   │                 │     │                 │
│   └─────────────────┘     └─────────────────┘
│
├── Tablet: Side-by-side (permanent)
│   ┌─────────┬───────────────┐
│   │  List   │    Detail     │
│   │         │               │
│   └─────────┴───────────────┘
│
└── Desktop: Multi-panel
    ┌─────────┬───────────────┬──────────┐
    │  List   │    Detail     │  Actions │
    │         │               │  Panel   │
    └─────────┴───────────────┴──────────┘
```

---

## Navigation Configuration

### Primary Navigation (always visible in bottom nav/rail)

| Icon | Label | Route | Priority |
|------|-------|-------|----------|
| 🏠 | Dashboard | `/` | 1 |
| 👤 | Patients | `/patients` | 2 |
| 📅 | Appointments | `/appointments` | 3 |
| 📦 | Products | `/products` | 4 |

### Secondary Navigation (rail/drawer only)

| Icon | Label | Route | Priority |
|------|-------|-------|----------|
| 💰 | Sales | `/cashier` | 5 |
| 🏢 | Organization | `/organization` | 6 |
| ⚙️ | System | `/system` | 7 |

### Mobile "More" Menu Items

| Icon | Label | Route |
|------|-------|-------|
| ⚙️ | Patient Config | `/patient-config` |
| 💰 | Cashier | `/cashier` |
| 🏢 | Organization | `/organization` |
| ⚙️ | Settings | `/system/settings` |
| 👤 | Your Account | `/system/account` |
| 🚪 | Logout | (action) |

---

## Patient Detail - Records, Treatments & Files

The Patient Detail page (`/patients/:id`) uses a **5-tab interface** with adaptive handling for mobile vs tablet.

### Tab Structure

```
Patient Detail Page
├── Tab 0: Details       -> PatientDetailsView (patient info, owner, actions)
├── Tab 1: Records       -> PatientRecordsPage (medical visit records)
├── Tab 2: Treatments    -> PatientTreatmentRecordsPage (treatment tracking)
├── Tab 3: Appointments  -> AppointmentSchedulesPage (patient appointments)
└── Tab 4: Files         -> PatientFilesPage (documents, images)
```

### Data Relationships

```
Patient (master)
│
├── PatientRecord (medical visits)
│   ├── visitDate, diagnosis, treatment, tests
│   ├── temperature, weightInKg, notes
│   └── PatientPrescriptionItem[] (medications)
│       └── date, medication, dosage, instructions
│
├── PatientTreatmentRecord (treatment tracking)
│   ├── treatment (FK -> PatientTreatment catalog)
│   ├── date, notes
│   └── expand: { treatment.name, treatment.icon }
│
├── PatientFile (attachments)
│   ├── file (filename), notes
│   └── isImage (computed)
│
└── AppointmentSchedule[] (via patient FK)
```

### Mobile - Patient Detail (< 600px)

```
┌─────────────────────────────────────┐
│ <-  Patient: Max             [Edit] │  <- AppBar with back + actions
├─────────────────────────────────────┤
│ Details│Records│Treat│Appts│Files  │  <- Scrollable TabBar
├─────────────────────────────────────┤
│                                     │
│  ╭───────────╮                      │
│  │   Avatar  │  Max                 │
│  │           │  Golden Retriever    │
│  ╰───────────╯  Dog                 │
│                                     │
│  ┌─────────────────────────────────┐│
│  │ Owner Information            v ││  <- Expandable sections
│  │ Name: John Doe                 ││
│  │ Phone: +1234567890             ││
│  └─────────────────────────────────┘│
│                                     │
│  [Edit Details]  [Delete]           │
│                                     │
├─────────────────────────────────────┤
│  🏠    👤    📅    📦    ...       │
└─────────────────────────────────────┘
```

### Mobile - Records Tab

```
┌─────────────────────────────────────┐
│ <-  Patient: Max             [+ Add]│
├─────────────────────────────────────┤
│ Details│Records│Treat│Appts│Files  │
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ 🩺  Jan 15, 2024 10:30 AM      │ │  <- PatientRecordCard
│ │    Diagnosis: Annual checkup   │ │
│ │    Weight: 25kg                │ │
│ │                            [...│ │  <- Actions menu
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ 🩺  Jan 10, 2024 2:00 PM       │ │
│ │    Diagnosis: Vaccination      │ │
│ │    Weight: 24.5kg              │ │
│ └─────────────────────────────────┘ │
│                                     │
│ [+ Create New Record]               │  <- FAB or button
└─────────────────────────────────────┘
```

### Tablet - Patient Detail (Tabbed Detail Panel)

```
┌────┬─────────────────┬────────────────────────────────────┐
│    │ Patients        │  ┌──────────────────────────────┐  │
│ 🏠 ├─────────────────┤  │ Max - Golden Retriever  [...│  │
│    │ 🔍 Search...    │  ├──────────────────────────────┤  │
│ 👤 ├─────────────────┤  │ Details│Records│Treat│Files │  │  <- Tabs in detail panel
│    │ ┌─────────────┐ │  ├──────────────────────────────┤  │
│ 📅 │ │ Max       > │ │  │                              │  │
│    │ │ Dog         │ │  │  ╭─────╮  Name: Max          │  │
│ 📦 │ └─────────────┘ │  │  │ Img │  Species: Dog       │  │
│    │ ┌─────────────┐ │  │  ╰─────╯  Breed: G.Retriever │  │
│ 💰 │ │ Luna        │ │  │                              │  │
│    │ │ Cat         │ │  │  Owner: John Doe             │  │
│ 🏢 │ └─────────────┘ │  │  Phone: +1234567890          │  │
│    │ ┌─────────────┐ │  │                              │  │
│ ⚙️ │ │ Rocky       │ │  │  [Edit]  [Delete]            │  │
│    │ │ Dog         │ │  │                              │  │
└────┴─────────────────┴──┴──────────────────────────────┴──┘
 Rail    List Panel              Detail with Tabs
(72px)    (280px)                (Remaining)
```

### Navigation Flow

**Mobile (stack-based):**
```
Patients List -> Patient Detail (tabs) -> Record Detail -> Prescription Form
      |              |                        |                |
   /patients    /patients/:id         /patients/records/:id   /patients/prescriptions/form
```

**Tablet (panel-based with full-screen forms):**
- Selecting patient updates detail panel (no navigation)
- Forms (edit patient, add record, etc.) push as full-screen routes
- Back navigation returns to master-detail view

### Record Detail Layout

**Mobile:**
```
┌─────────────────────────────────────┐
│ <-  Record: Jan 15, 2024     [Save] │
├─────────────────────────────────────┤
│                                     │
│  Visit Date                         │
│  ┌─────────────────────────────────┐│
│  │ 📅 January 15, 2024 10:30 AM   ││
│  └─────────────────────────────────┘│
│                                     │
│  Temperature        Weight (kg)     │
│  ┌──────────────┐  ┌──────────────┐ │
│  │ 38.5 C       │  │ 25           │ │
│  └──────────────┘  └──────────────┘ │
│                                     │
│  Diagnosis                          │
│  ┌─────────────────────────────────┐│
│  │ Annual health checkup...       ││
│  └─────────────────────────────────┘│
│                                     │
│  -- Prescriptions -----------------│
│  ┌─────────────────────────────────┐│
│  │ Medication A - 2x daily        ││
│  │ Medication B - 1x daily        ││
│  │                       [+ Add]  ││
│  └─────────────────────────────────┘│
│                                     │
│  [Delete Record]                    │
└─────────────────────────────────────┘
```

**Tablet (full-screen form):**
```
┌────────────────────────────────────────────────────┐
│ Record: Jan 15, 2024                    [X] [Save] │
├────────────────────────────────────────────────────┤
│  ┌────────────────────┬───────────────────────┐   │
│  │ Visit Date         │ Temperature           │   │
│  │ 📅 Jan 15, 10:30   │ 38.5 C               │   │
│  ├────────────────────┼───────────────────────┤   │
│  │ Weight (kg)        │ Tests Done            │   │
│  │ 25                 │ Blood panel, X-ray    │   │
│  └────────────────────┴───────────────────────┘   │
│                                                    │
│  Diagnosis                                         │
│  ┌────────────────────────────────────────────┐   │
│  │ Annual health checkup completed...         │   │
│  └────────────────────────────────────────────┘   │
│                                                    │
│  Prescriptions                          [+ Add]   │
│  ┌────────────────────────────────────────────┐   │
│  │ Medication A  │ 10mg  │ 2x daily   │ [...│   │
│  │ Medication B  │ 5mg   │ 1x daily   │ [...│   │
│  └────────────────────────────────────────────┘   │
│                                                    │
│  [Print Prescription]  [Delete]                   │
└────────────────────────────────────────────────────┘
```

### Design Decisions

**Layout: Tabbed Detail Panel**
- Patient list on left panel
- Detail panel with tabs (Details/Records/Treatments/Appointments/Files) on right
- Simpler implementation, matches current PatientPage structure
- Tabs stay within the detail panel, not as nested columns

**Forms: Full-screen Push Navigation**
- All forms (edit patient, add record, add prescription) navigate to full-screen pages
- Consistent behavior across mobile and tablet
- Simpler back navigation handling

### Implementation Considerations

1. **Tab State Preservation**: Use `AutomaticKeepAliveClientMixin` to preserve tab content
2. **Master-Detail Sync**: Selecting a patient updates detail panel without navigation
3. **Form Navigation**: Forms push as full-screen routes on all device sizes
4. **Responsive Tables**: `SliverDynamicTableView` already handles mobile card vs desktop table
5. **Deep Linking**: Support `/patients/:id?page=1` to open specific tab directly

---

## Implementation Notes

### Key Files

| File | Purpose |
|------|---------|
| `lib/src/core/pages/app_root.dart` | Main shell widget |
| `lib/src/core/widgets/mobile_bottom_nav.dart` | Bottom navigation |
| `lib/src/core/widgets/mobile_drawer.dart` | Mobile drawer |
| `lib/src/core/controllers/nav_items_controller.dart` | Navigation items |
| `lib/src/core/routing/routes/_root.routes.dart` | Shell routes |

### Recommended New Files

| File | Purpose |
|------|---------|
| `lib/src/core/widgets/adaptive_shell.dart` | Unified adaptive shell |
| `lib/src/core/widgets/tablet_nav_rail.dart` | Navigation rail for tablet |
| `lib/src/core/widgets/adaptive_list_detail.dart` | Master-detail layout |
| `lib/src/core/utils/breakpoints.dart` | Centralized breakpoint definitions |
