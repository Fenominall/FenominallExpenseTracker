
# EssentialNews App

Welcome to the EssentialNews App! This iOS application provides users with mock news articles from various sources. It features a clean and intuitive interface, making it easy for users to stay updated on current events.

# Features:
- Latest News: Browse through the most recent news articles.
- Article Details: Read full news articles with detailed information.
- Refresh: Pull to refresh the news feed to get the latest updates.

![NewsAppDark](https://github.com/Fenominall/EssentialNews/blob/main/NewsAppDark.png)
![NewsAppLight](https://github.com/Fenominall/EssentialNews/blob/main/NewsAppLight.png)

#
### BDD Specs

## News Feed Feature Specs

### Story: Customer requests to see the news articles feed

### Narrative #1

```
As an online customer
I want the app to automatically load the latest news articles feed
So I can always enjoy the newest articles in the app
```

#### Scenarios (Acceptance criteria)

```
Given the customer has connectivity
 When the customer requests to see news feed
 Then the app should display the latest feed from remote
  And replace the cache with the new feed
```

### Narrative #2

```
As an offline customer
I want the app to show the latest saved version of news feed
So I can always enjoy news of the world
```

#### Scenarios (Acceptance criteria)

```
Given the customer doesn't have connectivity
  And there’s a cached version of the feed
  And the cache is less than seven days old
 When the customer requests to see the feed
 Then the app should display the latest feed saved

Given the customer doesn't have connectivity
  And there’s a cached version of the feed
  And the cache is seven days old or more
 When the customer requests to see the feed
 Then the app should display an error message

Given the customer doesn't have connectivity
  And the cache is empty
 When the customer requests to see the feed
 Then the app should display an error message
```

## Use Cases

### Load Feed From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Articles Feed" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates articles feed from valid data.
5. System delivers image feed.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

### Load News Feed Image Data From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Image Data" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System delivers image data.

#### Cancel course:
1. System does not deliver image data nor error.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

## Model Specs

###Source

| Property      | Type                      |
|---------------|---------------------------|
| 'id'          | 'String' (optional)       |
| ‘name’        | 'String'                  |

###Article

| Property      | Type                      |
|---------------|---------------------------|
| 'source'      | 'Source'                  |
| ‘author’      | 'String' (optional)       |
| 'title'       | 'String'                  |
| 'description' | 'String' (optional)       |
| ‘url’         | 'URL'                     |
| 'urlToImage'  | 'URL' (optional)          |
| 'publishedAt' | 'Date'                    |
| 'content'     | 'String' (optional)       |

### Load Feed From Cache Use Case

#### Primary course:
1. Execute "Load Articles Feed" command with above data.
2. System retrieves feed data from cache.
3. System validates cache is less than seven days old.
4. System creates image feed from cached data.
5. System delivers image feed.

#### Retrieval error course (sad path):
1. System delivers error.

#### Expired cache course (sad path): 
1. System delivers no feed articles.

#### Empty cache course (sad path): 
1. System delivers no feed articles.

---

### Load Articles Feed Image Data From Cache Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Image Data" command with above data.
2. System retrieves data from the cache.
3. System delivers cached image data.

#### Cancel course:
1. System does not deliver image data nor error.

#### Retrieval error course (sad path):
1. System delivers error.

#### Empty cache course (sad path):
1. System delivers not found error.

---

# Load Articles Feed FlowChart
![ArticlesLoadFlowChart](https://github.com/Fenominall/EssentialNews/blob/main/ArticlesLoadFlowChart.png)

#
### Validate Articles Feed Cache Use Case

#### Primary course:
1. Execute "Validate Cache" command with above data.
2. System retrieves feed data from cache.
3. System validates cache is less than seven days old.

#### Retrieval error course (sad path):
1. System deletes cache.

#### Expired cache course (sad path):
1. System deletes cache.

---

### Cache Feed Use Case

#### Data:
- Articles

#### Primary course (happy path):
1. Execute "Save Articles" command with above data.
2. System deletes old cache data.
3. System encodes articles feed.
4. System timestamps the new cache.
5. System saves new cache data.
6. System delivers success message.

#### Deleting error course (sad path):
1. System delivers error.

#### Saving error course (sad path):
1. System delivers error.

---

### Cache Feed Image Data Use Case

#### Data:
- Image Data

#### Primary course (happy path):
1. Execute "Save Image Data" command with above data.
2. System caches image data.
3. System delivers success message.

#### Saving error course (sad path):
1. System delivers error.

---
# Article Details Feature Specs
### Story: Customer requests to see article details
### Narrative

```
As an online customer
I want the app to load article details
So I can read the full details in an article from my feed
```

### Scenarios (Acceptance criteria)

```
Given the customer has connectivity
 When the customer requests to see article details on an article
 Then the app should display all details of that article

Given the customer doesn't have connectivity
 When the customer requests to see details on an article
 Then the app should display an error message
```

## Use Cases
### Load Article Details From Remote Use Case
### Data:

### Primary course (happy path):
Execute "Load Image Data" command with above data.
System loads data from remote service.
System validates data.
System creates comments from valid data.
System delivers comments.

### Invalid data – error course (sad path):
System delivers invalid data error.

### No connectivity – error course (sad path):
System delivers connectivity error.


# App Architecture
![EssentialNewsAppArchitecture](https://github.com/Fenominall/EssentialNews/blob/main/EssentialNewsAppArchitecture.png)
