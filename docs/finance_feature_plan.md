# Finance Feature Plan

This document captures the requested finance feature set and the concrete work needed per feature to implement it in this repository.

## Context

The current app is a laundry-management system and the authenticated shell currently exposes only `Settings` and `Account`. This finance scope should be built as a new `finance` feature, not by extending the existing user-profile `account` feature.

Recommended feature root:

```text
lib/src/features/finance/
  data/
  domain/
  presentation/
```

Recommended primary route entry:

```text
FinanceRoute -> FinanceHomePage
```

Inside the finance area, use a local tab/navigation structure for:

- Accounts
- Categories
- Transactions
- Budget
- Overview

## Cross-Cutting Work

These are foundational tasks that should be done before or alongside the feature-specific work.

### 1. Domain and data model

Create the core finance entities first:

- `FinanceAccount`
- `TransactionCategory`
- `FinanceTransaction`
- `Budget`

Suggested fields:

#### `FinanceAccount`

- `id`
- `name`
- `type` (`regular`, `debt`, `savings`)
- `currencyCode`
- `openingBalance`
- `iconSource`
- `iconKey`
- `iconFile`
- `iconColor`
- `goalAmount` for savings accounts
- `isArchived`
- `created`
- `updated`

#### `TransactionCategory`

- `id`
- `name`
- `kind` (`expense`, `income`, `transfer`)
- `parentCategory`
- `iconSource`
- `iconKey`
- `iconFile`
- `iconColor`
- `sortOrder`
- `isArchived`
- `created`
- `updated`

#### `FinanceTransaction`

- `id`
- `date`
- `type` (`expense`, `income`, `transfer`)
- `account`
- `toAccount` for transfers
- `category`
- `amount`
- `note`
- `transferPairId`
- `created`
- `updated`

#### `Budget`

- `id`
- `month`
- `category`
- `amountLimit`
- `currencyCode`
- `created`
- `updated`

Suggested PocketBase collections:

- `finance_accounts`
- `transaction_categories`
- `finance_transactions`
- `budgets`

### 2. Rules to lock down early

Decide these before heavy UI work:

- debt balance semantics: negative stored amount vs positive amount interpreted by account type
- transfer behavior: one record with paired metadata vs two mirrored records
- category depth: single level plus subcategory vs arbitrary nesting
- balance computation: live calculation vs cached monthly snapshots
- savings goals: part of account model vs separate goal entity
- v1 currency scope: PHP-only display vs future-ready multi-currency model

### 3. Shared infrastructure

Build these once and reuse across all tabs:

- PocketBase repositories for accounts, categories, transactions, and budgets
- Riverpod controllers/providers for list and single-record access
- summary/analytics providers for totals, net worth, category distribution, and monthly reports
- shared icon renderer widget for system and custom icons
- currency formatting helpers using Peso (`₱`) by default
- date helpers for month filtering and start/end balance calculations

### 4. Navigation and shell changes

Update the authenticated shell to expose Finance as a primary destination.

Implementation tasks:

- add `FinanceRoute` in `lib/src/core/routing/routes/`
- add finance page entry point
- update `app_root.dart` primary navigation
- keep the finance internal tabs inside the finance feature, not in the global shell

### 5. Forms and generated code

Follow repository conventions:

- use `flutter_form_builder` for all create/edit forms
- use `@riverpod` or `@Riverpod(keepAlive: true)` as needed
- keep plural and singular providers in separate files
- use `dart_mappable` for domain models
- regenerate code after model/provider/route changes

Required commands during implementation:

```bash
dart run build_runner build --delete-conflicting-outputs --low-resources-mode
dart run slang
dart analyze
dart format lib/
flutter test
```

## Feature 1. Multi-Account Management

### Scope

- support Regular accounts for cash/cards
- support Debt accounts for credit/mortgage-style liabilities
- support Savings accounts for goal-based balances
- show individual balances per account
- show an “All accounts” total
- show Assets vs Debts and derived Net Worth in a “My Finances” summary

### What to do

1. Create the `FinanceAccount` domain model and repository.
2. Add account CRUD support in PocketBase.
3. Build list and single-record providers:
   - `financeAccountsController`
   - `financeAccountProvider`
4. Build account summary providers:
   - all accounts total
   - total assets
   - total debts
   - net worth
5. Create the Accounts tab UI:
   - top summary header
   - grouped account list by type
   - account cards with icon, balance, and account type
6. Add account create/edit forms:
   - name
   - type
   - opening balance
   - icon
   - savings goal amount when applicable
7. Add archive/hide behavior for inactive accounts without deleting historical transactions.

### Notes

- Do not reuse the existing user-profile account feature for this.
- Net worth logic must be covered by tests because debt interpretation can easily drift.

## Feature 2. Expense & Income Categorization

### Scope

- predefined categories such as Groceries, Restaurant, Leisure, Transport, Health, Gifts, Family, Shopping
- create and edit categories and subcategories
- rich icon library
- circular progress/chart view for spending distribution
- support both premade icons and user-provided/generated icons that visually fit the app

### What to do

1. Create the `TransactionCategory` domain model and repository.
2. Seed default categories on first run or through an admin seed process.
3. Build category CRUD providers:
   - `transactionCategoriesController`
   - `transactionCategoryProvider`
4. Implement parent-child category support for subcategories.
5. Build the Categories tab UI:
   - grouped list of categories
   - create/edit category sheet
   - subcategory management
   - summary chart at the top
6. Add chart data providers for expense distribution by category.

