import 'package:flutter/material.dart';
import 'package:dermai/resources.dart';

class SkincareRoutineStep {
  final String title;
  final String description;
  final String duration;
  final IconData icon;
  const SkincareRoutineStep({
    required this.title,
    required this.description,
    required this.duration,
    required this.icon,
  });
}

class DiseaseSkintip {
  final String disease;
  final String emoji;
  final List<String> dos;
  final List<String> donts;
  const DiseaseSkintip({
    required this.disease,
    required this.emoji,
    required this.dos,
    required this.donts,
  });
}

class IngredientInfo {
  final String name;
  final String benefit;
  final String emoji;
  final bool avoid;
  const IngredientInfo({
    required this.name,
    required this.benefit,
    required this.emoji,
    required this.avoid,
  });
}

const morningSteps = [
  SkincareRoutineStep(title: 'Gentle Cleanser', description: 'Wash face with a mild, pH-balanced cleanser to remove overnight oils and impurities.', duration: '60 sec', icon: Icons.water_drop_outlined),
  SkincareRoutineStep(title: 'Toner', description: 'Apply alcohol-free toner to balance skin pH and prep for serums.', duration: '30 sec', icon: Icons.opacity_outlined),
  SkincareRoutineStep(title: 'Vitamin C Serum', description: 'Apply 2-3 drops for antioxidant protection, brightening and collagen support.', duration: '1 min', icon: Icons.brightness_high_outlined),
  SkincareRoutineStep(title: 'Moisturiser', description: 'Lock in hydration with a lightweight, non-comedogenic moisturiser.', duration: '30 sec', icon: Icons.water_outlined),
  SkincareRoutineStep(title: 'SPF Sunscreen', description: 'Apply SPF 30+ generously. This is the most important step.', duration: '1 min', icon: Icons.wb_sunny_outlined),
];

const nightSteps = [
  SkincareRoutineStep(title: 'Oil/Balm Cleanser', description: 'Double cleanse: start with an oil cleanser to dissolve sunscreen and makeup.', duration: '60 sec', icon: Icons.bubble_chart_outlined),
  SkincareRoutineStep(title: 'Foaming Cleanser', description: 'Follow with a water-based cleanser to remove remaining residue.', duration: '60 sec', icon: Icons.water_drop_outlined),
  SkincareRoutineStep(title: 'Exfoliant (2-3x/week)', description: 'Use AHA (glycolic/lactic acid) or BHA (salicylic) to remove dead skin cells.', duration: '5 min', icon: Icons.auto_awesome_outlined),
  SkincareRoutineStep(title: 'Treatment Serum', description: 'Apply niacinamide, retinol or hyaluronic acid serum based on your concern.', duration: '1 min', icon: Icons.science_outlined),
  SkincareRoutineStep(title: 'Night Cream / Slugging', description: 'Use a richer moisturiser or a thin layer of petroleum jelly to seal in moisture overnight.', duration: '30 sec', icon: Icons.nightlight_outlined),
];

const diseaseTips = [
  DiseaseSkintip(disease: 'Acne & Rosacea', emoji: '🔴', dos: ['Use salicylic acid or benzoyl peroxide spot treatments', 'Cleanse twice daily with gentle cleanser', 'Apply non-comedogenic moisturiser', 'Change pillowcases every 2-3 days'], donts: ['Do not pop or pick pimples', 'Avoid heavy, oily makeup', 'Do not over-exfoliate (max 2x per week)', 'Avoid spicy food and alcohol for rosacea']),
  DiseaseSkintip(disease: 'Eczema', emoji: '🌿', dos: ['Moisturise within 3 minutes of bathing', 'Use fragrance-free, hypoallergenic products', 'Wear loose, breathable cotton clothing', 'Keep nails short to prevent scratching damage'], donts: ['Avoid hot showers (use lukewarm water)', 'Do not use harsh soaps or detergents', 'Avoid known allergens and stress triggers', 'Do not scratch — apply cold compress instead']),
  DiseaseSkintip(disease: 'Melanoma / Moles', emoji: '⚠️', dos: ['Apply SPF 50+ sunscreen daily', 'Wear UV-protective clothing outdoors', 'Do monthly self-checks using the ABCDE rule', 'Visit a dermatologist annually for skin mapping'], donts: ['Never skip sunscreen even on cloudy days', 'Do not ignore new or changing moles', 'Avoid tanning beds entirely', 'Do not self-treat — always see a doctor']),
  DiseaseSkintip(disease: 'Nail Fungus', emoji: '💅', dos: ['Keep nails clean, trimmed and dry', 'Wear breathable socks and well-ventilated shoes', 'Use antifungal powder in shoes', 'Disinfect nail tools after each use'], donts: ['Do not walk barefoot in public pools/gyms', 'Avoid wearing tight, closed shoes all day', 'Do not share nail clippers or files', 'Avoid artificial nails while infected']),
  DiseaseSkintip(disease: 'Psoriasis', emoji: '🧴', dos: ['Moisturise generously and frequently', 'Take short, lukewarm showers', 'Get moderate sun exposure (5-10 min)', 'Use coal tar or salicylic acid shampoo for scalp'], donts: ['Do not smoke or drink alcohol excessively', 'Avoid skin injury (cuts, sunburn)', 'Do not use fragranced products on affected areas', 'Do not stress — it is a known trigger']),
];

const ingredients = [
  IngredientInfo(name: 'Niacinamide', benefit: 'Reduces pores, controls oil, fades dark spots and evens skin tone', emoji: '✨', avoid: false),
  IngredientInfo(name: 'Hyaluronic Acid', benefit: 'Draws moisture into skin, plumps and hydrates all skin types', emoji: '💧', avoid: false),
  IngredientInfo(name: 'Retinol', benefit: 'Boosts collagen, speeds cell turnover, fights wrinkles and acne', emoji: '⚡', avoid: false),
  IngredientInfo(name: 'Vitamin C', benefit: 'Brightens complexion, antioxidant protection, boosts SPF effectiveness', emoji: '🍊', avoid: false),
  IngredientInfo(name: 'Salicylic Acid', benefit: 'Unclogs pores, reduces acne and blackheads, anti-inflammatory', emoji: '🔬', avoid: false),
  IngredientInfo(name: 'Ceramides', benefit: 'Repairs and strengthens skin barrier, prevents moisture loss', emoji: '🛡️', avoid: false),
  IngredientInfo(name: 'Fragrance / Parfum', benefit: 'Common irritant — causes redness, allergy and sensitisation', emoji: '🚫', avoid: true),
  IngredientInfo(name: 'Alcohol Denat.', benefit: 'Strips natural oils, damages skin barrier over time', emoji: '🚫', avoid: true),
  IngredientInfo(name: 'Parabens', benefit: 'Potential hormone disruptors — linked to skin sensitisation', emoji: '🚫', avoid: true),
  IngredientInfo(name: 'Sulfates (SLS)', benefit: 'Over-strips oils causing dryness, irritation and inflammation', emoji: '🚫', avoid: true),
];

// ─── MAIN SCREEN ───────────────────────────────────────────────────────────

class SkincareScreen extends StatefulWidget {
  final String? initialDisease;
  const SkincareScreen({Key? key, this.initialDisease}) : super(key: key);

  @override
  State<SkincareScreen> createState() => _SkincareScreenState();
}

class _SkincareScreenState extends State<SkincareScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  int _selectedDisease = 0;
  bool _showAvoid = false;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _tab.addListener(() => setState(() {}));

    // Deep-link: if a disease was passed in, jump to Disease Tips tab
    if (widget.initialDisease != null) {
      final idx = diseaseTips.indexWhere((d) => d.disease == widget.initialDisease);
      if (idx != -1) {
        _selectedDisease = idx;
        // Jump after first frame so TabController is ready
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _tab.animateTo(1);
        });
      }
    }
  }

  @override
  void didUpdateWidget(SkincareScreen old) {
    super.didUpdateWidget(old);
    if (widget.initialDisease != null && widget.initialDisease != old.initialDisease) {
      final idx = diseaseTips.indexWhere((d) => d.disease == widget.initialDisease);
      if (idx != -1) {
        setState(() => _selectedDisease = idx);
        _tab.animateTo(1);
      }
    }
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _RoutinesTab(),
                  _DiseaseTipsTab(
                    selected: _selectedDisease,
                    onSelect: (i) => setState(() => _selectedDisease = i),
                  ),
                  _IngredientsTab(
                    showAvoid: _showAvoid,
                    onToggle: (v) => setState(() => _showAvoid = v),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.spa_outlined, color: c, size: 22),
        ),
        const SizedBox(width: 12),
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Skincare Guide', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
          Text('Routines, tips & ingredients', style: TextStyle(fontSize: 12, color: Colors.black45)),
        ]),
      ]),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(22, 16, 22, 0),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      child: TabBar(
        controller: _tab,
        indicator: BoxDecoration(color: c, borderRadius: BorderRadius.circular(10)),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black54,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        dividerColor: Colors.transparent,
        tabs: const [Tab(text: 'Routines'), Tab(text: 'Disease Tips'), Tab(text: 'Ingredients')],
      ),
    );
  }
}

// ─── TAB 1: ROUTINES ──────────────────────────────────────────────────────

class _RoutinesTab extends StatefulWidget {
  @override
  State<_RoutinesTab> createState() => _RoutinesTabState();
}

class _RoutinesTabState extends State<_RoutinesTab> {
  bool _isMorning = true;

  @override
  Widget build(BuildContext context) {
    final steps = _isMorning ? morningSteps : nightSteps;
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(4),
          child: Row(children: [
            _toggleBtn('Morning', _isMorning, () => setState(() => _isMorning = true)),
            _toggleBtn('Night', !_isMorning, () => setState(() => _isMorning = false)),
          ]),
        ),
        const SizedBox(height: 8),
        Text(_isMorning ? '5 steps · ~4 minutes' : '5 steps · ~9 minutes',
            style: const TextStyle(fontSize: 12, color: Colors.black38)),
        const SizedBox(height: 20),
        ...steps.asMap().entries.map((e) =>
            _StepCard(step: e.value, index: e.key + 1, isLast: e.key == steps.length - 1)),
      ],
    );
  }

  Widget _toggleBtn(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? c : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(label, textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                  color: active ? Colors.white : Colors.black54)),
        ),
      ),
    );
  }
}

