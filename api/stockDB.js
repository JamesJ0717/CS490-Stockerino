'use strict';
const sqlite3 = require('sqlite3').verbose();

class DB {
    constructor(file) {
        this.db = new sqlite3.Database(file);
        this.createTable();
    }

    createTable() {
        const sql = `CREATE TABLE IF NOT EXISTS stocks (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            symbol TEXT, 
            companyName TEXT);
            `;
        return this.db.run(sql, err => {
            if (err) console.error(err);
        });
    }

    getStocks(callback) {
        return this.db.all('SELECT * FROM stocks', (err, rows) => {
            callback(err, rows);
        });
    }

    removeAll() {
        const removeSql = `
        DELETE FROM stocks;`;
        const updateSeq = `
        UPDATE sqlite_sequence SET seq = '0' WHERE rowid = 1;
        `;
        this.db.run(updateSeq);
        return this.db.run(removeSql);
    }

    addSymbols(stocks, callback) {
        const addSql = `INSERT INTO stocks(
            symbol, 
            companyName) VALUES (?, ?);`;

        for (let i = 0; i < stocks.length; i++) {
            // console.log(stocks);
            this.db.run(addSql, [stocks[i].symbol, stocks[i].name]);
        }
        return this.db.run('SELECT * FROM stocks', (err, rows) => {
            callback(err, rows);
        });
    }

    findStock(fragment, callback) {
        const sql = `SELECT * FROM stocks WHERE companyName LIKE '%`;
        return this.db.all(sql + fragment + `%'`, (err, rows) => {
            callback(err, rows);
        });
    }
}
module.exports = DB;
