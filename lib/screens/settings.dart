import 'package:flutter/material.dart';
import 'package:new_project_app/utils/colors.dart'; 

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _currency = '\$';
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Food', 'icon': Icons.restaurant, 'color': AppColors.success},
    {'name': 'Transport', 'icon': Icons.directions_car, 'color': AppColors.accent},
    {'name': 'Entertainment', 'icon': Icons.movie, 'color': AppColors.warning},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionTitle('Preferences'),
          _CurrencyTile(
            value: _currency,
            onChanged: (v) => setState(() => _currency = v),
          ),
          const SizedBox(height: 24),
          _SectionTitle('Categories'),
          ..._categories.map((c) => _CategoryTile(
            name: c['name'],
            icon: c['icon'],
            color: c['color'],
            onEdit: () => _editCategory(c),
          )),
          _AddCategoryButton(onTap: _addCategory),
          const SizedBox(height: 32),
          _SectionTitle('Data'),
          _ClearDataTile(onTap: _confirmClear),
        ],
      ),
    );
  }

  void _editCategory(Map<String, dynamic> category) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _CategoryEditor(
        category: category,
        onSave: (name, icon, color) => Navigator.pop(context),
      ),
    );
  }

  void _addCategory() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _CategoryEditor(
        onSave: (name, icon, color) => Navigator.pop(context),
      ),
    );
  }

  void _confirmClear() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('This will delete all transactions and categories. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: AppColors.error)),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _CurrencyTile({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: ListTile(
        leading: const Icon(Icons.attach_money, color: AppColors.primary),
        title: const Text('Currency Symbol'),
        trailing: DropdownButton<String>(
          value: value,
          underline: const SizedBox(),
          items: const [
            DropdownMenuItem(value: '\$', child: Text('USD (\$)')),
            DropdownMenuItem(value: '€', child: Text('EUR (€)')),
            DropdownMenuItem(value: '£', child: Text('GBP (£)')),
            DropdownMenuItem(value: '¥', child: Text('JPY (¥)')),
          ],
          onChanged: (v) => v != null ? onChanged(v) : null,
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final VoidCallback onEdit;

  const _CategoryTile({
    required this.name,
    required this.icon,
    required this.color,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(name),
        trailing: IconButton(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _AddCategoryButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddCategoryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Add Category', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _ClearDataTile extends StatelessWidget {
  final VoidCallback onTap;

  const _ClearDataTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: ListTile(
        leading: const Icon(Icons.delete_forever, color: AppColors.error),
        title: const Text('Clear All Data', style: TextStyle(color: AppColors.error)),
        onTap: onTap,
      ),
    );
  }
}

class _CategoryEditor extends StatefulWidget {
  final Map<String, dynamic>? category;
  final Function(String, IconData, Color) onSave;

  const _CategoryEditor({this.category, required this.onSave});

  @override
  State<_CategoryEditor> createState() => _CategoryEditorState();
}

class _CategoryEditorState extends State<_CategoryEditor> {
  late final _nameController = TextEditingController(text: widget.category?['name'] ?? '');
  late IconData _selectedIcon = widget.category?['icon'] ?? Icons.category;
  late Color _selectedColor = widget.category?['color'] ?? AppColors.categoryColors.first;

  final List<IconData> _icons = [
    Icons.restaurant, Icons.directions_car, Icons.movie, Icons.shopping_bag,
    Icons.work, Icons.favorite, Icons.home, Icons.sports, Icons.pets, Icons.local_cafe,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.category == null ? 'Add Category' : 'Edit Category',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Category Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Icon', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _icons.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final icon = _icons[index];
                final isSelected = icon == _selectedIcon;
                return InkWell(
                  onTap: () => setState(() => _selectedIcon = icon),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.divider),
                    ),
                    child: Icon(icon, color: isSelected ? Colors.white : AppColors.textSecondary),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text('Color', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppColors.categoryColors.map((c) {
              final isSelected = c == _selectedColor;
              return InkWell(
                onTap: () => setState(() => _selectedColor = c),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                    boxShadow: isSelected ? [BoxShadow(color: c.withOpacity(0.4), blurRadius: 8)] : null,
                  ),
                  child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => widget.onSave(_nameController.text, _selectedIcon, _selectedColor),
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Save'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}