class _StepCard extends StatefulWidget {
  final SkincareRoutineStep step;
  final int index;
  final bool isLast;
  const _StepCard({required this.step, required this.index, required this.isLast});
  @override
  State<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<_StepCard> {
  bool _done = false;
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(children: [
        GestureDetector(
          onTap: () => setState(() => _done = !_done),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: _done ? c : Colors.white, shape: BoxShape.circle,
              border: Border.all(color: _done ? c : Colors.grey.shade300, width: 2),
            ),
            child: Center(child: _done
                ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                : Text('${widget.index}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade500))),
          ),
        ),
        if (!widget.isLast) Container(width: 2, height: 60, color: Colors.grey.shade200),
      ]),
      const SizedBox(width: 14),
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _done ? const Color(0xFFF0FFF6) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _done ? c.withOpacity(0.3) : Colors.grey.shade200),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(widget.step.icon, size: 18, color: _done ? c : Colors.black54),
              const SizedBox(width: 8),
              Expanded(child: Text(widget.step.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                  color: _done ? c : Colors.black87, decoration: _done ? TextDecoration.lineThrough : null))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: Text(widget.step.duration, style: const TextStyle(fontSize: 10, color: c, fontWeight: FontWeight.w600)),
              ),
            ]),
            const SizedBox(height: 6),
            Text(widget.step.description, style: const TextStyle(fontSize: 12, color: Colors.black45, height: 1.5)),
          ]),
        ),
      ),
    ]);
  }
}

// ─── TAB 2: DISEASE TIPS ──────────────────────────────────────────────────

class _DiseaseTipsTab extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _DiseaseTipsTab({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final tip = diseaseTips[selected];
    return ListView(padding: const EdgeInsets.fromLTRB(22, 20, 22, 24), children: [
      SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: diseaseTips.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final active = i == selected;
            return GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: active ? c : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${diseaseTips[i].emoji}  ${diseaseTips[i].disease}',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                        color: active ? Colors.white : Colors.black54)),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 24),
      _TipCard(title: "Do's", icon: Icons.check_circle_outline_rounded, color: c, bgColor: const Color(0xFFF0FFF6), items: tip.dos),
      const SizedBox(height: 16),
      _TipCard(title: "Don'ts", icon: Icons.cancel_outlined, color: Colors.redAccent, bgColor: const Color(0xFFFFF5F5), items: tip.donts),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.amber.shade200)),
        child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Icons.medical_services_outlined, size: 18, color: Colors.orange),
          SizedBox(width: 10),
          Expanded(child: Text('These tips help manage symptoms but are not a replacement for professional medical advice. Always consult a dermatologist.',
              style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.5))),
        ]),
      ),
    ]);
  }
}

class _TipCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final List<String> items;
  const _TipCard({required this.title, required this.icon, required this.color, required this.bgColor, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(icon, size: 18, color: color), const SizedBox(width: 8),
          Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color))]),
        const SizedBox(height: 12),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(margin: const EdgeInsets.only(top: 5), width: 6, height: 6,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 10),
            Expanded(child: Text(item, style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.5))),
          ]),
        )),
      ]),
    );
  }
}

// ─── TAB 3: INGREDIENTS ───────────────────────────────────────────────────

class _IngredientsTab extends StatelessWidget {
  final bool showAvoid;
  final ValueChanged<bool> onToggle;
  const _IngredientsTab({required this.showAvoid, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final list = ingredients.where((i) => i.avoid == showAvoid).toList();
    return ListView(padding: const EdgeInsets.fromLTRB(22, 20, 22, 24), children: [
      Container(
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(4),
        child: Row(children: [
          _toggleBtn('Use These', !showAvoid, () => onToggle(false), c),
          _toggleBtn('Avoid These', showAvoid, () => onToggle(true), Colors.redAccent),
        ]),
      ),
      const SizedBox(height: 20),
      ...list.map((ing) => _IngredientCard(ing: ing)),
    ]);
  }

  Widget _toggleBtn(String label, bool active, VoidCallback onTap, Color activeColor) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(label, textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                  color: active ? Colors.white : Colors.black54)),
        ),
      ),
    );
  }
}

class _IngredientCard extends StatelessWidget {
  final IngredientInfo ing;
  const _IngredientCard({required this.ing});

  @override
  Widget build(BuildContext context) {
    final color = ing.avoid ? Colors.redAccent : c;
    final bg = ing.avoid ? const Color(0xFFFFF5F5) : const Color(0xFFF0FFF6);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.2))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 44, height: 44,
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(ing.emoji, style: const TextStyle(fontSize: 20)))),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(ing.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(ing.benefit, style: const TextStyle(fontSize: 12, color: Colors.black45, height: 1.5)),
        ])),
      ]),
    );
  }
}
