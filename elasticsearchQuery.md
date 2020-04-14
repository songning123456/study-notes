#### USE :index;select * from :type where :fieldName = :fieldValue limit :from, :size;
```
* params => (String)index (String)type (int)from (int)size (String)fieldName (String)fieldValue 

GET /index/type/_search
{
  "from" : from,
  "size" : size,
  "query" : {
    "terms" : {
      "fieldName" : [
        "fieldValue"
      ],
      "boost" : 1.0
    }
  }
}

public List<SearchResult.Hit<Object, Void>> termQuery(String index, String type, int from, int size, String fieldName, String fieldValue) throws Exception {
    SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
    QueryBuilder queryBuilder = QueryBuilders.termsQuery(fieldName, fieldValue);
    searchSourceBuilder.query(queryBuilder);
    searchSourceBuilder.from(from);
    searchSourceBuilder.size(size);
    String query = searchSourceBuilder.toString();
    Search search = new Search.Builder(query).addIndex(index).addType(type).build();
    SearchResult searchResult = jestClient.execute(search);
    return searchResult.getHits(Object.class);
}
```

#### USE :index;select * from :type where :fieldName = :fieldValue order by :sortField :sortType(ASC,DESC) limit :from, :size;
```
* params => (String)index (String)type (int)from (int)size (String)fieldName (String)fieldValue (String)sortField sortType(ASC,DESC)

GET /index/type/_search
{
  "from" : from,
  "size" : size,
  "query" : {
    "terms" : {
      "fieldName" : [
        "fieldValue"
      ],
      "boost" : 1.0
    }
  },
  "sort" : [
    {
      "sortField" : {
        "order" : "sortType(asc, desc)"
      }
    }
  ]
}

public List<SearchResult.Hit<Object, Void>> termQuery(String index, String type, int from, int size, String sortField, boolean sortType, String fieldName, String fieldValue) throws Exception {
    SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
    QueryBuilder queryBuilder = QueryBuilders.termsQuery(fieldName, fieldValue);
    searchSourceBuilder.query(queryBuilder);
    searchSourceBuilder.from(from);
    searchSourceBuilder.size(size);
    if (sortType) {
        searchSourceBuilder.sort(sortField, SortOrder.ASC);
    } else {
        searchSourceBuilder.sort(sortField, SortOrder.DESC);
    }
    String query = searchSourceBuilder.toString();
    Search search = new Search.Builder(query).addIndex(index).addType(type).build();
    SearchResult searchResult = jestClient.execute(search);
    return searchResult.getHits(Object.class);
}

```

#### USE :index;select * from :type order by :sortField :sortType limit :from, :size;
```
* params => (String)index (String)type (int)from (int)size (String)sortField sortType(ASC,DESC)

GET /index/type/_search
{
  "from" : from,
  "size" : size,
  "sort" : [
    {
      "sortField" : {
        "order" : "sortType"
      }
    }
  ]
}

public List<SearchResult.Hit<Object, Void>> termQuery(String index, String type, int from, int size, String sortField, boolean sortType) throws Exception {
    SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
    searchSourceBuilder.from(from);
    searchSourceBuilder.size(size);
    if (sortType) {
        searchSourceBuilder.sort(sortField, SortOrder.ASC);
    } else {
        searchSourceBuilder.sort(sortField, SortOrder.DESC);
    }
    String query = searchSourceBuilder.toString();
    Search search = new Search.Builder(query).addIndex(index).addType(type).build();
    SearchResult searchResult = jestClient.execute(search);
    return searchResult.getHits(Object.class);
}


```

#### USE :index;select * from :type where :fieldName in :fieldValues limit :from, :size;
```
* params => (String)index (String)type (int)from (int)size (String)fieldName (String[])fieldValues 

GET /index/type/_search
{
  "from" : from,
  "size" : size,
  "query" : {
    "terms" : {
      "fieldName" : [
        "fieldValues[0]",
        "fieldValues[1]",
        ......
      ],
      "boost" : 1.0
    }
  }
}

public List<SearchResult.Hit<Object, Void>> termsQuery(String index, String type, int from, int size, String fieldName, String[] fieldValues) throws Exception {
    SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
    QueryBuilder queryBuilder = QueryBuilders.termsQuery(fieldName, fieldValues);
    searchSourceBuilder.query(queryBuilder);
    searchSourceBuilder.from(from);
    searchSourceBuilder.size(size);
    String query = searchSourceBuilder.toString();
    Search search = new Search.Builder(query).addIndex(index).addType(type).build();
    SearchResult searchResult = jestClient.execute(search);
    return searchResult.getHits(Object.class);
}
```

