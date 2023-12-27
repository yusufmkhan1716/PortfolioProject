#!/usr/bin/env python
# coding: utf-8

# In[6]:


# Import Libraries

import pandas as pd
import seaborn as sns
import numpy as np

import matplotlib
import matplotlib.pyplot as plt
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8) # Adjusts the configuration of the plots we will create


# Read in the data

df = pd.read_csv(r'C:\Users\quinc\OneDrive\Desktop\Data Analyst Portfolio Project\movies.csv')


# In[5]:


# Let's look at the data

df.head()


# In[7]:


# Check for missing data

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}'.format(col, pct_missing))


# In[8]:


# Looking at the data types of the columns

df.dtypes


# In[48]:


# Changing the format of the data type of the budget, gross and votes column

df['votes'] = df['votes'].astype('int64')

df['budget'] = df['budget'].astype('int64')

df['gross'] = df['gross'].astype('int64')


# In[13]:


df


# In[40]:


# Order data by gross revenue

df.sort_values(by=['gross'], inplace=False, ascending=False)


# In[18]:


# Looking at the total data
pd.set_option('display.max_rows', None)


# In[20]:


# Check and temporarily drop duplicates for viewing purposes

df['company'].drop_duplicates().sort_values(ascending=False)


# In[24]:


# Scatter plot with budget vs gross 

plt.scatter(x=df['budget'], y=df['gross'])

plt.title('Budget vs Gross Earnings')

plt.xlabel('Budget for film')

plt.ylabel('Gross earnings')

plt.show()


# In[22]:


df.head()


# In[26]:


# Plot budget vs gross using seaborn or a linear model to depict the correlation between the budget and gross 

sns.regplot(x='budget', y='gross', data=df, scatter_kws={"color": "red"}, line_kws={"color":"blue"})


# In[35]:


df.head()


# In[37]:


df_numerized = df

for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes

df_numerized


# In[39]:


# Creating the year column

df['yearcorrect'] = df['released'].astype(str).str[:4]

df


# In[41]:


df


# In[44]:


df_numerized.corr()


# In[45]:


correlation_mat = df_numerized.corr()

corr_pairs = correlation_mat.unstack()

corr_pairs


# In[46]:


sorted_pairs = corr_pairs.sort_values()

sorted_pairs


# In[47]:


high_corr = sorted_pairs[(sorted_pairs) > 0.5]

high_corr


# In[ ]:




