import pandas as pd

encodings = ['latin1', 'ISO-8859-1', 'cp1252', 'utf-8']

for encoding in encodings:
    try:
        df = pd.read_csv("Desktop/Superstore.csv", encoding=encoding)
        print(f"Success with encoding: {encoding}")
        break
    except UnicodeDecodeError:
        continue
  
df['Order Date'] = pd.to_datetime(df['Order Date'])