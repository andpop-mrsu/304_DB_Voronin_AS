#!/usr/bin/env python3
import csv
import re
import os

def escape_sql(value):
    if value is None:
        return "NULL"
    return "'" + str(value).replace("'", "''") + "'"

def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(script_dir)

    sql = []
    sql.append("DROP TABLE IF EXISTS movies;")
    sql.append("DROP TABLE IF EXISTS ratings;")
    sql.append("DROP TABLE IF EXISTS tags;")
    sql.append("DROP TABLE IF EXISTS users;")
    sql.append("")

    # movies
    sql.append("""CREATE TABLE movies (id INTEGER PRIMARY KEY, title TEXT, year INTEGER, genres TEXT);""")
    sql.append("")

    with open("movies.csv", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            movie_id = row["movieId"]
            title_full = row["title"]
            genres = row["genres"]
        
            year_match = re.search(r"\((\d{4})\)\s*$", title_full)
            if year_match:
                year = year_match.group(1)
                title = title_full[:year_match.start()].strip()
            else:
                year = "NULL"
                title = title_full

            sql.append(
                f"INSERT INTO movies (id, title, year, genres) VALUES "
                f"({movie_id}, {escape_sql(title)}, {year}, {escape_sql(genres)});"
            )

    sql.append("")

    # ratings
    sql.append("""CREATE TABLE ratings (id INTEGER PRIMARY KEY, user_id INTEGER, movie_id INTEGER, rating REAL, timestamp INTEGER);""")
    sql.append("")

    with open("ratings.csv", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for i, row in enumerate(reader, start=1):
            sql.append(
                f"INSERT INTO ratings (id, user_id, movie_id, rating, timestamp) VALUES "
                f"({i}, {row['userId']}, {row['movieId']}, {row['rating']}, {row['timestamp']});"
            )

    sql.append("")

    # tags
    sql.append("""CREATE TABLE tags (id INTEGER PRIMARY KEY, user_id INTEGER, movie_id INTEGER, tag TEXT, timestamp INTEGER);""")
    sql.append("")

    with open("tags.csv", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for i, row in enumerate(reader, start=1):
            sql.append(
                f"INSERT INTO tags (id, user_id, movie_id, tag, timestamp) VALUES "
                f"({i}, {row['userId']}, {row['movieId']}, {escape_sql(row['tag'])}, {row['timestamp']});"
            )

    sql.append("")

    # users
    sql.append("""CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, email TEXT, gender TEXT, register_date TEXT, occupation TEXT);""")
    sql.append("")

    with open("users.txt", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            parts = line.split("|")

            user_id, name, email, gender, reg_date, occupation = parts
            sql.append(
                f"INSERT INTO users (id, name, email, gender, register_date, occupation) VALUES "
                f"({user_id}, {escape_sql(name)}, {escape_sql(email)}, "
                f"{escape_sql(gender)}, {escape_sql(reg_date)}, {escape_sql(occupation)});"
            )

    with open("db_init.sql", "w", encoding="utf-8") as f:
        f.write("\n".join(sql))

if __name__ == "__main__":
    main()