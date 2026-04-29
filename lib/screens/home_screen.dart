import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zee_luxury_jewels_app/utils/colors.dart'; 
import 'package:zee_luxury_jewels_app/data/jewelry_data.dart';
import 'package:zee_luxury_jewels_app/models/jewelry_item.dart'; 
import 'package:zee_luxury_jewels_app/providers/wishlist_provider.dart';
import 'package:zee_luxury_jewels_app/screens/product_detail_screen.dart'; 
import 'package:zee_luxury_jewels_app/screens/search_screen.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  late List<JewelryItem> _allItems;

  @override
  void initState() {
    super.initState();
    _allItems = JewelryData.getAllItems();
  }

  List<JewelryItem> get _filteredItems {
    if (_selectedCategory == 'All') return _allItems;
    return _allItems.where((item) => item.category == _selectedCategory).toList();
  }

  List<JewelryItem> get _newArrivals {
    return _allItems.where((item) => item.isNew).toList();
  }

  List<JewelryItem> get _bestsellers {
    return _allItems.where((item) => item.isBestseller).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepBlack,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),
            SliverToBoxAdapter(
              child: _buildHeroBanner(),
            ),
            SliverToBoxAdapter(
              child: _buildCategories(),
            ),
            SliverToBoxAdapter(
              child: _buildNewArrivals(),
            ),
            SliverToBoxAdapter(
              child: _buildBestsellers(),
            ),
            SliverToBoxAdapter(
              child: _buildAllProductsHeader(),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildProductCard(_filteredItems[index]);
                  },
                  childCount: _filteredItems.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 32),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ZEE LUXURY',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: AppColors.primaryGold,
                  letterSpacing: 4,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Discover Elegance',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.lightGray,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.charcoal,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.softGray,
                  width: 0.5,
                ),
              ),
              child: Icon(
                Icons.search,
                color: AppColors.primaryGold,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=800'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryGold,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'NEW COLLECTION',
                style: TextStyle(
                  color: AppColors.deepBlack,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Eternal Brilliance',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                color: AppColors.pureWhite,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Discover our latest masterpieces',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.lightGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = JewelryData.getCategories();
    return Container(
      height: 60,
      margin: EdgeInsets.only(top: 24, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 12),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryGold : AppColors.charcoal,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? AppColors.primaryGold : AppColors.softGray,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? AppColors.deepBlack : AppColors.lightGray,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewArrivals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'New Arrivals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: AppColors.pureWhite,
                  letterSpacing: 1,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryGold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: _newArrivals.length,
            itemBuilder: (context, index) {
              return _buildHorizontalCard(_newArrivals[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBestsellers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bestsellers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: AppColors.pureWhite,
                  letterSpacing: 1,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryGold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: _bestsellers.length,
            itemBuilder: (context, index) {
              return _buildHorizontalCard(_bestsellers[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAllProductsHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _selectedCategory == 'All' ? 'All Products' : _selectedCategory,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: AppColors.pureWhite,
              letterSpacing: 1,
            ),
          ),
          Text(
            '${_filteredItems.length} items',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.lightGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCard(JewelryItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(item: item),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppColors.charcoal,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.softGray,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    item.images[0],
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: item.isNew ? AppColors.primaryGold : AppColors.errorRed,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.isNew ? 'NEW' : 'HOT',
                      style: TextStyle(
                        color: AppColors.deepBlack,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Consumer<WishlistProvider>(
                    builder: (context, wishlist, child) {
                      final isWishlisted = wishlist.isInWishlist(item);
                      return GestureDetector(
                        onTap: () => wishlist.toggleWishlist(item),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.deepBlack.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isWishlisted ? Icons.favorite : Icons.favorite_border,
                            color: isWishlisted ? AppColors.errorRed : AppColors.pureWhite,
                            size: 18,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.category,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.primaryGold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.pureWhite,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\\$${item.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(JewelryItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(item: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.charcoal,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.softGray,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    item.images[0],
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (item.isNew || item.isBestseller)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.isNew ? AppColors.primaryGold : AppColors.errorRed,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.isNew ? 'NEW' : 'HOT',
                        style: TextStyle(
                          color: AppColors.deepBlack,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Consumer<WishlistProvider>(
                    builder: (context, wishlist, child) {
                      final isWishlisted = wishlist.isInWishlist(item);
                      return GestureDetector(
                        onTap: () => wishlist.toggleWishlist(item),
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.deepBlack.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isWishlisted ? Icons.favorite : Icons.favorite_border,
                            color: isWishlisted ? AppColors.errorRed : AppColors.pureWhite,
                            size: 16,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.category,
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.primaryGold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.pureWhite,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.primaryGold,
                        size: 12,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${item.rating}',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.lightGray,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '(${item.reviews})',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.lightGray.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\\$${item.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}