### Icon requirements

Support two icon sources:

- `system`: built-in premade icons
- `custom`: user-uploaded or later user-generated icons

### Icon implementation tasks

1. Add icon metadata fields to categories and accounts:
   - `iconSource`
   - `iconKey`
   - `iconFile`
   - `iconColor`
2. Build a curated premade icon picker first.
3. Group premade icons by intent:
   - food
   - shopping
   - transport
   - health
   - leisure
   - savings
   - debt
   - cash
   - cards
4. Add support for custom icons:
   - upload/import image
   - store asset/file reference
   - render in the same visual frame as premade icons
5. Normalize custom icons:
   - square crop
   - consistent padding
   - fixed display size
   - clean small-size rendering
6. Create a shared `CategoryIcon` or `FinanceIcon` widget that handles both system and custom icons.
7. Add fallback behavior when a custom icon is missing or invalid.

### Recommended rollout

- v1: premade icons only
- v1.1: uploaded custom icons
- v2: user-generated icons from a prompt, using the same storage and rendering pipeline

## Feature 3. Transaction Tracking

### Scope

- transaction logging with date, category, account, and amount
- automatic beginning and ending balance for a selected period
- month-based navigation with arrows and date picker
- search inside the Transactions tab

### What to do

1. Create the `FinanceTransaction` domain model and repository.
2. Support transaction CRUD and filtered fetch:
   - by month
   - by account
   - by category
   - by search text
3. Decide and implement transfer logic before shipping the transaction form.
4. Build transaction controllers:
   - transactions list
   - selected month
   - search query
   - account/category filters
5. Build the Transactions tab UI:
   - month header with previous/next arrows
   - month picker
   - search field
   - transaction list grouped by date
   - empty/loading/error states
6. Build create/edit transaction forms using `flutter_form_builder`.
7. Add summary providers for:
   - starting balance
   - ending balance
   - period income
   - period expenses
   - transfer totals if shown
8. Add search behavior that works on note, category name, and account name.

### Notes

- Starting and ending balances are high-risk calculations and need provider-level tests.
- Transactions should not be deleted casually if financial history matters; consider soft-delete or archive rules.

## Feature 4. Financial Planning & Analysis

### Scope

- Budget tab for category-based spending limits
- Overview tab for reports and trends
- Peso currency support

### 4A. Budget tab

#### What to do

1. Create the `Budget` domain model and repository.
2. Add monthly budget CRUD for categories.
3. Build budget providers for:
   - monthly budget list
   - actual spend per category
   - remaining amount
   - overspent state
4. Build the Budget tab UI:
   - month selector
   - category budget cards
   - progress indicators
   - create/edit budget form

### 4B. Overview tab

#### What to do

1. Build analytics providers for:
   - spending trend by month
   - income trend by month
   - net worth trend
   - expense breakdown by category
   - account composition
2. Build Overview UI cards/charts for the above metrics.
3. Keep aggregation logic out of widgets; widgets should only render provider output.

### 4C. Currency support

#### What to do

1. Start with Philippine Peso formatting in v1.
2. Store `currencyCode` on account and budget models for future expansion.
3. Use one shared money formatter so all tabs stay consistent.
4. Decide whether v1 permits only PHP data entry or only PHP display.

## Feature 5. User Interface Features

### Scope

- floating action button for quick add actions
- clean bottom navigation for Accounts, Categories, Transactions, Budget, and Overview

### What to do

1. Create a finance home page that owns the internal tab state.
2. Add a bottom navigation bar for the five finance tabs on mobile.
3. Add a tablet/desktop-appropriate variant if needed.
4. Add a context-aware FAB:
   - add account from Accounts tab
   - add category from Categories tab
   - add transaction from Transactions tab
   - add budget from Budget tab
5. Keep the FAB logic centralized so each tab only provides the action callback and label.
6. Ensure navigation state survives tab switches if that improves usability.

### Notes

- The finance feature should feel like one coherent workspace inside the existing app shell.
- Reuse core widgets only when they are truly feature-agnostic.

## Suggested Build Order

Recommended implementation order:

1. Create finance routes and feature folder structure.
2. Add domain models and PocketBase collections.
3. Add repositories and Riverpod providers/controllers.
4. Build Accounts tab.
5. Build Transactions tab.
6. Build Categories tab and chart.
7. Build Budget tab.
8. Build Overview tab.
9. Add custom icon support.
10. Add UX polish, empty states, loading states, and validation improvements.

## Testing Checklist

Add tests as each piece lands.

Priority areas:

- account total calculations
- assets vs debts vs net worth math
- month filtering
- starting balance and ending balance calculations
- transfer handling
- budget vs actual calculations
- category aggregation for charts
- fallback rendering for missing custom icons

Suggested test areas:

- repository tests for finance data operations
- provider tests for derived financial calculations
- widget tests for key summaries and navigation behavior

## Suggested Milestones

### Milestone 1

- finance feature scaffolding
- routes
- account model/repository/providers
- Accounts tab basic UI

### Milestone 2

- transaction model/repository/providers
- Transactions tab
- month navigation
- starting/ending balance calculations

### Milestone 3

- category model/repository/providers
- predefined categories
- premade icon picker
- Categories tab chart

### Milestone 4

- budget model/repository/providers
- Budget tab
- Overview analytics tab

### Milestone 5

- custom uploaded icons
- UI polish
- broader tests

### Milestone 6

- optional generated icon support
- advanced analytics refinements
- performance optimization if aggregation becomes heavy
