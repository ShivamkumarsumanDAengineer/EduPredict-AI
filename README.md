# EduPredict AI — Student Performance Prediction, Tracking & AI Study Buddy

EduPredict AI is a professional, high-precision academic intelligence Flutter application designed for students, educators, and institutional mentors. Built in strict accordance with the official **EduPredict AI Design System** (`DESIGN.md`), the application mirrors the corporate-modern, high-density SaaS aesthetic with crystal-clear information hierarchies and responsive data visualization.

---

## 🚀 Key Features

### 1. Student Dashboard (`Home`)
- **Student Profile & Model Sync Banner:** Live model status, confidence score (88.4%), and academic health indicators.
- **Key Metrics 2x2 Grid:** Predicted GPA (`3.84/4.0`), Attendance (`91.5%`), Completed Assignments (`18/20`), and Weekly Study Hours (`26.5h / 28h target`).
- **Adaptive AI Intervention Card:** Smart insight detecting upcoming exams and suggesting targeted preparation time to increase predicted scores from 78% to 87%. Includes interactive schedule generator.
- **ML Performance Trajectory Chart:** Custom-painted line/area graph visualizing historical GPA (Sem 1 – Sem 4) and projected ML trajectory (Sem 5 – Sem 6) with confidence bands and $R^2 = 0.94$ regression fit.
- **Upcoming Assessments:** Countdown timer cards for Operating Systems Final (9 days left) and Data Mining & BI (16 days left) with expected score projections and syllabus review shortcuts.
- **Quick Interventions:** Direct shortcuts to the What-If Simulator, Study Hours logger, Daily Timetable modal, and PDF Export.

### 2. ML Performance Predictor & Simulator (`Predict`)
- **Random Forest Regressor Engine:** Model specifications ($R^2 = 0.924$, $\text{MAE} = 2.18$) and live sync indicator.
- **Forecast Final Result Hero Card:** Hero metric display (`87.4 / 100`), 95% uncertainty band (`[85.1 - 89.7%]`), Distinction Grade badge (`A`), and sigmoid pass probability (`97.8%` Low Risk).
- **Interactive "What-If" Projections:** Instant delta buttons (`+5h Study/Week` for $+3.2\%$ and `100% Homework` for $+1.8\%$).
- **Predictive Feature Sliders:**
  - Attendance Rate ($60\% - 100\%$, threshold indicator at $75\%$)
  - Weekly Dedicated Study Hours (stepper and slider, $5 - 50\text{ hrs}$)
  - Internal Assessment Average ($40 - 100$)
  - Homework & Tasks Completion ($50\% - 100\%$)
  - Rest & Well-being Score ($4 - 10\text{ hrs/night}$)
- **Re-calculate Button & Subject Breakdown:** Live coursework score estimates across DSA (91%), OS (82%), DBMS (89%), and AI/ML (94%).
- **Intervention Plan Modal:** Tailored prescriptive steps generated from active simulation values.

### 3. Academic Diagnostics & Tracker (`Tracker`)
- **Segmented Diagnostic Views:** Attendance, Assignments, Quizzes, and Timetable.
- **Attendance Radial Gauge:** Radial progress gauge ($91.5\%$) with Tier 1 standing validation ($89/97$ logged sessions).
- **Subject-wise Roll Call:** Individual class attendance cards with color-coded risk markers and attendance goal notifications.
- **Weekly Study Hours Bar Chart:** Interactive day-by-day bar chart (M, T, W, T, F, S, S) showing study hours and peak study days.
- **Assignment & Quiz Tracking:** Submission management and vulnerability detection alerts (e.g. Quiz 3 OS Page Replacement at 62%).

### 4. AI Study Buddy & Recommender (`Buddy`)
- **Diagnostic Focus & Vulnerability Detection:** Critical focus warnings for detected weak areas alongside validated strong subjects.
- **Live Academic Tutoring Chat Stream:** Interactive tutor conversation offering 3-day recovery sprints, architectural explanations (Page Faults, LRU, Peterson's algorithm), and knowledge checks.
- **Instant Intervention Chips:** Quick-tap prompts (`Explain Page Faults simply`, `Generate 4-day revision schedule`, `Quiz me on Semaphores`, `Estimate score if I study 3h tonight`).
- **Personalized 3-Day Recovery Checklist:** Interactive task tracker for Virtual Memory, Paging Algorithms, and Mock Exam diagnostics.

### 5. Settings & Profile (`Settings`)
- **Student Profile:** Student ID, program, semester, and institution details.
- **Academic Targets:** Target GPA slider with benchmark indicators.
- **Engine Configuration:** Model selection (Random Forest, XGBoost, Bayesian Neural Network), Live Sync toggles, and Canvas LMS synchronization.

---

## 🎨 Design System Implementation

The application strictly implements the design specifications in `DESIGN.md`:
- **Palette:** Royal Blue (`#004AC6` / `#2563EB`), Deep Navy (`#0B1C30` / `#565E74`), AI Purple (`#632ECD` / `#7D4CE7`), and Slate surfaces (`#F8F9FF` canvas, `#FFFFFF` cards, `#E2E8F0` borders).
- **Typography:** Plus Jakarta Sans for KPI displays, metric values, and headlines; Inter for body copy, micro-labels, and tabular statistics.
- **Shapes & Elevation:** 16px (`rounded-xl`) card radii, 8px button radii, ambient micro-shadows, and pill tags (`9999px`).

---

## 🛠 Running the Application

Once Flutter SDK is available on your machine:
```bash
# Get dependencies
flutter pub get

# Run on Chrome (Web)
flutter run -d chrome

# Run on Windows Desktop
flutter run -d windows
```

