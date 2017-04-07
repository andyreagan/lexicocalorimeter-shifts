var fs = require('fs'),
    convertFactory = require('electron-html-to');

var conversion = convertFactory({
    converterPath: convertFactory.converters.PDF
});

// conversion({ html: '<h1>Hello World</h1>' }, function(err, result) {
// conversion({ url: "http://hedonometer.org", }, function(err, result) {
// conversion({ url: "http://panometer.org/index.html", }, function(err, result) {
conversion({ url: "http://panometer.org/instruments/lexicocalorimeter/",
             delay: 3000,
             browserWindow: {
                 width: 1200, // defaults to 600
                 height: 800, // defaults to 600
             },
           },
           function(err, result) {
               if (err) {
                   return console.error(err);
               }

               console.log(result.numberOfPages);
               result.stream.pipe(fs.createWriteStream('example.pdf'));
               conversion.kill(); // necessary if you use the electron-server strategy, see bellow for details
           }
          );
