profit_by_subcat = df.groupby('Sub-Category')['Profit'].sum().sort_values()

plt.figure(figsize=(10, 6))
bars = plt.barh(profit_by_subcat.index, profit_by_subcat.values, 
                color=['red' if x < 0 else 'green' for x in profit_by_subcat.values])
plt.title("Profit by Sub-Category (Key Insight: Tables are Loss-Making)", fontweight='bold')
plt.xlabel("Total Profit")
plt.grid(axis='x', linestyle='--')
plt.show()