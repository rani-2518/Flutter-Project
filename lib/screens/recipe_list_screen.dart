import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/recipe_provider.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/recipe_card.dart';
import '../widgets/state_views.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<RecipeProvider>().fetchRecipes();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: Text(user == null ? 'Recipes' : 'Hi, ${user.firstName}'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          AppSearchBar(
            controller: _searchCtrl,
            onChanged: context.read<RecipeProvider>().setQuery,
          ),
          Expanded(
            child: Consumer<RecipeProvider>(
              builder: (context, provider, _) {
                switch (provider.status) {
                  case LoadStatus.loading:
                    return const LoadingView();

                  case LoadStatus.error:
                    return ErrorView(
                      message: provider.errorMessage,
                      onRetry: provider.fetchRecipes,
                    );

                  case LoadStatus.success:
                    final items = provider.filteredRecipes;
                    if (items.isEmpty) {
                      return EmptyView(query: provider.query);
                    }
                    return RefreshIndicator(
                      onRefresh: () =>
                          provider.fetchRecipes(showLoader: false),
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final recipe = items[index];
                          return RecipeCard(
                            recipe: recipe,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    RecipeDetailScreen(recipe: recipe),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
