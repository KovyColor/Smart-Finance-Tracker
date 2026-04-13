import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_proj/data/models/settings_model.dart';
import 'package:final_proj/presentation/viewmodels/analytics_view_model.dart';
import 'package:final_proj/presentation/viewmodels/settings_view_model.dart';
import 'package:final_proj/presentation/widgets/bar_chart_weekly_widget.dart';
import 'package:final_proj/presentation/widgets/line_chart_monthly_widget.dart';
import 'package:final_proj/presentation/widgets/pie_chart_widget.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Load analytics data when screen initializes
    Future.microtask(() {
      context.read<AnalyticsViewModel>().loadAnalyticsData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Categories'),
            Tab(text: 'Monthly'),
            Tab(text: 'Weekly'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<AnalyticsViewModel>().loadAnalyticsData(),
        child: Consumer2<AnalyticsViewModel, SettingsViewModel>(
          builder: (context, analyticsVM, settingsVM, _) {
            if (analyticsVM.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (analyticsVM.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(analyticsVM.error!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          analyticsVM.loadAnalyticsData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final currencySymbol = settingsVM.currency.symbol;

            return TabBarView(
              controller: _tabController,
              children: [
                // Categories Tab
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryCards(analyticsVM, currencySymbol),
                        const SizedBox(height: 24),
                        Text(
                          'Spending by Category',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 300,
                          child: PieChartWidget(
                            categorySpending:
                                analyticsVM.analyticsData.categorySpending,
                            currencySymbol: currencySymbol,
                          ),
                        ),
                        const SizedBox(height: 24),
                        CategorySpendingLegend(
                          categorySpending:
                              analyticsVM.analyticsData.categorySpending,
                          currencySymbol: currencySymbol,
                        ),
                      ],
                    ),
                  ),
                ),
                // Monthly Tab
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monthly Report',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 300,
                          child: LineChartMonthlyWidget(
                            monthlyData: analyticsVM.analyticsData.monthlyData,
                            currencySymbol: currencySymbol,
                          ),
                        ),
                        const SizedBox(height: 24),
                        MonthlyReportLegend(
                          monthlyData: analyticsVM.analyticsData.monthlyData,
                          currencySymbol: currencySymbol,
                        ),
                      ],
                    ),
                  ),
                ),
                // Weekly Tab
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Spending',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 300,
                          child: BarChartWeeklyWidget(
                            weeklySpending:
                                analyticsVM.analyticsData.weeklySpending,
                            currencySymbol: currencySymbol,
                          ),
                        ),
                        const SizedBox(height: 24),
                        WeeklySpendingLegend(
                          weeklySpending:
                              analyticsVM.analyticsData.weeklySpending,
                          currencySymbol: currencySymbol,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCards(
    AnalyticsViewModel analyticsVM,
    String currencySymbol,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Total Income',
                amount: analyticsVM.totalIncome,
                currencySymbol: currencySymbol,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: 'Total Spending',
                amount: analyticsVM.totalSpending,
                currencySymbol: currencySymbol,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildSummaryCard(
          title: 'Net Amount',
          amount: analyticsVM.netAmount,
          currencySymbol: currencySymbol,
          color: analyticsVM.netAmount >= 0 ? Colors.green : Colors.red,
          isFullWidth: true,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required String currencySymbol,
    required Color color,
    bool isFullWidth = false,
  }) {
    final child = Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              '$currencySymbol${amount.toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );

    return isFullWidth ? child : child;
  }
}
