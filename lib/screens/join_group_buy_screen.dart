import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/group_buy_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/title_text.dart';

class JoinGroupBuyScreen extends StatefulWidget {
  const JoinGroupBuyScreen({super.key});

  @override
  State<JoinGroupBuyScreen> createState() => _JoinGroupBuyScreenState();
}

class _JoinGroupBuyScreenState extends State<JoinGroupBuyScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupBuyProvider = Provider.of<GroupBuyProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const TitleTextWidget(label: 'Join Group Buy', fontSize: 20),
        backgroundColor: isDark ? Colors.grey[900] : AppColors.primaryRed,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleTextWidget(
              label: 'Enter Group Buy Code',
              fontSize: 18,
              color: isDark ? Colors.white : AppColors.black,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                hintText: 'Enter code (e.g., ABC12)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: isDark ? AppColors.darkGrey.withOpacity(0.8) : Colors.white,
              ),
              textCapitalization: TextCapitalization.characters,
              maxLength: 5,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: groupBuyProvider.isLoading
                    ? null
                    : () async {
                        if (_codeController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a code')),
                          );
                          return;
                        }
                        await groupBuyProvider.joinGroupBuyByCode(_codeController.text.toUpperCase());
                        if (mounted) Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: groupBuyProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Join Group Buy',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            TitleTextWidget(
              label: 'Active Group Buys',
              fontSize: 18,
              color: isDark ? Colors.white : AppColors.black,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: groupBuyProvider.activeGroupBuys.isEmpty
                  ? Center(
                      child: Text(
                        'No active group buys available',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : AppColors.lightGrey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: groupBuyProvider.activeGroupBuys.length,
                      itemBuilder: (context, index) {
                        final groupBuy = groupBuyProvider.activeGroupBuys[index];
                        return Card(
                          color: isDark ? AppColors.darkGrey.withOpacity(0.8) : AppColors.white,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                groupBuy.productImage,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              groupBuy.productName,
                              style: TextStyle(
                                color: isDark ? Colors.white : AppColors.black,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${groupBuy.currentParticipants}/${groupBuy.targetParticipants} participants',
                                  style: TextStyle(
                                    color: isDark ? Colors.white70 : AppColors.lightGrey,
                                  ),
                                ),
                                Text(
                                  'Save ${groupBuy.discountPercentage}%',
                                  style: TextStyle(
                                    color: AppColors.primaryRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            trailing: ElevatedButton(
                              onPressed: () async {
                                await groupBuyProvider.joinGroupBuy(groupBuy.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryRed,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Join'),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
