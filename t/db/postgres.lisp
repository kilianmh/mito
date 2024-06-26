(defpackage #:mito-test.db.postgres
  (:use #:cl
        #:dbi
        #:rove
        #:mito-test.util
        #:mito-test.db.main))
(in-package #:mito-test.db.postgres)

(defvar *conn* nil)

(setup
 (setf *conn* (connect-to-testdb :postgres))

 (dbi:do-sql *conn* "DROP TABLE IF EXISTS tweets")
 (dbi:do-sql *conn*
   "CREATE TABLE tweets (
    id SERIAL PRIMARY KEY,
    status TEXT NOT NULL,
    \"user\" VARCHAR(64) NOT NULL,
    UNIQUE (id, \"user\")
)")

 (dbi:do-sql *conn* "DROP TABLE IF EXISTS users")
 (dbi:do-sql *conn*
   "CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(64) NOT NULL,
    family_name VARCHAR(64) NOT NULL,
    UNIQUE(first_name, family_name)
)"))

(deftest postgres-tests
  (run-db-tests *conn*))

(teardown
 (disconnect-from-testdb *conn*))
