
function renderChartsData(data) {

//KPI bar
    $('#avg_mood').html(data["feeling"]);
    $('#avg_energy').html(data["energy"]);
    $('#avg_activity').html(data["activity"]);
    $('#avg_panic_attack').html(data["panic_attack"]);

//Users by Race Table
    $('#avg_mood_race_table').html(data["feeling"]);
    $('#avg_energy_race_table').html(data["energy"]);

//Users by Age Table
    $('#avg_mood_age_table').html(data["feeling"]);
    $('#avg_energy_age_table').html(data["energy"]);

//Gender Chart
    charts = data["charts"];
    if($('#genderChart').length > 0) {
        genderChart.series[0].setData(charts["feelings"]["male"]);
        genderChart.series[1].setData(charts["feelings"]["female"]);
    }
//Race Chart
    if($('#raceChart').length > 0) {
        raceChart.series[0].setData(charts["feelings"]["white"]);
        raceChart.series[1].setData(charts["feelings"]["black"]);
        raceChart.series[2].setData(charts["feelings"]["asian"]);
        raceChart.series[3].setData(charts["feelings"]["hispanic"]);
    }
    //Genger Hospitalization Chart
    if($('#genderHospitalizationChart').length > 0) {
        genderHospitalizationChart.series[0].setData(charts["hospitalizations"]["male"]);
        genderHospitalizationChart.series[1].setData(charts["hospitalizations"]["female"]);
    }

    //Genger Hospitalization Chart
    if($('#memberDiagnosisPieChart').length > 0) {
        memberDiagnosisPieChart.series[0].setData(charts["hospitalizations"]["male"]);
    }

    //Genger Work Life Chart
    if($('#genderWorkLifeChart').length > 0) {
        genderWorkLifeChart.series[0].setData(charts["work_life"]["male"]);
        genderWorkLifeChart.series[1].setData(charts["work_life"]["female"]);
        genderWorkLifeChart.series[2].setData(charts["social_life"]["male"]);
        genderWorkLifeChart.series[3].setData(charts["social_life"]["female"]);
        genderWorkLifeChart.series[4].setData(charts["family_life"]["male"]);
        genderWorkLifeChart.series[5].setData(charts["family_life"]["female"]);
    }
}



function setupGenderChart() {

    genderChart = new Highcharts.Chart({
        chart: {
            defaultSeriesType: 'line',
            borderWidth: 0,
            borderRadius: 0,
            renderTo: 'genderChart'
        },

        legend: {
            layout: 'horizontal',
            align: 'center',
            verticalAlign: 'bottom',
            borderWidth: 0
        },
        credits: {
            enabled: false
        },
        title: {
            text: ''
        },

        xAxis: {
            gridLineWidth: 1,
            lineColor: '#000',
            tickColor: '#000',
            type: 'datetime'
            //maxZoom: 30 * 24 * 3600000 // fourteen days
        },

        series: [{
            name: 'Male',
            color: 'blue'
        }, {
            name: 'Female',
            color: 'red'
        }],

        yAxis: {
            min: 0, max: 6,
            lineColor: '#000',
            minTickInterval: 1,
            //tickInterval: 1,
            lineWidth: 1,
            tickWidth: 1,
            tickColor: '#000',
            title: {
                text: 'AVG MOOD'
            }
        }
    });
}

function setupRaceChart() {
    raceChart = new Highcharts.Chart({

        chart: {
            defaultSeriesType: 'line',
            borderWidth: 0,
            borderRadius: 0,
            renderTo: 'raceChart'
        },

        legend: {
            layout: 'horizontal',
            align: 'center',
            verticalAlign: 'bottom',
            borderWidth: 0
        },
        credits: {
            enabled: false
        },
        title: {
            text: ''
        },

        xAxis: {
            gridLineWidth: 1,
            lineColor: '#000',
            tickColor: '#000',
            type: 'datetime'
            //maxZoom: 30 * 24 * 3600000 // fourteen days
        },

        series: [{

            name: 'Caucasian'
        }, {
            name: 'African American'
        }, {
            name: 'Hispanic'
        }, {
            name: 'Asian'
        }],

        yAxis: {
            min: 0, max: 6,
            lineColor: '#000',
            minTickInterval: 1,
            //tickInterval: 1,
            lineWidth: 1,
            tickWidth: 1,
            tickColor: '#000',
            title: {
                text: 'AVG MOOD'
            }
        }
    });
}

function setupGenderHospitalizationChart() {
    genderHospitalizationChart = new Highcharts.Chart({
        chart: {
            defaultSeriesType: 'column',
            borderWidth: 0,
            borderRadius: 10,
            renderTo: 'genderHospitalizationChart'
        },

        legend: {
            layout: 'horizontal',
            align: 'center',
            verticalAlign: 'bottom',
            borderWidth: 0
        },
        credits: {
            enabled: false
        },
        title: {
            text: ''
        },

        xAxis: {
            type: 'datetime'
            //maxZoom: 30 * 24 * 3600000 // fourteen days
        },

        series: [{
            name: 'Male',
            color: 'blue'
        }, {
            name: 'Female',
            color: 'red'
        }],

        yAxis: {
            min: 0,
            lineColor: '#000',
            minTickInterval: 1,
            //tickInterval: 1,
            lineWidth: 1,
            tickWidth: 1,
            tickColor: '#000',
            title: {
                text: '# of Hospitalizations'
            }
        },
        stackLabels: {
            enabled: true,
            style: {
                fontWeight: 'bold',
                color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
            }
        },
        plotOptions: {
            column: {
                stacking: 'normal',
                dataLabels: {
                    enabled: true,
                    color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
                    style: {
                        textShadow: '0 0 3px black'
                    }
                }
            }
        }
    });
}

function setupMemberDiagnosisPieChart() {
    memberDiagnosisPieChart = new Highcharts.Chart({
        chart: {
            plotShadow: false,
            type: 'pie',
            borderRadius: 10,
            backgroundColor: '#fdfcfc',
            renderTo: 'memberDiagnosisPieChart'
        },
        credits: {
            enabled: false
        },

        title: {
            text: 'Members by Diagnosis'
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: true
                },
                showInLegend: false
            }
        }
    });
}


function setupGenderWorkLifeChart() {

    genderWorkLifeChart = new Highcharts.Chart({
        chart: {
            defaultSeriesType: 'line',
            borderWidth: 0,
            borderRadius: 0,
            renderTo: 'genderWorkLifeChart'
        },

        legend: {
            layout: 'horizontal',
            align: 'center',
            verticalAlign: 'bottom',
            borderWidth: 0
        },
        credits: {
            enabled: false
        },
        title: {
            text: ''
        },

        xAxis: {
            gridLineWidth: 1,
            lineColor: '#000',
            tickColor: '#000',
            type: 'datetime'
            //maxZoom: 30 * 24 * 3600000 // fourteen days
        },

        series: [{
            name: 'Male - Work Life',
            color: 'blue'
        }, {
            name: 'Female - Work Life',
            color: 'red'
        },{
            name: 'Male - Social Life',
            color: 'blue'
        },{
            name: 'Female - Social Life',
            color: 'red'
        },{
            name: 'Male - Home Life',
            color: 'blue'
        },{
            name: 'Female - Home Life',
            color: 'red'
        }
        ],

        yAxis: {
            min: 0, max: 10,
            lineColor: '#000',
            minTickInterval: 1,
            //tickInterval: 1,
            lineWidth: 1,
            tickWidth: 1,
            tickColor: '#000',
            title: {
                text: 'Work Life'
            }
        }
    });
}

