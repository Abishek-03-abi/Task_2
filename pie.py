region_sales = df.groupby('Region')['Sales'].sum()

plt.figure(figsize=(6, 6))
plt.pie(region_sales, labels=region_sales.index, autopct='%1.1f%%',
        colors=['#ff9999','#66b3ff','#99ff99','#ffcc99'])
plt.title("Sales Distribution by Region (Key Insight: West Dominates)", fontweight='bold')
plt.show()