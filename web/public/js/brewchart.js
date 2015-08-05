$(pageReady);

function pageReady() {
    $.getJSON("/charts/json/" + BREW.chartDate, buildSeries);
}

function buildSeries(data) {

    var seriesMap = {};
    if (data.length > 0) {
        _.each(_.keys(data[0].temperatures), function (name) {
            seriesMap[name] = {"name": name,
                "data": [], type: 'coloredline'};
        });
    }

    var categories = [];
    var count = 0;
    _.each(data, function (item) {
        var date = new Date(getDateFromFormat(item.time.split(' +')[0], "y-m-d HH:mm:ss"));
        _.each(_.keys(item.temperatures), function (name) {
            if (item.heating){
                colour = "red";
            }else{
                colour = "blue"
            }
           // if (count < 3000){
            seriesMap[name].data.push({x: date, y: item.temperatures[name], segmentColor: colour});
           // }
            count++;
        });
        //categories.push(date);
    })

    var series = [];
    _.each(_.keys(seriesMap), function (name) {
       series.push(seriesMap[name]);
    });

    buildChart(series, categories);
}

function buildChart(series, categories) {
    $('#brew_chart').highcharts({
        title: {
            text: 'Fermentation Temperature',
            x: -20 //center
        },
        xAxis: {
            type: 'datetime'
           // categories: categories
        },
        yAxis: {
            title: {
                text: 'Temperature (°C)'
            },
            plotLines: [
                {
                    value: 0,
                    width: 1,
                    color: '#808080'
                }
            ]
        },
        tooltip: {
            valueSuffix: '°C'
        },
        plotOptions: {
            series: {
                turboThreshold: 10000
            }
        },
        series: series
    });
}