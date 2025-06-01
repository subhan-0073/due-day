# ⏳ DueDay

**DueDay** is a minimal and focused deadline tracker app to help users manage **tasks, assignments, and goals** by tracking due dates and showing countdowns, built with **Flutter**.

---

## 🚀 Project Goal

Help users stay on top of deadlines by:

- Adding tasks with titles, due dates, and optional categories
- Viewing a sorted list of upcoming deadlines
- Seeing intuitive countdowns ("Due in 3 days", "Overdue by 1 day")
- Optionally receiving daily reminders
- Easily deleting tasks when completed

---

## 🛠 Tech Stack

| Layer       | Technology         | Purpose                             |
|------------ |-------------------|-------------------------------------|
| Frontend    | Flutter            | UI, routing, state management       |
| Local Storage | Hive / SharedPreferences | Persist tasks between sessions (optional) |
| Notifications | flutter_local_notifications | Daily reminders (optional)      |
| Versioning  | Git + GitHub       | Source control & collaboration      |

---

## 🧱 Architecture

### 🔄 App Flow

1. **User opens the app** and sees a list of deadlines sorted by due date  
2. **User adds new task** with title and due date (category optional)  
3. **DeadlineTile widgets** display task info and live countdowns  
4. **User deletes tasks** via long press or swipe  
5. **Optional:** Tasks persist locally and reminders are scheduled  

### 🔧 Responsibilities

- **Flutter** handles:
  - UI rendering & navigation  
  - Form inputs and validation  
  - State management using `setState` (initially)  
  - Countdown logic and date formatting  

- **Local Storage** (optional):
  - Save and retrieve tasks using Hive or SharedPreferences  

- **Notifications** (optional):
  - Remind users about tasks due today

---

## ✅ Core Features (MVP)

- Add tasks with **title** and **due date**  
- View all tasks sorted by **soonest deadline**  
- Display **live countdowns** and mark overdue tasks in red  
- Delete tasks via long press or swipe  
- Clean, minimal user interface  

---

## ✨ Bonus Features (Optional)

- 🔔 Daily notifications for tasks due today  
- 📅 Calendar date picker  
- 🌙 Dark mode toggle  
- 📂 Tags or categories  
- 📌 Pin important tasks  

---

## 🧭 Project Milestones

### 📦 Milestone 1: Initialization ✅

> Set up project and folder structure.

- [x] Flutter project created (`flutter create due_day`)  
- [x] Basic `main.dart` and home screen scaffold  

### 🏠 Milestone 2: Home Screen & Static List ✅

> Build UI to show static list of deadlines.

- [x] Create `DeadlineTile` widget  
- [x] Display hardcoded sample tasks  

### ✍️ Milestone 3: Add Task Form ✅

> Add screen to input task details.

- [x] Title input field and date picker  
- [x] Input validation  

### 🔄 Milestone 4: State Management & Add Tasks ✅

> Dynamically manage list when new task is added.

- [x] Use `setState` to update task list  
- [x] Navigate between form and home  

### 🗑 Milestone 5: Task Actions(Edit / Mark as Done / Delete) ✅

> Allow users to manage tasks using swipe and long press gesture.

- [x] Swipe right → Edit task  
- [x] Swipe left → Toggle done / not done  
- [x] Long press → Show options dialog:
  - [x] Edit Task  
  - [x] Mark as Done / Not Done  
  - [x] Delete Task with confirmation  
  - [x] Undo deletion via SnackBar  
- [x] View all tasks sorted by soonest deadline
- [x] Sorting applied whenever tasks list changes to ensure proper order

### 💾 Milestone 6: Local Persistence ✅

> Save tasks locally between app launches.

- [x] Integrate Hive  
- [x] Load saved tasks at startup  

### 🎨 Milestone 7: UI Polish & UX Refinement ✅

> Finalize all UI layouts, styling, and user experience improvements for the entire app.

- [x] Color-code task statuses: overdue (red), due soon (yellow/orange), completed (teal), pending  
- [x] Update swipe icons, action texts, and UI elements (dates, status labels, dialogs, buttons, inputs) to ensure consistent theme colors and styling
- [x] Apply responsive padding and margins across all screens
- [x] Maintain accessible font sizes, contrasts, and overall visual consistency for smooth UX

### 🔔 Milestone 8: Notifications (Optional) ⏳

> Remind users about tasks due today.

- [ ] Add flutter_local_notifications package  
- [ ] Schedule daily reminders for due tasks  
- [ ] Open app on notification tap (optional)  

---

## 🧠 Learning Goals

- 📱 Build full UI using Flutter widgets  
- 🗂 Manage app state with `setState`  
- 🕰 Handle date/time operations in Dart  
- 🧩 Design reusable widgets (like `DeadlineTile`)  
- 💾 Optionally integrate persistent local storage  
- 🔔 Schedule notifications using Flutter plugins  
- 🔀 Use Git for clean project versioning  

---

## 📂 Folder Structure (Planned)

```txt
lib/
├── main.dart
├── src/
│   ├── models/         # Deadline model
│   ├── ui/
│   │   ├── screens/    # HomeScreen, AddTaskScreen
│   │   └── widgets/    # DeadlineTile, custom buttons, etc.
│   ├── services/       # Storage or notification handlers
│   └── utils/          # Helpers for date formatting, constants
```

---

## 🧾 License

MIT © 2025 Subhan Shaikh ([@subhan-0073](https://github.com/subhan-0073))

---

## 📬 Contributions

Contributions are currently limited as this is a learning-focused solo project. Feel free to fork or follow along!

---

## 📌 Status

**IN DEVELOPMENT** — Follow the milestones for progress updates!