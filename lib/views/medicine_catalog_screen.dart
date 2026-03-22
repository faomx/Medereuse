import 'package:flutter/material.dart';
import '../models/donation_model.dart';
import '../models/drug_model.dart';
import '../models/donationwithdrug.dart';
import '../services/donation_service.dart';
import '../services/drug_service.dart';
import 'donation_detail_page.dart';

class MedicineCatalog extends StatefulWidget {
  const MedicineCatalog({Key? key}) : super(key: key);

  @override
  State<MedicineCatalog> createState() => _MedicineCatalogState();
}

class _MedicineCatalogState extends State<MedicineCatalog> {
  final DonationService _donationService = DonationService();
  final DrugService _drugService = DrugService();

  Map<String, List<DonationModel>> _donationsByDrugId = {};
  List<DrugModel> _allDrugs = [];

  bool _isLoading = true;
  String _selectedCategory = 'All';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  Future<void> _loadCatalog() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final allDrugs = await _drugService.getAllDrugs();
      final allDonations = await _donationService.getAllDonations();

      final Map<String, List<DonationModel>> map = {};
      for (var donation in allDonations) {
        if (donation.status.toLowerCase() != 'approved') continue;
        final drugId = donation.drugId.id;
        map.putIfAbsent(drugId, () => []).add(donation);
      }

      setState(() {
        _allDrugs = allDrugs;
        _donationsByDrugId = map;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load medicine catalog.';
      });
      print('🚨 Error loading catalog: $e');
    }
  }

  List<DrugModel> get _filteredDrugs {
    if (_selectedCategory == 'All') return _allDrugs;

    return _allDrugs
        .where((drug) =>
    drug.therapeuticCategory.toLowerCase() ==
        _selectedCategory.toLowerCase())
        .toList();
  }

  List<String> get _categories {
    final uniqueCategories = _allDrugs
        .map((e) => e.therapeuticCategory)
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return ['All'] + uniqueCategories;
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        dropdownColor: Colors.white,
        value: _selectedCategory,
        style: const TextStyle(color: Colors.black),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        items: _categories
            .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedCategory = value);
          }
        },
      ),
    );
  }

  Widget _buildMedicineCard(DrugModel drug) {
    final donations = _donationsByDrugId[drug.drugId] ?? [];
    final donationCount = donations.length;

    return GestureDetector(
      onTap: donationCount > 0
          ? () => _navigateToDetailPage(drug, donations)
          : null,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildMedicineImage(drug.imageUrl)),
            Padding(
              padding: const EdgeInsets.all(10),
              child: _buildMedicineInfo(drug, donationCount),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineImage(String? imageUrl) {
    final trimmed = imageUrl?.trim() ?? '';

    if (trimmed.isEmpty) {
      return Image.asset('assets/images/placeholder.png', fit: BoxFit.cover);
    }

    return Image.network(
      trimmed,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
    );
  }

  Widget _buildMedicineInfo(DrugModel drug, int donationCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          drug.brandName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text("Generic: ${drug.genericName}",
            style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 4),
        Text(
          donationCount > 0
              ? "Donations: $donationCount"
              : "No donations available",
          style: TextStyle(
            fontSize: 13,
            color: donationCount == 0 ? Colors.grey : Colors.black,
          ),
        ),
      ],
    );
  }

  void _navigateToDetailPage(DrugModel drug, List<DonationModel> donations) {
    final approvedDonations = donations
        .where((d) => d.status.toLowerCase() == 'approved')
        .map((d) => DonationWithDrug(donation: d, drug: drug))
        .toList();

    if (approvedDonations.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              DonationDetailPage(donationsWithDrug: approvedDonations),
        ),
      );

    }
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadCatalog, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_filteredDrugs.isEmpty) {
      return const Center(child: Text("No available medicines found."));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: _filteredDrugs.length,
      itemBuilder: (context, index) =>
          _buildMedicineCard(_filteredDrugs[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Catalog'),
        backgroundColor: Colors.teal.shade600,
        actions: [_buildCategoryDropdown()],
      ),
      body: _buildContent(),
    );
  }
}