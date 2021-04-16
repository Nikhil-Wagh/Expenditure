# Expenditure
App that manages your expenses

## Simple list of Features available to User

1. Login and Logout
   - Google
   - Facebook
   - Twitter
2. Able to add an Expenditure
   - Currency -- default should come from User's personal info
   - Amount
   - Description
   - Mode of transaction
   - Location
   - Category of product/service bought
   - Timestamp
3. Update an Expenditure
4. Delete an Expenditure
5. Filter Expenditures based on
   - Month
   - Year
   - Amount
   - Description
   - Fuzzy find any of the above
6. Able to add/update Personal info critical for App
   - Currency
   - Monthly Salary -- may vary for each month
   
   
## Tech Spec

### ExpenditureItem
Store for information related to the expenditure transaction done by user

#### Attributes
1. Amount
2. description
3. mode
4. timestamp
5. location
6. isSelected
   isSelected is used in UI to highlight the selected Expenditure
   
#### Methods
1. 

### ExpendituresList

#### Attributes
1. _items<ExpendituresItem>


### Amount

#### Attributes
1. actualAmount
2. currency
