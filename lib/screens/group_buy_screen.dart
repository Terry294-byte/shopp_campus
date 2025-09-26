import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/group_buy_provider.dart';
import '../models/group_buy_model.dart';
import '../constants/app_colors.dart';
import '../widgets/title_text.dart';

class GroupBuyScreen extends StatefulWidget {
  const GroupBuyScreen({super.key});

  @override
  State<GroupBuyScreen> createState() => _GroupBuyScreenState();
}

class _GroupBuyScreenState extends State<GroupBuyScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupBuyProvider>().fetchActiveGroupBuys();
      context.read<GroupBuyProvider>().fetchMyGroupBuys();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupBuyProvider = Provider.of<GroupBuyProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const TitleTextWidget(label: 'Group Buys', fontSize: 20),
        backgroundColor: isDark ? Colors.grey[900] : AppColors.primaryRed,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'My Group Buys'),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGroupBuyList(groupBuyProvider.activeGroupBuys, 'No active group buys'),
          _buildGroupBuyList(groupBuyProvider.myGroupBuys, 'You haven\'t joined any group buys yet'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/join-group-buy'),
        backgroundColor: AppColors.primaryRed,
        child: const Icon(Icons.group_add, color: Colors.white),
      ),
    );
  }

  Widget _buildGroupBuyList(List<GroupBuyModel> groupBuys, String emptyMessage) {
    final groupBuyProvider = Provider.of<GroupBuyProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (groupBuyProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (groupBuys.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: TextStyle(
            color: isDark ? Colors.white70 : AppColors.lightGrey,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupBuys.length,
      itemBuilder: (context, index) {
        final groupBuy = groupBuys[index];
        final isJoined = groupBuy.participantIds.contains(context.read<GroupBuyProvider>().currentUser?.uid);

        return Card(
          color: isDark ? AppColors.darkGrey.withOpacity(0.8) : AppColors.white,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        groupBuy.productImage,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleTextWidget(
                            label: groupBuy.productName,
                            fontSize: 16,
                            color: isDark ? Colors.white : AppColors.black,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${groupBuy.originalPrice.toStringAsFixed(2)} → \$${groupBuy.discountedPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Participants: ${groupBuy.currentParticipants}/${groupBuy.targetParticipants}',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : AppColors.lightGrey,
                            ),
                          ),
                          Text(
                            'Expires: ${groupBuy.expiresAt.day}/${groupBuy.expiresAt.month}/${groupBuy.expiresAt.year}',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : AppColors.lightGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isJoined && !groupBuy.isComplete && groupBuy.isActive && !groupBuy.isExpired)
                      ElevatedButton(
                        onPressed: () async {
                          await groupBuyProvider.joinGroupBuy(groupBuy.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Join'),
                      )
                    else if (isJoined)
                      const Chip(
                        label: Text('Joined'),
                        backgroundColor: Colors.green,
                        labelStyle: TextStyle(color: Colors.white),
                      )
                    else
                      const Chip(
                        label: Text('Full'),
                        backgroundColor: Colors.grey,
                      ),
                  ],
                ),
                if (isJoined) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Share Code: ${groupBuy.shareCode}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => groupBuyProvider.shareGroupBuy(groupBuy),
                        icon: Icon(
                          Icons.share,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
