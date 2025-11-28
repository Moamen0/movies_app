import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movies_app/api/api_manger.dart';
import 'package:movies_app/api/api_model/MoviesResponse.dart';
import 'package:movies_app/ui/home_tab/movies_item/movies_item.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/custom_text_form_field.dart';
import '../../utils/app_color.dart';
import '../../utils/app_style.dart';

class SearchTab extends StatefulWidget {
  SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  TextEditingController controller = TextEditingController();
  
  // ✅ FIXED: Added state management
  String _searchQuery = '';
  Timer? _debounceTimer;
  bool _isSearching = false;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    controller.dispose();
    super.dispose();
  }

  // ✅ NEW: Debounced search to prevent too many API calls
  void _onSearchChanged(String value) {
    // Cancel previous timer
    _debounceTimer?.cancel();
    
    // Start new timer (500ms delay)
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _searchQuery = value.trim();
          _isSearching = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(
        title: CustomTextFormField(
          prefixIcon: Image.asset(AppAssets.unSelectedIconSearch),
          hint: 'Search movies...',
          controller: controller,
          keyboardType: TextInputType.text,
          maxLines: 1,
          onChanged: _onSearchChanged, // ✅ Using debounced method
        ),
      ),
      body: _buildBody(height, width),
    );
  }

  Widget _buildBody(double height, double width) {
    // Show placeholder when no search
    if (_searchQuery.isEmpty && !_isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 100,
              color: AppColor.grayColor,
            ),
            SizedBox(height: height * 0.02),
            Text(
              'Search for movies',
              style: AppStyle.reglur20white,
            ),
          ],
        ),
      );
    }

    return FutureBuilder<MoviesResponse>(
      // ✅ FIXED: Only fetch when search query exists
      future: _searchQuery.isNotEmpty 
          ? ApiManager.getMoviesBy(_searchQuery)
          : null,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: AppColor.yellow),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(width * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red),
                  SizedBox(height: height * 0.02),
                  Text(
                    'Error loading results',
                    style: AppStyle.bold20White,
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    snapshot.error.toString(),
                    style: AppStyle.reglur14white,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: height * 0.03),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                    child: Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }

        // Check API status
        if (snapshot.hasData && snapshot.data!.status != 'ok') {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  snapshot.data!.statusMessage ?? 'API Error',
                  style: AppStyle.bold20White,
                ),
                SizedBox(height: height * 0.02),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                  child: Text('Try again'),
                ),
              ],
            ),
          );
        }

        // Empty results
        var moviesList = snapshot.data?.data?.movies ?? [];
        if (moviesList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.movie_filter_outlined,
                  size: 80,
                  color: AppColor.grayColor,
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'No movies found for "$_searchQuery"',
                  style: AppStyle.bold20White,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Success - show results
        return Padding(
          padding: EdgeInsets.all(width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Result count
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.02,
                  bottom: height * 0.02,
                ),
                child: Text(
                  'Found ${moviesList.length} results',
                  style: AppStyle.reglur16white,
                ),
              ),
              
              // Movies grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: width * 0.03,
                    mainAxisSpacing: height * 0.02,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    return MoviesItem(movie: moviesList[index]);
                  },
                  itemCount: moviesList.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}