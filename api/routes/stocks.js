const express = require('express');
const DB = require('../stockDB');
const db = new DB('stocks');
const fs = require('fs');
const axios = require('axios');

const Stock = require('../models/stock');
const router = express.Router();

router.get('/', (req, res) => {
    console.log('GET to /stocks');

    db.getStocks((err, row) => {
        if (err) console.error(err);
        res.status(200).json({
            stocks: row,
            status: 200
        });
    });
});

router.get('/search', (req, res) => {
    console.log('GET to /stocks/search/');
    console.log(req.query.fragment);
    db.findStock(req.query.fragment, (err, rows) => {
        if (err) console.error(err);
        console.log(req.query, rows.length);
        res.json({ stocks: rows }).status(200);
    });
});

router.post('/', (req, resp) => {
    console.log('POST to /stocks');
    var stocks = [Stock];
    axios.default
        .get(
            'https://cloud.iexapis.com/stable/ref-data/symbols?token=' +
                'pk_15392fe3de7e4253a1a4941d76535000'
        )
        .then(res => {
            for (let i = 0; i < res.data.length; i++) {
                var stock = new Stock(
                    res.data[i].symbol,
                    res.data[i].exchange,
                    res.data[i].name,
                    res.data[i].date,
                    res.data[i].type,
                    res.data[i].iexId,
                    res.data[i].region,
                    res.data[i].currency,
                    res.data[i].isEnabled
                );
                // console.log(stock);
                stocks.push(stock);
            }
            db.addSymbols(stocks, (err, rows) => {
                resp.status(200).json({ stocks: rows });
            });
        });
});

router.delete('/', (req, res) => {
    console.log('DELETE to /stocks');
    db.removeAll();
    res.json({}).status(200);
});

module.exports = router;
