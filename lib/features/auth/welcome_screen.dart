import 'package:flutter/material.dart';
import 'widgets/auth_widgets.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _tripNameController = TextEditingController();
  final _destinationController = TextEditingController();
  final _participantsController = TextEditingController();
  final _datesController = TextEditingController();
  final _budgetController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _searchController = TextEditingController();

  final List<String> _allTags = [
    'Monument',
    'Randonnée',
    'Nature',
    'Street Art',
    'Lieu de Tournage',
  ];
  final Set<String> _selectedTags = {};

  @override
  void dispose() {
    _tripNameController.dispose();
    _destinationController.dispose();
    _participantsController.dispose();
    _datesController.dispose();
    _budgetController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Text(
                  'Bienvenue sur Trottle',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AuthTextField(controller: _tripNameController, hint: 'Champ (titre du voyage)'),
            const SizedBox(height: 10),
            AuthTextField(controller: _destinationController, hint: 'Destination'),
            const SizedBox(height: 10),
            AuthTextField(controller: _participantsController, hint: 'Participants'),
            const SizedBox(height: 10),
            AuthTextField(controller: _datesController, hint: 'Dates'),
            const SizedBox(height: 10),
            AuthTextField(controller: _budgetController, hint: 'Budget', keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            AuthTextField(controller: _descriptionController, hint: 'Description', maxLines: 3),
            const SizedBox(height: 16),
            AuthTextField(
              controller: _searchController,
              hint: 'Recherchez plus de 50 activités...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allTags.map((tag) {
                final selected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: selected,
                  onSelected: (val) => setState(() {
                    val ? _selectedTags.add(tag) : _selectedTags.remove(tag);
                  }),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Créer',
              onPressed: () {},
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
