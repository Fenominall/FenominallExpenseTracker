# FenominallExpenseTracker App

Welcome to FenominallExpenseTracker! This iOS application helps you manage your finances efficiently by tracking your expenses and income. With a user-friendly interface, it's easier than ever to keep your budget in check.

# Features:
- Add Transactions: Easily log your expenses or income with just a few taps.
- Search: Quickly find any transaction using the integrated search feature.
- Chart: Visualize your financial data with clear, easy-to-understand charts.
- Categories: Choose from predefined categories or create your own custom categories for better organization.
- Local Storage: All your data is securely stored on your device using CoreData, ensuring access even without a network connection.

#
### BDD Specs

## Expense Tracker Feed Feature Specs

### Story: Customer requests to see their transactions feed

### Narrative #1

```
As an offline user,
I want the app to automatically load the latest transactions feed,
So I can always track my expenses in the app.
```

#### Scenarios (Acceptance criteria)

```
Given the customer doesn't have connectivity
When the customer requests to see the transactions feed
Then the app should display the latest feed from the disk

Given the customer doesn't have connectivity
And there is no cached transactions feed on the disk
When the customer requests to see the transactions feed
Then the app should display a message indicating that no transactions are available
```

---

## Model Specs

### Transaction

| Property      | Type                  |
|---------------|-----------------------|
| `id`          | `UUID`                |
| `title`       | `String`              |
| `remarks`     | `String` (optional)   |
| `amount`      | `Double`              |
| `dateAdded`   | `Date`                |
| `type`        | `TransactionType`     |
| `category`    | `TransactionCategory` |

### TransactionType

| Property  | Type     |
|-----------|----------|
| `income`  | `String` |
| `expense` | `String` |

### TransactionCategory Protocol

| Property         | Type              |
|------------------|----------------   |
| `id`             | `UUID`            |  
| `name`           | `String`          |
| `hexColor`       | `String`          |
| `imageData`      | `String?`         |
| `transactionType`| `TransactionType` |


## Use Cases

### Load Feed From Cache Use Case

#### Primary course:
1. Execute "Load Transactions Feed" command with above data.
2. System retrieves feed data from cache.
3. System creates transactions feed from cached data.
4. System delivers transaction feed.

#### Retrieval error course (sad path):
1. System delivers error.

#### Empty cache course (sad path): 
1. System delivers no feed.

---

# Load Transactions Feed FlowChart

### Cache Transactions Use Case

#### Data:
- Transactions

#### Primary course (happy path):
1. Execute "Save Transactions" command with above data.
2. System encodes articles feed.
3. System saves new transactions data.
4. System delivers success message.

#### Saving error course (sad path):
1. System delivers error.

---

### Update Transactions Use Case

#### Data:
- Transactions

#### Primary course (happy path):
1. Execute "Update Transactions" command with above data.
2. System retrieves transactions data from cache.
3. System updates transactions data.
4. System saves new transactions data.
5. System delivers success message.

#### Updating error course (sad path):
1. System delivers error.

---

### Delete Transactions Use Case

#### Data:
- Transactions

#### Primary course (happy path):
1. Execute "Delete Transactions" command with above data.
2. System retrieves transactions data from cache.
3. System deletes transactions data.
4. System delivers success message.

#### Deleting error course (sad path):
1. System delivers error.

---
