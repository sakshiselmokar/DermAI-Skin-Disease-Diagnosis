import 'package:flutter/material.dart';
import 'package:dermai/resources.dart';

class Remedy {
  final String name;
  final String disease;
  final String emoji;
  final String prepTime;
  final List<String> ingredients;
  final List<String> steps;
  final String tip;
  const Remedy({required this.name, required this.disease, required this.emoji,
      required this.prepTime, required this.ingredients, required this.steps, required this.tip});
}

class NaturalIngredient {
  final String name;
  final String emoji;
  final String benefit;
  final String bestFor;
  final String howToUse;
  const NaturalIngredient({required this.name, required this.emoji,
      required this.benefit, required this.bestFor, required this.howToUse});
}

const diseases = ['All', 'Acne & Rosacea', 'Eczema', 'Melanoma / Moles', 'Nail Fungus', 'Psoriasis'];

const remedies = [
  Remedy(name: 'Turmeric & Honey Mask', disease: 'Acne & Rosacea', emoji: '🟡', prepTime: '5 min',
      ingredients: ['1 tsp turmeric powder', '2 tsp raw honey', '1 tsp plain yoghurt'],
      steps: ['Mix turmeric, honey and yoghurt in a small bowl until smooth.', 'Wash your face and pat dry.', 'Apply a thin, even layer to the affected area.', 'Leave on for 10-15 minutes.', 'Rinse thoroughly with lukewarm water.', 'Use 2-3 times per week.'],
      tip: 'Turmeric can stain — use an old towel and rinse well. Do a patch test first.'),
  Remedy(name: 'Green Tea Ice Cube Compress', disease: 'Acne & Rosacea', emoji: '🟢', prepTime: '10 min + freeze',
      ingredients: ['2 green tea bags', '250ml hot water', 'Ice cube tray'],
      steps: ['Brew 2 green tea bags in 250ml hot water for 5 minutes.', 'Let it cool completely.', 'Pour into an ice cube tray and freeze overnight.', 'Wrap a cube in a thin cloth.', 'Gently press on red or inflamed areas for 1-2 minutes.', 'Use daily on flare-ups.'],
      tip: 'Green tea contains EGCG, a powerful anti-inflammatory. Never apply ice directly to skin.'),
  Remedy(name: 'Oat & Coconut Oil Soak', disease: 'Eczema', emoji: '🥣', prepTime: '15 min',
      ingredients: ['1 cup colloidal oatmeal', '2 tbsp coconut oil', 'Warm bath water'],
      steps: ['Fill bath with lukewarm (not hot) water.', 'Add colloidal oatmeal and stir to dissolve.', 'Add melted coconut oil and mix.', 'Soak for 15-20 minutes.', 'Pat skin dry gently — do not rub.', 'Apply moisturiser immediately after.'],
      tip: 'Colloidal oatmeal is finely ground and dissolves into the water, coating the skin to relieve itching.'),
  Remedy(name: 'Aloe Vera & Chamomile Gel', disease: 'Eczema', emoji: '🌿', prepTime: '5 min',
      ingredients: ['3 tbsp pure aloe vera gel', '2 tbsp cooled chamomile tea', '2 drops lavender essential oil (optional)'],
      steps: ['Brew strong chamomile tea and cool completely.', 'Mix aloe vera gel with chamomile tea.', 'Add lavender oil if using and mix well.', 'Apply gently to affected skin areas.', 'Allow to absorb — do not rinse.', 'Store remainder in fridge for up to 3 days.'],
      tip: 'Use pure aloe vera gel without added alcohol or fragrance for best results.'),
  Remedy(name: 'Apple Cider Vinegar Soak', disease: 'Nail Fungus', emoji: '🍎', prepTime: '30 min',
      ingredients: ['1 part apple cider vinegar', '1 part warm water', 'Clean towel'],
      steps: ['Mix equal parts ACV and warm water in a bowl.', 'Soak affected nails for 15-20 minutes.', 'Dry nails completely with a clean towel.', 'Trim and file nails after soaking while soft.', 'Repeat daily for 4-6 weeks.', 'Wear clean socks immediately after.'],
      tip: 'ACV creates an acidic environment that slows fungal growth. Consistency is key — do this every day.'),
  Remedy(name: 'Tea Tree Oil Treatment', disease: 'Nail Fungus', emoji: '🌲', prepTime: '5 min',
      ingredients: ['2 drops tea tree essential oil', '1 tsp coconut or olive oil', 'Cotton ball'],
      steps: ['Dilute tea tree oil with carrier oil — never use undiluted.', 'Clean the affected nail and surrounding skin.', 'Apply the mixture with a cotton ball.', 'Gently scrub the nail surface with a soft brush.', 'Leave on and allow to absorb.', 'Repeat twice daily for several weeks.'],
      tip: 'Tea tree oil has natural antifungal properties. Always dilute — undiluted application can irritate skin.'),
  Remedy(name: 'Dead Sea Salt Soak', disease: 'Psoriasis', emoji: '🧂', prepTime: '20 min',
      ingredients: ['2 cups Dead Sea salt', 'Lukewarm bath water', '2 tbsp olive oil'],
      steps: ['Fill the bath with comfortably warm water.', 'Add Dead Sea salts and stir to dissolve.', 'Add olive oil for extra moisture.', 'Soak for 15-20 minutes.', 'Rinse lightly and pat dry.', 'Apply thick moisturiser immediately.'],
      tip: 'Dead Sea salt contains magnesium, which has anti-inflammatory effects on psoriasis plaques.'),
  Remedy(name: 'Aloe & Turmeric Scalp Mask', disease: 'Psoriasis', emoji: '🌱', prepTime: '10 min',
      ingredients: ['4 tbsp aloe vera gel', '1 tsp turmeric', '1 tbsp coconut oil'],
      steps: ['Mix all ingredients into a smooth paste.', 'Part hair and apply directly to scalp plaques.', 'Gently massage in circular motions for 2 minutes.', 'Leave on for 20-30 minutes.', 'Rinse thoroughly with mild shampoo.', 'Use twice weekly.'],
      tip: 'Wear an old shirt — turmeric stains fabric and surfaces. The combination soothes and reduces flaking.'),
  Remedy(name: 'SPF Lip & Skin Protection', disease: 'Melanoma / Moles', emoji: '☀️', prepTime: '2 min',
      ingredients: ['SPF 50+ sunscreen', 'Zinc oxide cream (optional)', 'Wide-brimmed hat'],
      steps: ['Apply broad-spectrum SPF 50+ 20 minutes before going outside.', 'Use a generous amount — 1/4 tsp for face alone.', 'Apply zinc oxide to moles or suspicious spots for extra UV blocking.', 'Reapply every 2 hours or after sweating/swimming.', 'Cover up with UV-protective clothing.', 'Check moles monthly using ABCDE method.'],
      tip: 'This is prevention, not treatment. Any new, growing or changing mole must be seen by a doctor immediately.'),
];

