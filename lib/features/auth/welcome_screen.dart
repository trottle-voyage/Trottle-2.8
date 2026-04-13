import 'dart:ui';
import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0095FF).withOpacity(0.15),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 0.2,
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header fixe
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 24, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Bienvenue sur Trottle',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Contenu scrollable
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _label('Titre du voyage'),
                          const SizedBox(height: 5),
                          _field(controller: _tripNameController, hint: 'Titre du voyage'),
                          const SizedBox(height: 14),

                          _label('Destination'),
                          const SizedBox(height: 5),
                          _field(controller: _destinationController, hint: 'Destination'),
                          const SizedBox(height: 14),

                          _label('Participants'),
                          const SizedBox(height: 5),
                          _field(controller: _participantsController, hint: 'Participants'),
                          const SizedBox(height: 14),

                          _label('Dates'),
                          const SizedBox(height: 5),
                          _field(controller: _datesController, hint: 'Dates'),
                          const SizedBox(height: 14),

                          _label('Budget'),
                          const SizedBox(height: 5),
                          _field(
                            controller: _budgetController,
                            hint: 'Budget',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 14),

                          _label('Description'),
                          const SizedBox(height: 5),
                          _field(
                            controller: _descriptionController,
                            hint: 'Description',
                            maxLines: 3,
                          ),
                          const SizedBox(height: 20),

                          // Recherche activités
                          TextField(
                            controller: _searchController,
                            style: const TextStyle(color: Color(0xFF222222), fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Recherchez plus de 50 activités...',
                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                              prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.88),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 13),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Tags
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _allTags.map((tag) {
                              final selected = _selectedTags.contains(tag);
                              return GestureDetector(
                                onTap: () => setState(() {
                                  selected
                                      ? _selectedTags.remove(tag)
                                      : _selectedTags.add(tag);
                                }),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? const Color(0xFF0099FF)
                                        : Colors.white.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: selected
                                          ? const Color(0xFF0099FF)
                                          : Colors.white38,
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Text(
                                    tag,
                                    style: TextStyle(
                                      color: selected ? Colors.white : Colors.white70,
                                      fontSize: 13,
                                      fontWeight: selected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 28),

                          // Bouton Créer
                          SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0099FF),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Créer',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      );

  Widget _field({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Color(0xFF222222), fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: Colors.white.withOpacity(0.88),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        isDense: true,
      ),
    );
  }
}
