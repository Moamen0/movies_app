// Replace the ProfileTab build method and related methods with this:

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/api/auth_api.dart';
import 'package:movies_app/bloc/movies/movies_bloc.dart';
import 'package:movies_app/bloc/movies/movies_event.dart';
import 'package:movies_app/bloc/movies/movies_state.dart';
import 'package:movies_app/bloc/profile/profile_bloc.dart';
import 'package:movies_app/bloc/profile/profile_event.dart';
import 'package:movies_app/bloc/profile/profile_state.dart';
import 'package:movies_app/generated/l10n.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ProfileBloc>().add(LoadProfileEvent());
    context.read<MoviesBloc>().add(LoadMoviesEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColor.blackColor,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState is ProfileLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColor.yellow),
            );
          }

          if (profileState is ProfileLoaded ||
              profileState is ProfileUpdating ||
              profileState is ProfileUpdateSuccess) {
            final user = profileState is ProfileLoaded
                ? profileState.user
                : profileState is ProfileUpdating
                    ? profileState.currentUser
                    : (profileState as ProfileUpdateSuccess).user;

            final avatarPath = profileState is ProfileLoaded
                ? profileState.avatarPath
                : profileState is ProfileUpdating
                    ? profileState.currentAvatarPath
                    : (profileState as ProfileUpdateSuccess).avatarPath;

            return BlocBuilder<MoviesBloc, MoviesState>(
              builder: (context, moviesState) {
                return SafeArea(
                  child: Column(
                    children: [
                      _buildProfileHeader(
                        height,
                        width,
                        user,
                        avatarPath,
                        moviesState.watchlist.length,
                        moviesState.history.length,
                      ),
                      _buildTabBar(),
                      Expanded(
                        child: _buildMoviesGrid(moviesState),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          if (profileState is ProfileError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle_outlined,
                      size: 100,
                      color: AppColor.yellow.withOpacity(0.5),
                    ),
                    SizedBox(height: height * 0.03),
                    Text(
                      profileState.message,
                      style: AppStyle.bold20White,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: height * 0.04),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.yellow,
                          foregroundColor: Colors.black,
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.02),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          context.read<ProfileBloc>().add(LoadProfileEvent());
                        },
                        icon: Icon(Icons.refresh),
                        label: Text(S.of(context).Retry,
                            style: AppStyle.reglur16black),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    if (profileState.message.contains('login') ||
                        profileState.message.contains('Login'))
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColor.yellow,
                            side: BorderSide(color: AppColor.yellow),
                            padding:
                                EdgeInsets.symmetric(vertical: height * 0.02),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                              AppRoute.loginScreen,
                            );
                          },
                          icon: Icon(Icons.login),
                          label: Text(S.of(context).login,
                              style: AppStyle.reglur16yellow),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(color: AppColor.yellow),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(
    double height,
    double width,
    dynamic user,
    String avatarPath,
    int watchlistCount,
    int historyCount,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: height * 0.02,
      ),
      child: Column(
        children: [
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
                  SizedBox(
                    width: width * 0.29,
                    child: Text(user?.name ?? 'User Name',
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.bold20White),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStat(
                    count: watchlistCount.toString(),
                    label: S.of(context).Wish_List,
                  ),
                  SizedBox(width: width * 0.1),
                  _buildStat(
                    count: historyCount.toString(),
                    label: S.of(context).History,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: height * 0.025),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, AppRoute.updateProfile);
                    if (mounted) {
                      context.read<ProfileBloc>().add(LoadProfileEvent());
                    }
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
            icon: Icon(Icons.list, size: 39, color: AppColor.yellow),
            text: S.of(context).Watch_List,
          ),
          Tab(
            icon: Icon(Icons.folder, size: 35, color: AppColor.yellow),
            text: S.of(context).History,
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesGrid(MoviesState moviesState) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildMoviesList(moviesState.watchlist),
        _buildMoviesList(moviesState.history),
      ],
    );
  }

  Widget _buildMoviesList(List<MovieItem> movies) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.popcorn),
            SizedBox(height: 16),
            Text(
              'No movies yet',
              style: AppStyle.reglur16white,
            ),
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

  Widget _buildMovieCard(MovieItem movie) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoute.movieDetailsScreen,
          arguments: movie.id,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.grayColor,
        ),
        child: Stack(
          children: [
            // Movie Image or Placeholder
            if (movie.image != null && movie.image!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: movie.image!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Center(
                    child: CircularProgressIndicator(
                      color: AppColor.yellow,
                      strokeWidth: 2,
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
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
                ),
              )
            else
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
            if (movie.rating != null)
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
                        movie.rating!.toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.star, color: AppColor.yellow, size: 14),
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
