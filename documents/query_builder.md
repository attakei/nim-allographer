Example: Query Builder
===
[back](../README.md)

## index
- [SLECT](#SELECT)
- [INSERT](#INSERT)
- [UPDATE](#UPDATE)
- [DELETE](#DELETE)
- [RAW_SQL](#RAW_SQL)
- [TARANSACTION](#TARANSACTION)

### SELECT
[to index](#index)

When it returns following table

|id|float|char|datetime|null|is_admin|
|---|---|---|---|---|---|
|1|3.14|char|2019-01-01 12:00:00.1234||1|

#### return JsonNode
```nim
import allographer/query_builder

echo RDB().table("test")
    .select("id", "float", "char", "datetime", "null", "is_admin")
    .get()
```

```nim
>> @[
  {
    "id": 1,                                # JInt
    "float": 3.14,                          # JFloat
    "char": "char",                         # JString
    "datetime": "2019-01-01 12:00:00.1234", # JString
    "null": null                            # JNull
    "is_admin": true                        # JBool
  }
]
```

#### return Object
If object is defined and set arg of get/getRaw/first/find, response will be object as ORM

```nim
import allographer/query_builder

type Typ = ref object
  id: int
  float: float
  char: string
  datetime: string
  null: string
  is_admin: bool

var rows = RDB().table("test")
          .select("id", "float", "char", "datetime", "null", "is_admin")
          .get(Typ())
```

```nim
echo rows[0].id
>> 1                            # int

echo rows[0].float
>> 3.14                         # float

echo rows[0].char
>> "char"                       # string

echo rows[0].datetime
>> "2019-01-01 12:00:00.1234"   # string

echo rows[0].null
>> ""                           # string

echo rows[0].is_admin
>> true                         # bool
```

#### Examples

```nim
import allographer/query_builder

var result = RDB()
            .table("users")
            .select("id", "email", "name")
            .limit(5)
            .offset(10)
            .get()
echo result

>> SELECT id, email, name FROM users LIMIT 5 OFFSET 10
>> @[
  {"id":11,"email":"user11@gmail.com","name":"user11"},
  {"id":12,"email":"user12@gmail.com","name":"user12"},
  {"id":13,"email":"user13@gmail.com","name":"user13"},
  {"id":14,"email":"user14@gmail.com","name":"user14"},
  {"id":15,"email":"user15@gmail.com","name":"user15"}
]
```
```nim
import allographer/query_builder

let resultRow = RDB()
                .table("users")
                .select()
                .where("id", "=", 3)
                .get()
echo resultRow

>> SELECT * FROM users WHERE id = 3
>> @[
  {
    "id":3,
    "name":"user3",
    "email":"user3@gmail.com",
    "address":"246 Ferguson Village Apt. 582\nNew Joshua, IL 24200", "password":"$2a$10$gmKpgtO535lkw0eAcGiRyefdEg6TXr9S.z6vhsn4X.mBYtP0Thfny",
    "salt":"$2a$10$gmKpgtO535lkw0eAcGiRye",
    "birth_date":"2012-11-24",
    "auth":2,
    "created_at":"2019-09-26 19:11:28.159367",
    "updated_at":"2019-09-26 19:11:28.159369"
  }
]
```
```nim
import allographer/query_builder

let resultRow = RDB().table("users").select("id", "name", "email").where("id", ">", 5).first()
echo resultRow

>> SELECT id, name, email FROM users WHERE id > 5
>> {"id":6, "name":"user6", "email":"user6@gmail.com"}
```
```nim
import allographer/query_builder

let resultRow = RDB().table("users").find(3)
echo resultRow

>> SELECT * FROM users WHERE id = 3
>> {
    "id":3,
    "name":"user3",
    "email":"user3@gmail.com",
    "address":"246 Ferguson Village Apt. 582\nNew Joshua, IL 24200", "password":"$2a$10$gmKpgtO535lkw0eAcGiRyefdEg6TXr9S.z6vhsn4X.mBYtP0Thfny",
    "salt":"$2a$10$gmKpgtO535lkw0eAcGiRye",
    "birth_date":"2012-11-24",
    "auth":2,
    "created_at":"2019-09-26 19:11:28.159367",
    "updated_at":"2019-09-26 19:11:28.159369"
  }
```

If column name of primary key is not exactory "id", you can specify it's name.
```nim
import allographer/query_builder

let resultRow = RDB().table("users").find(3, key="user_id")
echo resultRow

>> SELECT * FROM users WHERE user_id = 3
>> {
    "user_id":3,
    "name":"user3",
    "email":"user3@gmail.com",
    "address":"246 Ferguson Village Apt. 582\nNew Joshua, IL 24200", "password":"$2a$10$gmKpgtO535lkw0eAcGiRyefdEg6TXr9S.z6vhsn4X.mBYtP0Thfny",
    "salt":"$2a$10$gmKpgtO535lkw0eAcGiRye",
    "birth_date":"2012-11-24",
    "auth":2,
    "created_at":"2019-09-26 19:11:28.159367",
    "updated_at":"2019-09-26 19:11:28.159369"
  }
```


```nim
import allographer/query_builder

let result = RDB()
            .table("users")
            .select("id", "email", "name")
            .where("id", ">", 4)
            .where("id", "<=", 10)
            .get()
echo result

>> SELECT id, email, name FROM users WHERE id > 4 AND id <= 10
>> @[
    {"id":5, "email":"user5@gmail.com", "name":"user5"},
    {"id":6, "email":"user6@gmail.com", "name":"user6"},
    {"id":7, "email":"user7@gmail.com", "name":"user7"},
    {"id":8, "email":"user8@gmail.com", "name":"user8"},
    {"id":9, "email":"user9@gmail.com", "name":"user9"},
    {"id":10, "email":"user10@gmail.com", "name":"user10"}
]
```
```nim
import allographer/query_builder

let result = RDB()
            .table("users")
            .select("users.name", "users.auth_id")
            .join("auth", "auth.id", "=", "users.auth_id")
            .where("users.auth_id", "=", 1)
            .where("users.id", "<", 5)
            .get()
echo result

>> SELECT users.name, users.auth_id FROM users JOIN auth ON auth.id = users.auth_id WHERE users.auth_id = 1 AND users.id < 5
>> @[
  {"name":"user2","auth_id":1},
  {"name":"user4","auth_id":1}
]
```

### INSERT
[to index](#index)

```nim
import allographer/query_builder

RDB()
.table("users")
.insert(%*{
  "name": "John",
  "email": "John@gmail.com"
})
.exec()

>> INSERT INTO users (name, email) VALUES ("John", "John@gmail.com")
```
```nim
import allographer/query_builder

echo RDB()
.table("users")
.insert(%*{
  "name": "John",
  "email": "John@gmail.com"
})
.execID()

>> INSERT INTO users (name, email) VALUES ("John", "John@gmail.com")
>> 1 # ID of new row is return
```
```nim
import allographer/query_builder

RDB().table("users").insert(
  [
    %*{"name": "John", "email": "John@gmail.com", "address": "London"},
    %*{"name": "Paul", "email": "Paul@gmail.com", "address": "London"},
    %*{"name": "George", "email": "George@gmail.com", "address": "London"},
  ]
)
.exec()

>> INSERT INTO users (name, email, address) VALUES ("John", "John@gmail.com", "London"), ("Paul", "Paul@gmail.com", "London"), ("George", "George@gmail.com", "London")
```
```nim
import allographer/query_builder

RDB().table("users").inserts(
  [
    %*{"name": "John", "email": "John@gmail.com", "address": "London"},
    %*{"name": "Paul", "email": "Paul@gmail.com", "address": "London"},
    %*{"name": "George", "birth_date": "1943-02-25", "address": "London"},
  ]
)
.exec()

>> INSERT INTO users (name, email, address) VALUES ("John", "John@gmail.com", "London")
>> INSERT INTO users (name, email, address) VALUES ("Paul", "Paul@gmail.com", "London")
>> INSERT INTO users (name, birth_date, address) VALUES ("George", "1960-1-1", "London")
```

### UPDATE
[to index](#index)

```nim
import allographer/query_builder

RDB()
.table("users")
.where("id", "=", 100)
.update(%*{"name": "Mick", "address": "NY"})
.exec()

>> UPDATE users SET name = "Mick", address = "NY" WHERE id = 100
```

### DELETE
[to index](#index)

```nim
import allographer/query_builder

RDB()
.table("users")
.delete(1)
.exec()

>> DELETE FROM users WHERE id = 1
```

If column name of primary key is not exactory "id", you can specify it's name.

```nim
import allographer/query_builder

RDB()
.table("users")
.delete(1, key="user_id")
.exec()

>> DELETE FROM users WHERE user_id = 1
```

```nim
import allographer/query_builder

RDB()
.table("users")
.where("address", "=", "London")
.delete()
.exec()

>> DELETE FROM users WHERE address = "London"
```


### Raw_SQL
[to index](#INDEX)

```nim
import allographer/query_builder

let sql = """
SELECT ProductName
  FROM Product 
 WHERE Id IN (SELECT ProductId 
                FROM OrderItem
               WHERE Quantity > 100)
"""
echo RDB().raw(sql).getRaw()
```
```nim
let sql = "UPDATE users SET name='John' where id = 1"
RDB().raw(sql).exec()
```