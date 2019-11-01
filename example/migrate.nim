import strformat, json, progress
import bcrypt
import ../src/allographer/QueryBuilder
import ../src/allographer/SchemaBuilder
# import allographer/QueryBuilder
# import allographer/SchemaBuilder


# マイグレーション
Schema().create([
  Table().create("auth",[
    Column().increments("id"),
    Column().string("auth")
  ], isRebuild=true),
  Table().create("users",[
    Column().increments("id"),
    Column().string("name").nullable(),
    Column().string("email").nullable(),
    Column().string("password").nullable(),
    Column().string("salt").nullable(),
    Column().string("address").nullable(),
    Column().date("birth_date").nullable(),
    Column().foreign("auth_id").reference("id").on("auth").onDelete(SET_NULL)
  ], isRebuild=true)
])

# シーダー
RDB().table("auth").insert([
  %*{"auth": "admin"},
  %*{"auth": "user"}
])
.exec()

# プログレスバー
let total = 100
var pb = newProgressBar(total=total) # totalは分母

pb.start()
var insertData: seq[JsonNode]
for i in 1..total:
  let salt = genSalt(10)
  let password = hash(&"password{i}", salt)
  let authId = if i mod 2 == 0: 1 else: 2
  insertData.add(
    %*{
      "name": &"user{i}",
      "email": &"user{i}@gmail.com",
      "password": password,
      "salt": salt,
      "auth_id": authId
    }
  )
  pb.increment()

pb.finish()
RDB().table("users").insert(insertData).exec()