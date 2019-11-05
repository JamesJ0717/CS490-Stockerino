class Stock {
    symbol = '';
    exchange = '';
    name = '';
    date = '';
    type = '';
    iexId = '';
    region = '';
    currency = '';
    isEnabled = '';

    constructor(
        symbol,
        exchange,
        name,
        date,
        type,
        iexId,
        region,
        currency,
        isEnabled
    ) {
        this.symbol = symbol;
        this.exchange = exchange;
        this.name = name;
        this.date = date;
        this.type = type;
        this.iexId = iexId;
        this.region = region;
        this.currency = currency;
        this.isEnabled = isEnabled;
    }
}

module.exports = Stock;