const naturalIngredients = [
  NaturalIngredient(name: 'Aloe Vera', emoji: '🌿', benefit: 'Anti-inflammatory, cooling, moisturising. Contains vitamins C, E and enzymes.', bestFor: 'Eczema, sunburn, rosacea, general irritation', howToUse: 'Apply fresh gel directly from the leaf or use pure bottled gel. Leave on skin.'),
  NaturalIngredient(name: 'Turmeric', emoji: '🟡', benefit: 'Curcumin is a powerful antioxidant and anti-inflammatory that fights bacteria.', bestFor: 'Acne, psoriasis, hyperpigmentation', howToUse: 'Mix with honey or yoghurt as a mask. Leave 10-15 min then rinse.'),
  NaturalIngredient(name: 'Raw Honey', emoji: '🍯', benefit: 'Natural humectant, antibacterial, antifungal. Draws moisture into skin.', bestFor: 'Acne, dry skin, wound healing, eczema', howToUse: 'Apply directly as a spot treatment or mix with other ingredients for a mask.'),
  NaturalIngredient(name: 'Coconut Oil', emoji: '🥥', benefit: 'Deeply moisturising, antifungal (lauric acid), repairs skin barrier.', bestFor: 'Eczema, nail fungus, dry skin, psoriasis', howToUse: 'Apply melted virgin coconut oil to skin or nails. Best after bathing.'),
  NaturalIngredient(name: 'Tea Tree Oil', emoji: '🌲', benefit: 'Potent natural antifungal and antibacterial agent.', bestFor: 'Nail fungus, acne, infected skin', howToUse: 'Always dilute 1-2 drops in 1 tsp carrier oil. Never use undiluted.'),
  NaturalIngredient(name: 'Apple Cider Vinegar', emoji: '🍎', benefit: 'Acidic pH balancer, antifungal and antibacterial properties.', bestFor: 'Nail fungus, acne, oily skin', howToUse: 'Always dilute 1:1 with water. Use as a toner or soak. Avoid on open wounds.'),
  NaturalIngredient(name: 'Oatmeal', emoji: '🥣', benefit: 'Rich in beta-glucan, deeply soothing and anti-itch. Reinforces skin barrier.', bestFor: 'Eczema, dry skin, rashes, psoriasis', howToUse: 'Use colloidal oatmeal in baths or mix with water as a face mask.'),
  NaturalIngredient(name: 'Chamomile', emoji: '🌼', benefit: 'Contains apigenin — anti-inflammatory, calming for sensitive and reactive skin.', bestFor: 'Rosacea, eczema, sensitive skin', howToUse: 'Brew strong tea, cool and apply as toner or compress. Mix with aloe vera gel.'),
];

