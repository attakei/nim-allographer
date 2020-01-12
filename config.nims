import os

# DB Connection
putEnv("db.driver", "sqlite")
putEnv("db.connection", "/home/www/db.sqlite3")
# putEnv("db.driver", "mysql")
# putEnv("db.connection", "mysql:3306")
# putEnv("db.driver", "postgres")
# putEnv("db.connection", "postgres:5432")
putEnv("db.user", "user")
putEnv("db.password", "Password!")
putEnv("db.database", "allographer")

# Logging
putEnv("log.isDisplay", "true")
putEnv("log.isFile", "false")
putEnv("log.dir", "/home/www/logs")
