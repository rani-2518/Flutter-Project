import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../widgets/network_image_box.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                recipe.name,
                style: const TextStyle(
                  fontSize: 16,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black87)],
                ),
              ),
              background: Hero(
                tag: 'recipe-image-${recipe.id}',
                child: NetworkImageBox(url: recipe.image),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.rating.toStringAsFixed(1)}  (${recipe.reviewCount} reviews)',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _InfoTile(
                          icon: Icons.public,
                          label: 'Cuisine',
                          value: recipe.cuisine),
                      _InfoTile(
                          icon: Icons.speed,
                          label: 'Difficulty',
                          value: recipe.difficulty),
                      _InfoTile(
                          icon: Icons.timer_outlined,
                          label: 'Prep',
                          value: '${recipe.prepTimeMinutes} min'),
                      _InfoTile(
                          icon: Icons.local_fire_department_outlined,
                          label: 'Cook',
                          value: '${recipe.cookTimeMinutes} min'),
                      _InfoTile(
                          icon: Icons.people_outline,
                          label: 'Servings',
                          value: '${recipe.servings}'),
                      _InfoTile(
                          icon: Icons.bolt,
                          label: 'Calories',
                          value: '${recipe.caloriesPerServing} kcal'),
                    ],
                  ),
                  if (recipe.mealType.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const _SectionTitle('Meal Type'),
                    _ChipWrap(items: recipe.mealType),
                  ],
                  if (recipe.tags.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const _SectionTitle('Tags'),
                    _ChipWrap(items: recipe.tags),
                  ],
                  const SizedBox(height: 20),
                  const _SectionTitle('Ingredients'),
                  ...recipe.ingredients.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(Icons.check_circle_outline, size: 18),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(e)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _SectionTitle('Instructions'),
                  ...recipe.instructions.asMap().entries.map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: theme.colorScheme.primary,
                                child: Text(
                                  '${e.key + 1}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(child: Text(e.value)),
                            ],
                          ),
                        ),
                      ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withAlpha(90),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _ChipWrap extends StatelessWidget {
  final List<String> items;
  const _ChipWrap({required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: items.map((e) => Chip(label: Text(e))).toList(),
    );
  }
}