#### USE :index;select * from :type where :fieldName1 = :fieldValue1 and :fieldName2 = :fieldValue2 and :fieldName3 = :fieldValue3 limit :from, :size;
```
* params => (String)index (String)type (int)from (int)size

GET /index/type/_search
{
  "from" : from,
  "size" : size,
  "query" : {
    "bool" : {
      "must" : [
        {
          "terms" : {
            "fieldName1" : [
              "fieldValue1"
            ],
            "boost" : 1.0
          }
        },
        {
          "terms" : {
            "fieldName2" : [
              "fieldValue2"
            ],
            "boost" : 1.0
          }
        },
        {
          "terms" : {
            "fieldName3" : [
              "fieldValue3"
            ],
            "boost" : 1.0
          }
        }
      ],
      "disable_coord" : false,
      "adjust_pure_negative" : true,
      "boost" : 1.0
    }
  }
}

public List<SearchResult.Hit<Object, Void>> boolTermsQuery(String index, String type, int from, int size, Map<String, Object> params) throws Exception {
    SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
    BoolQueryBuilder queryBuilder = QueryBuilders.boolQuery();
    for (Map.Entry<String, Object> item : params.entrySet()) {
        String fieldName = item.getKey();
        Object fieldValue = item.getValue();
        queryBuilder.must(QueryBuilders.termsQuery(fieldName, fieldValue));
    }
    searchSourceBuilder.query(queryBuilder);
    searchSourceBuilder.from(from);
    searchSourceBuilder.size(size);
    String query = searchSourceBuilder.toString();
    Search search = new Search.Builder(query).addIndex(index).addType(type).build();
    SearchResult searchResult = jestClient.execute(search);
    return searchResult.getHits(Object.class);
}
```

#### select * from :type where :fieldName1 = :fieldValue1 and :fieldName2 = :fieldValue2 and :fieldName3 = :fieldValue3 order by :sortField :sortType limit :from, :size;
```
* params => (String)index (String)type (int)from (int)size

GET /index/type/_search
{
  "from" : from,
  "size" : size,
  "query" : {
    "bool" : {
      "must" : [
        {
          "terms" : {
            "fieldName1" : [
              "fieldValue1"
            ],
            "boost" : 1.0
          }
        },
        {
          "terms" : {
            "fieldName2" : [
              "fieldValue2"
            ],
            "boost" : 1.0
          }
        }
      ],
      "disable_coord" : false,
      "adjust_pure_negative" : true,
      "boost" : 1.0
    }
  },
  "sort" : [
    {
      "sortField" : {
        "order" : "sortType"
      }
    }
  ]
}

public List<SearchResult.Hit<Object, Void>> boolTermsQuery(String index, String type, int from, int size, String sortField, Boolean sortType, Map<String, Object> params) throws Exception {
    SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
    BoolQueryBuilder queryBuilder = QueryBuilders.boolQuery();
    for (Map.Entry<String, Object> item : params.entrySet()) {
        String fieldName = item.getKey();
        Object fieldValue = item.getValue();
        queryBuilder.must(QueryBuilders.termsQuery(fieldName, fieldValue));
    }
    searchSourceBuilder.query(queryBuilder);
    searchSourceBuilder.from(from);
    searchSourceBuilder.size(size);
    if (sortType) {
        searchSourceBuilder.sort(sortField, SortOrder.ASC);
    } else {
        searchSourceBuilder.sort(sortField, SortOrder.DESC);
    }
    String query = searchSourceBuilder.toString();
    Search search = new Search.Builder(query).addIndex(index).addType(type).build();
    SearchResult searchResult = jestClient.execute(search);
    return searchResult.getHits(Object.class);
}
```

