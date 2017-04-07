var fs = require('fs');
var convertFactory = require('electron-html-to');

var my_url = process.argv[2];
var pdffile = process.argv[3];
console.log("converting " + my_url + " to " + pdffile);
console.log(process.cwd());

var conversion = convertFactory({
    converterPath: convertFactory.converters.PDF,
    allowLocalFilesAccess: true,
});

conversion({ // html: "",
    // url: "http://0.0.0.0:8080/movie-shift-calstop-PANAS-X-2.html",
    // url: "http://0.0.0.0:8080/movie-shift-calstop-liu-lexicon.html",
    // url: "http://hedonometer.org",
    url: my_url,
    waitForJS: false,
    delay: 3000,
    // options for electron's browser window, see http://electron.atom.io/docs/v0.35.0/api/browser-window/ for details for each option.
    // allowed browser-window options
    browserWindow: {
        width: 1800, // defaults to 600
        height: 1200, // defaults to 600
        x: 0,
        y: 0,
        useContentSize: false, 
        webPreferences: {
            nodeIntegration: false, // defaults to false
            partition: '',
            zoomFactor: 1.0,
            javascript: true, // defaults to true
            webSecurity: false, // defaults to false
            allowDisplayingInsecureContent: true,
            allowRunningInsecureContent: true,
            images: true,
            java: true,
            webgl: true,
            webaudio: true,
        }
    },
    // options to the pdf converter function, see electron's printoToPDF function http://electron.atom.io/docs/v0.35.0/api/web-contents/#webcontents-printtopdf-options-callback for details for each option.
    // allowed printToPDF options
    pdf: {
        marginsType: 0,
        pageSize: 'A1',
        printBackground: false,
        landscape: true,
    },
}, function(err, result) {
    console.log("converted the data?");
    if (err) {
        return console.error(err);
    }
    console.log(result.numberOfPages);
    result.stream.pipe(fs.createWriteStream(pdffile));
    conversion.kill(); // necessary if you use the electron-server strategy, see bellow for details 
});




