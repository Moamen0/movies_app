import 'package:flutter/material.dart';
import 'package:movies_app/api/auth_api.dart';
import 'package:movies_app/model/Api_response.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_color.dart';
import 'package:movies_app/utils/app_route.dart';
import 'package:movies_app/utils/app_style.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  UserModel? currentUser;

  List<Map<String, dynamic>> wishlistMovies = [];
  List<Map<String, dynamic>> historyMovies = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => isLoading = true);

    try {
      final response = await AuthMangerApi.getProfile();

      if (response.success && response.data != null) {
        currentUser = response.data as UserModel;
        await AuthMangerApi.saveUserData(currentUser!);
      } else {
        currentUser = await AuthMangerApi.getUserData();
      }
    } catch (e) {
      print("Load User Data Error: $e");
      currentUser = await AuthMangerApi.getUserData();
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColor.blackColor,
        body: Center(
          child: CircularProgressIndicator(color: AppColor.yellow),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColor.blackColor,
      body: SafeArea(
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(height, width),

            // Tab Bar
            _buildTabBar(),

            // Movies Grid
            Expanded(
              child: _buildMoviesGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(double height, double width) {
    String avatarPath = currentUser?.avaterId != null
        ? 'assets/images/avatar${currentUser!.avaterId}.png'
        : AppAssets.avatar1;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: height * 0.02,
      ),
      child: Column(
        children: [
          // Avatar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    width: width * 0.3,
                    height: height * 0.14,
                    child: ClipOval(
                      child: Image.asset(
                        avatarPath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColor.grayColor,
                            child: Icon(Icons.person,
                                size: 40, color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.015),
                  Text(currentUser?.name ?? 'User Name',
                      style: AppStyle.bold20White),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStat(
                    count: wishlistMovies.length.toString(),
                    label: 'Wish List',
                  ),
                  SizedBox(width: width * 0.1),
                  _buildStat(
                    count: historyMovies.length.toString(),
                    label: 'History',
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: height * 0.025),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Edit Profile Button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoute.updateProfile);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.yellow,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.06,
                      vertical: height * 0.018,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text('Edit Profile', style: AppStyle.reglur16black),
                ),
              ),
              SizedBox(width: width * 0.04),

              // Exit Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await AuthMangerApi.logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoute.loginScreen,
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.06,
                      vertical: height * 0.014,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Exit', style: AppStyle.reglur20white),
                      SizedBox(width: 4),
                      Icon(Icons.logout, size: 20, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat({required String count, required String label}) {
    return Column(
      children: [
        Text(count, style: AppStyle.bold26White),
        SizedBox(height: 4),
        Text(label, style: AppStyle.bold24White),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColor.yellow,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        labelStyle: AppStyle.reglur20white,
        dividerColor: AppColor.transparent,
        
        tabs: [
          Tab(
            icon: Icon(
              Icons.list,
              size: 39,
              color: AppColor.yellow,
            ),
            text: 'Watch List',
          ),
          Tab(
            icon: Icon(
              Icons.folder,
              size: 35,
              color: AppColor.yellow,
            ),
            text: 'History',
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesGrid() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildMoviesList(wishlistMovies),
        _buildMoviesList(historyMovies),
      ],
    );
  }

  Widget _buildMoviesList(List<Map<String, dynamic>> movies) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.popcorn),
            SizedBox(height: 16),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return _buildMovieCard(movies[index]);
      },
    );
  }

  Widget _buildMovieCard(Map<String, dynamic> movie) {
    return GestureDetector(
      onTap: () {
        // Navigate to movie details
        Navigator.pushNamed(
          context,
          AppRoute.movieDetailsScreen,
          arguments: movie['id'],
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.grayColor,
        ),
        child: Stack(
          children: [
            // Movie Poster
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColor.yellow.withOpacity(0.3),
                    AppColor.grayColor,
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.movie_outlined,
                  size: 40,
                  color: Colors.grey[600],
                ),
              ),
            ),

            // Rating Badge
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movie['rating'].toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.star,
                      color: AppColor.yellow,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
