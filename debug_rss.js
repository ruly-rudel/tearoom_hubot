// feedparser - https://www.npmjs.org/package/feedparser
var FeedParser = require('feedparser')
    , request = require('request');



var req = request('http://pipes.yahoo.com/pipes/pipe.run?_id=9b7aa2d04b98b9271c06e9c0599b5aac&_render=rss')
    , feedparser = new FeedParser(); // new FeedParser([options])でoptions設定

req.on('error', function (error) {
    // リクエストエラー処理
});
req.on('response', function (res) {
    var stream = this;
    if (res.statusCode != 200) {
        return this.emit('error', new Error('Bad status code'));
    }
    stream.pipe(feedparser);
});

feedparser.on('error', function(error) {
    // 通常のエラー処理
});

feedparser.on('readable', function() {
    var stream = this
        , meta = this.meta
        , item;
    while (item = stream.read()) {
        // タイトルとリンクを取得
        console.log(item)
                // console.log(item.title + "\t" + item.link);
    }
});








