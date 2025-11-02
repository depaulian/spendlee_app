/* -- API End Points -- */

const String tBaseUrl = 'https://spendlee.com';

// Authentication endpoints
const String tLoginUrl = '$tBaseUrl/users/login';
const String tRegisterUrl = '$tBaseUrl/users/register';
const String tRefreshTokenUrl = '$tBaseUrl/users/refresh';
const String tUserProfileUrl = '$tBaseUrl/users/me';
const String tLogoutUrl = '$tBaseUrl/users/logout';
const String tGoogleLoginUrl = '$tBaseUrl/users/google-login';
const String tAppleLoginUrl = '$tBaseUrl/users/apple-login';
const String tForgotPasswordUrl = '$tBaseUrl/users/forgot-password';
const String tCurrencyUrl = '$tBaseUrl/users/me/currency';

// Transaction endpoints
const String tTransactionsUrl = '$tBaseUrl/transactions/';
const String tExpensesUrl = '$tBaseUrl/transactions/expenses/';
const String tIncomeUrl = '$tBaseUrl/transactions/income/';
const String tBalanceUrl = '$tBaseUrl/transactions/balance';
const String tCategoriesUrl = '$tBaseUrl/transactions/categories';

// Receipt endpoints
const String tReceiptUploadUrl = '$tBaseUrl/receipts/upload';
const String tReceiptsUrl = '$tBaseUrl/receipts/';

// Budget endpoints
const String tBudgetSummaryUrl = '$tBaseUrl/budgets/';
const String tWeeklyBudgetUrl = '$tBaseUrl/budgets/weekly';
const String tMonthlyBudgetUrl = '$tBaseUrl/budgets/monthly';
const String tBudgetAlertsUrl = '$tBaseUrl/budgets/alerts';
const String tBudgetHistoryUrl = '$tBaseUrl/budgets/history';
const String tWeeklyBudgetAutoCreateUrl = '$tBaseUrl/budgets/weekly/auto-create';
const String tMonthlyBudgetAutoCreateUrl = '$tBaseUrl/budgets/monthly/auto-create';
const String tWeeklyBudgetSuggestionUrl = '$tBaseUrl/budgets/suggestions/weekly';
const String tMonthlyBudgetSuggestionUrl = '$tBaseUrl/budgets/suggestions/monthly';

// Report endpoints
const String tWeeklyReportUrl = '$tBaseUrl/reports/weekly';
const String tMonthlyReportUrl = '$tBaseUrl/reports/monthly';
const String tYearlyReportUrl = '$tBaseUrl/reports/yearly';
const String tCategoryBreakdownUrl = '$tBaseUrl/reports/category-breakdown';
const String tSpendingTrendsUrl = '$tBaseUrl/reports/trends';
const String tBudgetVsActualUrl = '$tBaseUrl/reports/budget-vs-actual';
const String tSummaryStatsUrl = '$tBaseUrl/reports/summary';
const String tExportReportUrl = '$tBaseUrl/reports/export';
const String tTopMerchantsUrl = '$tBaseUrl/reports/top-merchants';
const String tExpensePatternsUrl = '$tBaseUrl/reports/expense-patterns';

//Paywall & Subscription Endpoints
const String tPricingUrl = '$tBaseUrl/users/subscription/pricing';
const String tPremiumStatusUrl = '$tBaseUrl/users/premium-status';

// Health check endpoints
const String tHealthCheckUrl = '$tBaseUrl/health';
const String tRootUrl = '$tBaseUrl/';

//Legal endpoints
const String tPrivacyUrl = '$tBaseUrl/privacy';
const String tTosUrl = '$tBaseUrl/terms';
//About
const String tABoutUrl = tBaseUrl;