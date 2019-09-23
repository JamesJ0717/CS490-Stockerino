# CS490-StockTicker
My CS490 project using Dart and Flutter for cross platform building.

## What it does

The purpose of this app is to keep track of stocks that you choose. I am going to be leveraging the Investors Exchange (IEX) Trading API. This allows me to get a bunch of information about the stock market, as well as information regarding individual stocks.

## API

I am going to be using Investors Exchange (IEX) Trading API. This API is pretty simple in that there are not many endpoints, but they are very detailed in what they give you. For instance, `.../stock/aapl/book` returns information about the quote, bids, asks, trades, and system events.

Also, this API seems to be faster than Yahoo!'s API, which is nice, but hardly noticeable.

## Design

I am planning on using a GridView layout, probably 2 cards wide, with your favorite stocks on top. I think I am going to try to implement a dark mode and a light mode, just for fun. 