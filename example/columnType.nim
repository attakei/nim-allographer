import json

import ../src/allographer/query_builder
import ../src/allographer/schema_builder

echo repr RDB().table("users").select("id", "name", "address")
    .limit(2)
    .get()

echo RDB().table("users").select("id", "name", "address").first()

echo RDB().table("users")
    .select("id", "name", "address")
    .find(3)

# schema([
#   table("sample", [
#     Column().increments("id"),
#     Column().float("float"),
#     Column().string("string"),
#     Column().datetime("datetime"),
#     Column().string("'null'").nullable(),
#     Column().boolean("is_admin")
#   ], reset=true)
# ])

# RDB().table("sample").insert(%*{
#   "id": 1,
#   "float": 3.14,
#   "string": "string",
#   "datetime": "2019-01-01 12:00:00.1234",
#   "is_admin": true
# }).exec()

echo RDB().table("sample")
  .select("id", "float", "string", "datetime", "null", "is_admin")
  .get()

echo RDB().table("sample")
  .select("id", "float", "string", "datetime", "null", "is_admin")
  .get()


var sql = "update users set name='John' where id = 1"
RDB().raw(sql).exec()

sql = "select * from users where id = 1"
echo RDB().raw(sql).getRaw()