#### select * from :type where :fieldName1 = :fieldValue1 and :fieldName2 = :fieldValue2 and :fieldName3 = :fieldValue3 and :fieldName > :min and :fieldName < :max order by :sortField :sortType limit :from, :size;
```
GET /index/type/_search
{
  "from" : from,
  "size" : size,
  "query" : {
    "bool" : {
      "must" : [
        {
          "terms" : {
            "fieldName1" : [
              "fieldValue1"
            ],
            "boost" : 1.0
          }
        },
        {
          "terms" : {
            "fieldName2" : [
              "fieldValue2"
            ],
            "boost" : 1.0
          }
        },
        {
          "range" : {
            "rangeFieldName" : {
              "from" : "min",
              "to" : "max",
              "include_lower" : false,
              "include_upper" : false,
              "boost" : 1.0
            }
          }
        }
      ],
      "disable_coord" : false,
      "adjust_pure_negative" : true,
      "boost" : 1.0
    }
  },
  "sort" : [
    {
      "sortFieldName" : {
        "order" : "sortType"
      }
    }
  ]
}

public List<SearchResult.Hit<Object, Void>> boolTermsRangeQuery(String index, String type, int from, int size, String sortField, Boolean sortType, Map<String, Object> params, String fieldName, Map<String, Object> range) throws Exception {
    SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
    BoolQueryBuilder queryBuilder = QueryBuilders.boolQuery();
    for (Map.Entry<String, Object> item : params.entrySet()) {
        String key = item.getKey();
        Object value = item.getValue();
        queryBuilder.must(QueryBuilders.termsQuery(key, value));
    }
    RangeQueryBuilder rangeQueryBuilder = QueryBuilders.rangeQuery(fieldName);
    Object gt = range.get("gt");
    Object lt = range.get("lt");
    Object gte = range.get("gte");
    Object lte = range.get("lte");
    if (gt != null) {
        rangeQueryBuilder.gt(gt);
    } else if (gte != null) {
        rangeQueryBuilder.gte(gte);
    }
    if (lt != null) {
        rangeQueryBuilder.lt(lt);
    } else if (lte != null) {
        rangeQueryBuilder.lte(lte);
    }
    queryBuilder.must(rangeQueryBuilder);
    searchSourceBuilder.query(queryBuilder);
    searchSourceBuilder.from(from);
    searchSourceBuilder.size(size);
    if (sortType) {
        searchSourceBuilder.sort(sortField, SortOrder.ASC);
    } else {
        searchSourceBuilder.sort(sortField, SortOrder.DESC);
    }
    String query = searchSourceBuilder.toString();
    Search search = new Search.Builder(query).addIndex(index).addType(type).build();
    SearchResult searchResult = jestClient.execute(search);
    return searchResult.getHits(Object.class);
}
```

#### USE :index;select * from :type where id = :id
```
* params => (String)index (String)type (String)id

GET /index/type/id

public Object findById(String index, String type, String id) throws Exception {
    Get get = new Get.Builder(index, id).type(type).build();
    JestResult result = jestClient.execute(get);
    return result.getSourceAsObject(Object.class);
}
```

#### select * from :type where :fieldName > :min and :fieldName < :max order by :sortField :sortType limit :from, :size;
```
* params => (String)index (String)type (int)from (int)size (String)fieldName (String)fieldValue (String)sortField sortType(ASC,DESC)

GET /index/type/_search
{
  "from" : from,
  "size" : size,
  "query" : {
    "range" : {
      "fieldName" : {
        "from" : "min",
        "to" : "max",
        "include_lower" : true,
        "include_upper" : true,
        "boost" : 1.0
      }
    }
  },
  "sort" : [
    {
      "sortField" : {
        "order" : "sortType"
      }
    }
  ]
}

public List<SearchResult.Hit<Object, Void>> rangeQuery(String index, String type, int from, int size, String fieldName, Map<String, Object> range, String sortField, boolean sortType) throws Exception {
    SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
    RangeQueryBuilder rangeQueryBuilder = QueryBuilders.rangeQuery(fieldName);
    Object gt = range.get("gt");
    Object lt = range.get("lt");
    Object gte = range.get("gte");
    Object lte = range.get("lte");
    if (gt != null) {
        rangeQueryBuilder.gt(gt);
    } else if (gte != null) {
        rangeQueryBuilder.gte(gte);
    }
    if (lt != null) {
        rangeQueryBuilder.lt(lt);
    } else if (lte != null) {
        rangeQueryBuilder.lte(lte);
    }
    searchSourceBuilder.query(rangeQueryBuilder);
    searchSourceBuilder.from(from);
    searchSourceBuilder.size(size);
    if (sortType) {
        searchSourceBuilder.sort(sortField, SortOrder.ASC);
    } else {
        searchSourceBuilder.sort(sortField, SortOrder.DESC);
    }
    String query = searchSourceBuilder.toString();
    Search search = new Search.Builder(query).addIndex(index).addType(type).build();
    SearchResult searchResult = jestClient.execute(search);
    return searchResult.getHits(Object.class);
}
```