/// API endpoints constants
class ApiEndpoints {
  // Private constructor to prevent instantiation
  ApiEndpoints._();

  // Base URL
  static const String baseUrl = '/api/v1';

  // Auth endpoints
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String logout = '$baseUrl/auth/logout';
  static const String refreshToken = '$baseUrl/auth/refresh-token';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';

  // User endpoints
  static const String getCurrentUser = '$baseUrl/users/me';
  static const String updateProfile = '$baseUrl/users/profile';
  static const String uploadProfileImage = '$baseUrl/users/profile/avatar';
  static const String deleteUser = '$baseUrl/users';

  // Transaction endpoints
  static const String getTransactions = '$baseUrl/transactions';
  static const String getTransaction = '$baseUrl/transactions/:id';
  static const String createTransaction = '$baseUrl/transactions';
  static const String updateTransaction = '$baseUrl/transactions/:id';
  static const String deleteTransaction = '$baseUrl/transactions/:id';
  static const String getTransactionsByCategory = '$baseUrl/transactions/category/:category';
  static const String getTransactionStats = '$baseUrl/transactions/stats';

  // Budget endpoints
  static const String getBudgets = '$baseUrl/budgets';
  static const String getBudget = '$baseUrl/budgets/:id';
  static const String createBudget = '$baseUrl/budgets';
  static const String updateBudget = '$baseUrl/budgets/:id';
  static const String deleteBudget = '$baseUrl/budgets/:id';
  static const String getBudgetProgress = '$baseUrl/budgets/:id/progress';

  // Analytics endpoints
  static const String getDashboard = '$baseUrl/analytics/dashboard';
  static const String getMonthlyReport = '$baseUrl/analytics/monthly-report';
  static const String getCategoryBreakdown = '$baseUrl/analytics/category-breakdown';
  static const String getSpendingTrends = '$baseUrl/analytics/spending-trends';

  // Settings endpoints
  static const String getSettings = '$baseUrl/settings';
  static const String updateSettings = '$baseUrl/settings';

  // Helper methods
  static String getTransactionUrl(String id) => getTransaction.replaceFirst(':id', id);
  static String updateTransactionUrl(String id) => updateTransaction.replaceFirst(':id', id);
  static String deleteTransactionUrl(String id) => deleteTransaction.replaceFirst(':id', id);
  static String getBudgetUrl(String id) => getBudget.replaceFirst(':id', id);
  static String updateBudgetUrl(String id) => updateBudget.replaceFirst(':id', id);
  static String deleteBudgetUrl(String id) => deleteBudget.replaceFirst(':id', id);
  static String getBudgetProgressUrl(String id) => getBudgetProgress.replaceFirst(':id', id);
}
