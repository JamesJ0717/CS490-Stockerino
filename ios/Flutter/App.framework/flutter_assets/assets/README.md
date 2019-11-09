# CS490-Stockerino

Stockerino is an app I started building for my CS490 class. The class was called _Cross Platform Mobile Development with Dart and Flutter_. In this class, we were tasked with building an app using Dart and Flutter. My original idea was super complex; I wanted to make an app that would allow students to better keep track of assignments and exams, something along the lines of a day planner, but in app form and aimed towards students. After I was working on this idea for a few days, I realized there are a lot of complex things I did not think of originally. When my teacher talked about some of the apps made in the past, I noticed how simple they seemed. Thats when I decided on making a stock ticker, as I can make it as simple or as complex as I feel.

## What does it do

The purpose of this app is to keep track of stocks that you choose. I am going to be leveraging the Investors Exchange (IEX) Trading API. This allows me to get a bunch of information about the stock market, as well as information regarding individual stocks.

For the later iterations of the app, I hope to implement a way to keep track of cryptocurrencies as well as _normal_ stocks.

## API

I am going to be using Investors Exchange (IEX) Trading API. This API is pretty simple in that there are not many endpoints, but they are very detailed in what they give you. For instance, `.../stock/aapl/book` returns information about the quote, bids, asks, trades, and system events.

An example in JavaScript would look like this...

```javascript
fetch('https://cloud.iexapis.com/stable/stock/aapl/quote/?token=$token').then(
    response => {
        //store information somewhere
    }
);
```

Also, this API seems to be faster than Yahoo!'s API, which is nice, but hardly noticeable.

## Design

I am planning on using a GridView layout, I decided on using a 1 card wide column to allow for all the information needed to look the best. I currently have dark mode enabled, but I want to implement a way to be able to toggle dark/light modes.

## External Packages

I like to do as much as I can without relying on external packages. Unfortunately, it gets hard to do everything myself when I want to do more and more complex things. The first package I needed to use was `http`. I think this package should be included in the main dart package, but that's neither here nor there. I needed `http` since I was calling an API. The next thing I wanted was the ability to refresh on pull down. This would have been very difficult to implement on my own and I didn't want to spend half the time figuring this out. Luckily, there is a package `pull_to_refresh` that does exactly what I needed.
