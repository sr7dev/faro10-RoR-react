$(function() {
    if ($('#observeeConsistencyChart').length > 0) {
        getSeriesData();
    }
});

function getSeriesData() {
    $.ajax({
        dataType: "json",
        url: "/users/observations",
        data: {},
        success: setupObserveeConsistencyChart
    });
}

function getObserveeConsistencyData() {
    $.ajax({
        dataType: "json",
        url: "/users/observee_consistency_data",
        data: {},
        success: renderObserveeConsistencyData
    });
}

function renderObserveeConsistencyData(data) {
    for (var i = 0; i < data.observees.length; i++) {
        meds_taken = data.observees[i].meds_taken;
        observeeConsistencyChart.series[i].setData(meds_taken);
    }
}

function setupObserveeConsistencyChart(data) {
    observeeConsistencyChart = new Highcharts.Chart({
        chart: {
            type: 'column',
            borderWidth: 0,
            borderRadius: 0,
            renderTo: 'observeeConsistencyChart'
        },
        title: {
            text: ''
        },
        //subtitle: {
        //    text: 'based on your input using mobile app'
        //},
        credits: {
            enabled: false
        },
        xAxis: {
            gridLineWidth: 1,
            lineColor: '#000',
            tickColor: '#000',
            type: 'datetime',
            //maxZoom: 30 * 24 * 3600000 // fourteen days

            crosshair: true
        },
        yAxis: {
            min: 0,
            lineColor: '#000',
            minTickInterval: 1,
            tickInterval: 1,
            lineWidth: 1,
            tickWidth: 1,
            tickColor: '#000',
            title: {
                text: 'Doses Taken per Day'
            }
        },
        tooltip: {
            headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
            pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
            '<td style="padding:0"><b>{point.y:.1f}</b></td></tr>',
            footerFormat: '</table>',
            shared: true,
            useHTML: true
        },
        plotOptions: {
            column: {
                pointPadding: 0.2,
                borderWidth: 0
            }
        },
        series: data.users
    });

    getObserveeConsistencyData();
}

$(function() {
    id = $('#observee_appointment_select').val();
    // $('#make_appointment_link').attr('href','/schedules/' + id );
    $('#observee_appointment_select').change(function() {
        console.log($(this).val());
        path = "/schedules?observee_id=" + $(this).val();
        // $('#make_appointment_link').attr('href','/schedules/' + this.val());
        window.location.replace(path)
    });
});