// ─── MAIN SCREEN ───────────────────────────────────────────────────────────

class HomeRemediesScreen extends StatefulWidget {
  final String? initialDisease;
  const HomeRemediesScreen({Key? key, this.initialDisease}) : super(key: key);

  @override
  State<HomeRemediesScreen> createState() => _HomeRemediesScreenState();
}

class _HomeRemediesScreenState extends State<HomeRemediesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  String _selectedDisease = 'All';

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _tab.addListener(() => setState(() {}));

    // Deep-link: pre-select disease filter if passed in
    if (widget.initialDisease != null && diseases.contains(widget.initialDisease)) {
      _selectedDisease = widget.initialDisease!;
    }
  }

  @override
  void didUpdateWidget(HomeRemediesScreen old) {
    super.didUpdateWidget(old);
    if (widget.initialDisease != null && widget.initialDisease != old.initialDisease) {
      if (diseases.contains(widget.initialDisease)) {
        setState(() => _selectedDisease = widget.initialDisease!);
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
                  _RemediesTab(
                    selectedDisease: _selectedDisease,
                    onDiseaseSelect: (d) => setState(() => _selectedDisease = d),
                  ),
                  const _IngredientsTab(),
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
          child: const Icon(Icons.eco_outlined, color: c, size: 22),
        ),
        const SizedBox(width: 12),
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Home Remedies', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
          Text('Natural treatments using kitchen ingredients', style: TextStyle(fontSize: 12, color: Colors.black45)),
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
        tabs: const [Tab(text: 'Remedies by Disease'), Tab(text: 'Ingredient Benefits')],
      ),
    );
  }
}

// ─── TAB 1: REMEDIES ──────────────────────────────────────────────────────

class _RemediesTab extends StatelessWidget {
  final String selectedDisease;
  final ValueChanged<String> onDiseaseSelect;
  const _RemediesTab({required this.selectedDisease, required this.onDiseaseSelect});

