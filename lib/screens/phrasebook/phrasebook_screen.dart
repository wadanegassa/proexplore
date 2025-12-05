import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../data/models/models.dart';

class PhrasebookScreen extends StatefulWidget {
  const PhrasebookScreen({super.key});

  @override
  State<PhrasebookScreen> createState() => _PhrasebookScreenState();
}

class _PhrasebookScreenState extends State<PhrasebookScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amharic Phrasebook'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryChip('All'),
                _buildCategoryChip('Basics'),
                _buildCategoryChip('Shopping'),
                _buildCategoryChip('Directions'),
                _buildCategoryChip('Emergency'),
                _buildCategoryChip('Food'),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Phrase>>(
        future: DataService().getPhrases(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No phrases available'));
          }
          
          final allPhrases = snapshot.data!;
          final phrases = _selectedCategory == 'All'
              ? allPhrases
              : allPhrases.where((p) => p.category == _selectedCategory).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: phrases.length,
            itemBuilder: (context, index) {
              final phrase = phrases[index];
              return _PhraseCard(phrase: phrase);
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedCategory = category);
        },
        backgroundColor: Colors.transparent,
        selectedColor: const Color(0xFF009639),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected ? const Color(0xFF009639) : Colors.grey[300]!,
        ),
      ),
    );
  }
}

class _PhraseCard extends StatelessWidget {
  final Phrase phrase;

  const _PhraseCard({required this.phrase});

  Color _getCategoryColor() {
    switch (phrase.category.toLowerCase()) {
      case 'basics':
        return const Color(0xFF009639);
      case 'shopping':
        return const Color(0xFFFEDB00);
      case 'directions':
        return const Color(0xFF0288D1);
      case 'emergency':
        return const Color(0xFFDA121A);
      case 'food':
        return const Color(0xFF00B248);
      default:
        return const Color(0xFF009639);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getCategoryColor().withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          phrase.original,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              phrase.translated,
              style: TextStyle(
                color: _getCategoryColor(),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              phrase.pronunciation,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getCategoryColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                phrase.category,
                style: TextStyle(
                  color: _getCategoryColor(),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.volume_up),
          color: _getCategoryColor(),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Playing: ${phrase.translated}'),
                backgroundColor: _getCategoryColor(),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}
