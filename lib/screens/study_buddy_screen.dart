import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/chat_message.dart';
import '../models/study_plan_item.dart';

class StudyBuddyScreen extends StatefulWidget {
  const StudyBuddyScreen({super.key});

  @override
  State<StudyBuddyScreen> createState() => _StudyBuddyScreenState();
}

class _StudyBuddyScreenState extends State<StudyBuddyScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      text:
          "Hi Shivam! Based on your upcoming OS exam and recent quiz marks (62%), I've mapped a 3-day recovery sprint for Memory Hierarchy & Virtual Memory.\n\nWould you like me to generate practice flashcards or explain Paging vs Segmentation with architectural diagrams?",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      confidenceScore: 98.4,
      recoveryTopic: 'Operating Systems • Memory Hierarchy',
    ),
  ];

  List<StudyPlanItem> _studyPlan = [
    const StudyPlanItem(
      dayNumber: 1,
      dateString: 'Today • 2.5 hrs',
      title: 'Virtual Memory & Multi-Level Page Tables',
      duration: '2.5 hrs',
      objective: 'Core architecture, Translation Lookaside Buffer (TLB) miss latency.',
      isCompleted: true,
    ),
    const StudyPlanItem(
      dayNumber: 2,
      dateString: 'Tomorrow • 2.0 hrs',
      title: 'Page Replacement Algorithms (LRU, FIFO, Clock)',
      duration: '2.0 hrs',
      objective: 'Belady\'s Anomaly analysis and practice frame allocation problems.',
      isCompleted: false,
    ),
    const StudyPlanItem(
      dayNumber: 3,
      dateString: 'Friday • 1.5 hrs',
      title: 'Mock Semester Exam Diagnostic',
      duration: '1.5 hrs',
      objective: 'Timed 30-question adaptive assessment targeting 85%+ score.',
      isCompleted: false,
    ),
  ];

  final List<String> _quickPrompts = [
    'Explain Page Faults simply',
    'Generate 4-day revision schedule',
    'Quiz me on Semaphores',
    'Estimate score if I study 3h tonight',
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _textController.clear();
    });

    _scrollToBottom();

    // AI automated intelligent response
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      String response = "I'm analyzing your request against your academic model...";
      final lower = text.toLowerCase();

      if (lower.contains('page fault')) {
        response =
            "A **Page Fault** is an interrupt raised by hardware when a program tries to access a memory page that is currently not mapped into physical RAM (it's sitting in secondary swap storage).\n\n"
            "**Steps the OS takes:**\n"
            "1. Hardware traps to OS kernel\n"
            "2. OS locates page on disk\n"
            "3. Finds or frees a physical frame (invokes LRU/FIFO if RAM full)\n"
            "4. Reads page into frame\n"
            "5. Updates page table & restarts instruction!";
      } else if (lower.contains('revision schedule') || lower.contains('schedule')) {
        response =
            "Here is your optimized 4-day high-yield revision roadmap:\n"
            "• **Day 1:** Memory Management & Inverted Page Tables (2h)\n"
            "• **Day 2:** Process Synchronization & Peterson's Algorithm (2h)\n"
            "• **Day 3:** Deadlock Avoidance (Banker's Algorithm) (1.5h)\n"
            "• **Day 4:** Comprehensive Mock Test & Formula Sheet (2h)\n\n"
            "Following this schedule shifts your predicted OS grade from 82% to 89%!";
      } else if (lower.contains('semaphore') || lower.contains('quiz')) {
        response =
            "Quick Knowledge Check! 🧠\n\n"
            "**Question:** What happens when process P calls `wait(S)` (or `P(S)`) on a counting semaphore `S` whose current integer value is `0`?\n\n"
            "A) It decrements S to -1 and immediately continues\n"
            "B) It enters the waiting/blocked queue until another process calls `signal(S)`\n"
            "C) A CPU deadlock exception is raised\n\n"
            "Reply with your answer!";
      } else if (lower.contains('3h') || lower.contains('tonight')) {
        response =
            "📈 **Simulation Output:**\n"
            "If you dedicate +3.0 hours to Operating Systems tonight:\n"
            "• OS Expected Score: **82% ➔ 86.5%**\n"
            "• Semester GPA Forecast: **3.84 ➔ 3.87**\n"
            "• Batch Rank Projection: Moves from Top 8% into **Top 5%**!";
      } else {
        response =
            "I've updated your learning profile with this inquiry. I recommend reviewing Section 8.3 of your syllabus before tomorrow's lecture for optimal retention.";
      }

      setState(() {
        _messages.add(
          ChatMessage(
            id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
            text: response,
            isUser: false,
            timestamp: DateTime.now(),
            confidenceScore: 97.6,
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI Summary copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Greeting & Model Status Ribbon
            _buildStatusRibbon(),
            const SizedBox(height: 14),

            // 2. Diagnostic Focus Areas (Critical & Strong)
            _buildFocusAreas(),
            const SizedBox(height: 14),

            // 3. Live Academic Tutoring Conversation Area
            _buildChatArea(),
            const SizedBox(height: 14),

            // 4. Quick Suggestion Prompts
            _buildQuickPrompts(),
            const SizedBox(height: 10),

            // 5. Chat Input Field
            _buildChatInput(),
            const SizedBox(height: 16),

            // 6. AI Generated Personalized Study Plan Card
            _buildStudyPlanSection(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRibbon() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: AppColors.tertiaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.smart_toy, color: Colors.white, size: 22),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('AI Study Buddy & Recommender', style: AppTypography.headlineSm),
                  SizedBox(height: 2),
                  Text(
                    'Powered by EduPredict Intelligence • Online',
                    style: AppTypography.bodySm,
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Diagnostics model: Gemini EduPredict v3.4')),
              );
            },
            icon: const Icon(Icons.insights, color: AppColors.onSurfaceVariant, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusAreas() {
    return Column(
      children: [
        // Focus Area: Weakness Detection
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'CRITICAL FOCUS AREA',
                        style: TextStyle(
                          fontFamily: AppTypography.fontBody,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Quiz 3: 62%',
                      style: TextStyle(
                        fontFamily: AppTypography.fontBody,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Operating Systems • Virtual Memory & Page Replacement',
                style: AppTypography.titleMd,
              ),
              const SizedBox(height: 4),
              const Text(
                'Estimated vulnerability based on recent sub-topic regression test. High priority for upcoming semester exam.',
                style: AppTypography.bodySm,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.62,
                        backgroundColor: AppColors.surfaceContainer,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.error),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('Goal: 85%', style: AppTypography.labelSm),
                ],
              ),
            ],
          ),
        ),

        // Strong Subject Mastery
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.verified, color: AppColors.primaryContainer, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'STRONG SUBJECT MASTERY',
                        style: TextStyle(
                          fontFamily: AppTypography.fontBody,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '94%+ Average',
                      style: TextStyle(
                        fontFamily: AppTypography.fontBody,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'AI & Data Science (Supervised Learning & Feature Pipelines)',
                style: AppTypography.titleMd,
              ),
              const SizedBox(height: 4),
              const Text(
                'Optimal retention detected across 4 consecutive labs. Recommend allocating surplus time towards OS recovery.',
                style: AppTypography.bodySm,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Row(
              children: [
                Icon(Icons.psychology, color: AppColors.tertiary, size: 18),
                SizedBox(width: 6),
                Text('Live Academic Tutoring', style: AppTypography.labelMd),
              ],
            ),
            Text("Shivam's Custom Model v3.4", style: AppTypography.labelSm),
          ],
        ),
        const SizedBox(height: 8),
        ..._messages.map((msg) => _buildMessageBubble(msg)),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10, left: 40),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Text(
            msg.text,
            style: const TextStyle(
              fontFamily: AppTypography.fontBody,
              color: Colors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12, right: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.tertiaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: AppColors.onTertiaryFixed, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border.all(color: AppColors.borderSubtle),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: const TextStyle(
                      fontFamily: AppTypography.fontBody,
                      fontSize: 13,
                      height: 1.5,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (msg.confidenceScore != null) ...[
                        Text(
                          'Confidence Score: ${msg.confidenceScore}%',
                          style: AppTypography.labelSm,
                        ),
                        const SizedBox(width: 8),
                        const Text('•', style: AppTypography.labelSm),
                        const SizedBox(width: 8),
                      ],
                      InkWell(
                        onTap: () => _copyToClipboard(msg.text),
                        child: const Text(
                          'Copy Summary',
                          style: TextStyle(
                            fontFamily: AppTypography.fontBody,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPrompts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Instant Intervention Prompts:', style: AppTypography.labelSm),
        const SizedBox(height: 6),
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _quickPrompts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (ctx, i) {
              final prompt = _quickPrompts[i];
              IconData icon = Icons.lightbulb_outline;
              Color iconColor = AppColors.primary;
              if (i == 1) {
                icon = Icons.calendar_today_outlined;
                iconColor = AppColors.tertiary;
              } else if (i == 2) {
                icon = Icons.quiz_outlined;
                iconColor = AppColors.primaryContainer;
              } else if (i == 3) {
                icon = Icons.analytics_outlined;
                iconColor = AppColors.error;
              }

              return InkWell(
                onTap: () => _sendMessage(prompt),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, color: iconColor, size: 14),
                      const SizedBox(width: 6),
                      Text(prompt, style: AppTypography.labelSm),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: AppColors.onSurfaceVariant, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Attach notes or assignments from Drive...')),
              );
            },
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _sendMessage,
              decoration: const InputDecoration(
                hintText: 'Ask EduPredict anything (e.g. explain LRU)...',
                hintStyle: TextStyle(
                  fontFamily: AppTypography.fontBody,
                  fontSize: 13,
                  color: AppColors.outline,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mic_none, color: AppColors.onSurfaceVariant, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Voice dictation active...')),
              );
            },
          ),
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 16),
              onPressed: () => _sendMessage(_textController.text),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyPlanSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.event_available,
                        color: AppColors.primaryContainer, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Personalized Study Plan', style: AppTypography.titleMd),
                      Text('3-Day Sprint for Virtual Memory', style: AppTypography.bodySm),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '+9% Score Delta',
                  style: TextStyle(
                    fontFamily: AppTypography.fontBody,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.tertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._studyPlan.map((plan) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: plan.isCompleted
                    ? AppColors.surfaceContainerLow
                    : AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: plan.isCompleted ? AppColors.primary.withOpacity(0.3) : AppColors.borderSubtle,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: plan.isCompleted,
                    activeColor: AppColors.primaryContainer,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: (val) {
                      setState(() {
                        final index = _studyPlan.indexWhere((p) => p.dayNumber == plan.dayNumber);
                        if (index != -1) {
                          _studyPlan[index] = plan.copyWith(isCompleted: val ?? false);
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Day ${plan.dayNumber} • ${plan.title}',
                              style: AppTypography.labelLg.copyWith(
                                decoration:
                                    plan.isCompleted ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            Text(plan.duration, style: AppTypography.labelSm),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(plan.objective, style: AppTypography.bodySm),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}