  @override
  Widget build(BuildContext context) {
    final filtered = selectedDisease == 'All'
        ? remedies
        : remedies.where((r) => r.disease == selectedDisease).toList();

    return Column(children: [
      Container(
        height: 44,
        margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          itemCount: diseases.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final active = diseases[i] == selectedDisease;
            return GestureDetector(
              onTap: () => onDiseaseSelect(diseases[i]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: active ? c : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(diseases[i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                    color: active ? Colors.white : Colors.black54)),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 4),
      Expanded(
        child: filtered.isEmpty
            ? const Center(child: Text('No remedies for this condition yet.', style: TextStyle(color: Colors.black38)))
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
                itemCount: filtered.length,
                itemBuilder: (_, i) => _RemedyCard(remedy: filtered[i]),
              ),
      ),
    ]);
  }
}

class _RemedyCard extends StatefulWidget {
  final Remedy remedy;
  const _RemedyCard({required this.remedy});
  @override
  State<_RemedyCard> createState() => _RemedyCardState();
}

class _RemedyCardState extends State<_RemedyCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Container(width: 44, height: 44,
                  decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text(widget.remedy.emoji, style: const TextStyle(fontSize: 22)))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.remedy.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 3),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                    child: Text(widget.remedy.disease, style: const TextStyle(fontSize: 10, color: c, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.timer_outlined, size: 12, color: Colors.grey.shade400),
                  const SizedBox(width: 3),
                  Text(widget.remedy.prepTime, style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
                ]),
              ])),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade400),
              ),
            ]),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: _buildExpandedContent(),
          crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ]),
    );
  }

  Widget _buildExpandedContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Divider(),
        const SizedBox(height: 8),
        const Text('Ingredients', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        ...widget.remedy.ingredients.map((ing) => Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(children: [
            const Text('•', style: TextStyle(color: c, fontSize: 16)),
            const SizedBox(width: 8),
            Text(ing, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          ]),
        )),
        const SizedBox(height: 14),
        const Text('Steps', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        ...widget.remedy.steps.asMap().entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 22, height: 22,
                decoration: const BoxDecoration(color: c, shape: BoxShape.circle),
                child: Center(child: Text('${e.key + 1}',
                    style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)))),
            const SizedBox(width: 10),
            Expanded(child: Text(e.value, style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.5))),
          ]),
        )),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.amber.shade200)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('💡', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 8),
            Expanded(child: Text(widget.remedy.tip, style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.5))),
          ]),
        ),
      ]),
    );
  }
}

// ─── TAB 2: INGREDIENT BENEFITS ───────────────────────────────────────────

class _IngredientsTab extends StatelessWidget {
  const _IngredientsTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
      itemCount: naturalIngredients.length,
      itemBuilder: (_, i) => _NaturalIngredientCard(ing: naturalIngredients[i]),
    );
  }
}

class _NaturalIngredientCard extends StatefulWidget {
  final NaturalIngredient ing;
  const _NaturalIngredientCard({required this.ing});
  @override
  State<_NaturalIngredientCard> createState() => _NaturalIngredientCardState();
}

class _NaturalIngredientCardState extends State<_NaturalIngredientCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(width: 48, height: 48,
                  decoration: BoxDecoration(color: const Color(0xFFF0FFF6), borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text(widget.ing.emoji, style: const TextStyle(fontSize: 24)))),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.ing.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 3),
                Text(widget.ing.bestFor,
                    style: const TextStyle(fontSize: 11, color: c, fontWeight: FontWeight.w500),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ])),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade400),
              ),
            ]),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: _buildDetails(),
          crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ]),
    );
  }

  Widget _buildDetails() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Divider(),
        const SizedBox(height: 8),
        _detailRow(Icons.star_outline_rounded, 'Benefits', widget.ing.benefit),
        const SizedBox(height: 10),
        _detailRow(Icons.favorite_border_rounded, 'Best For', widget.ing.bestFor),
        const SizedBox(height: 10),
        _detailRow(Icons.tips_and_updates_outlined, 'How to Use', widget.ing.howToUse),
      ]),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 16, color: c),
      const SizedBox(width: 8),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, color: Colors.black45, height: 1.5)),
      ])),
    ]);
  }
}
