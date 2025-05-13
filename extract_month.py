# Extract month-year and aggregate sales
monthly_sales = df.groupby(df['Order Date'].dt.to_period('M'))['Sales'].sum().reset_index()
monthly_sales['Order Date'] = monthly_sales['Order Date'].astype(str)

plt.figure(figsize=(12, 5))
sns.lineplot(data=monthly_sales, x='Order Date', y='Sales', color='#1f77b4')
plt.title("Monthly Sales Trend (Key Insight: Q4 Peak)", fontweight='bold')
plt.xticks(rotation=45)
plt.axvline(x='2017-12', color='red', linestyle='--', label='Holiday Spike')  # Highlight Dec
plt.legend()
plt.show()