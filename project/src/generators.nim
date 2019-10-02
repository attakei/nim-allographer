import json
from strformat import `&`
from strutils import contains

import base

## ==================== SELECT ====================

proc selectSql*(this: RDB): RDB =
  var queryString = ""

  queryString.add("SELECT")

  if this.query.hasKey("select"):
    for i, item in this.query["select"].getElems():
      if i > 0:
        queryString.add(",")

      queryString.add(&" {item.getStr()}")
  else:
    queryString.add(" *")

  this.sqlString = queryString
  return this


proc fromSql*(this: RDB): RDB =
  let table = this.query["table"].getStr()
  this.sqlString.add(&" FROM {table}")
  return this


proc joinSql*(this: RDB): RDB =
  if this.query.hasKey("join"):
    for row in this.query["join"]:
      var table = row["table"].getStr()
      var column1 = row["column1"].getStr()
      var symbol = row["symbol"].getStr()
      var column2 = row["column2"].getStr()

      this.sqlString.add(&" JOIN {table} ON {column1} {symbol} {column2}")

  return this


proc whereSql*(this: RDB): RDB =
  if this.query.hasKey("where"):
    for i, row in this.query["where"].getElems():
      var column = row["column"].getStr()
      var symbol = row["symbol"].getStr()
      var value = row["value"]
      
      if i == 0:
        this.sqlString.add(&" WHERE {column} {symbol} {value}")
      else:
        this.sqlString.add(&" AND {column} {symbol} {value}")

  return this


proc orWhereSql*(this: RDB): RDB =
  if this.query.hasKey("or_where"):
    for row in this.query["or_where"]:
      var column = row["column"].getStr()
      var symbol = row["symbol"].getStr()
      var value = row["value"]
      
      if this.sqlString.contains("WHERE"):
        this.sqlString.add(&" OR {column} {symbol} {value}")
      else:
        this.sqlString.add(&" WHERE {column} {symbol} {value}")

  return this


proc limitSql*(this: RDB): RDB =
  if this.query.hasKey("limit"):
    var num = this.query["limit"].getInt()
    this.sqlString.add(&" LIMIT {num}")

  return this


proc offsetSql*(this: RDB): RDB =
  if this.query.hasKey("offset"):
    var num = this.query["offset"].getInt()
    this.sqlString.add(&" OFFSET {num}")

  return this