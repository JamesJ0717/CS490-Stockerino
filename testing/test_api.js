var axios = require('axios');

var options1 = {
    method: 'GET',
    url:
        'https://cloud.iexapis.com/stable/ref-data/symbols/' +
        '?token=' +
        'pk_15392fe3de7e4253a1a4941d76535000'
};

axios
    .request(options1)
    .then(res => {
        // console.log(res.data);
        // var jsonifiedBody = res;
        var stock;
        res.data.map(company => {
            if (company.name.includes('Twitter')) {
                stock = company.symbol;
                // console.log(company);
            }
        });
        var options2 = {
            method: 'GET',
            url:
                'https://cloud.iexapis.com/stable/stock/market/' +
                '/batch?token=' +
                'pk_15392fe3de7e4253a1a4941d76535000&types=quote&symbols=' +
                'TWTR,FB,AAPL'
        };

        axios
            .request(options2)
            .then(res => {
                console.log(res.data);
            })
            .catch(error => {
                throw new Error(error);
            });
    })
    .catch(error => {
        throw new Error(error);
    });
