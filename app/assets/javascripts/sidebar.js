$(document).ready(function() {
    if ($('.sidebar').length > 0) { //Does the class sidebar exist on any element on the page
        setupSidebar();
        setupCharts();
        getNewData();
        //console.log("sidebar found!");
        $('.sidebar #datepicker [name="start_date"], .sidebar #datepicker [name="end_date"]').on('changeDate', getNewData);
        $('.sidebar [name="race"]').on('click', function() {
            $('.sidebar [name="race"]').removeClass('active');
            $('.sidebar [name="race"] a').removeClass('active');

            $(this).addClass('active'); //visual
            $(this).children().addClass('active'); //data

        });

        $('.sidebar [name="gender"]').on('click', function() {
            $('.sidebar [name="gender"]').removeClass('active');
            $('.sidebar [name="gender"] a').removeClass('active');

            $(this).addClass('active'); //visual
            $(this).children().addClass('active'); //data

        });

        $('.sidebar [name="age_group"]').on('click', function() {
            $('.sidebar [name="age_group"]').removeClass('active');
            $('.sidebar [name="age_group"] a').removeClass('active');

            $(this).addClass('active'); //visual
            $(this).children().addClass('active'); //data

        });

        $('.sidebar [name="diagnosis"]').on('click', function() {
            $('.sidebar [name="diagnosis"]').removeClass('active');
            $('.sidebar [name="diagnosis"] a').removeClass('active');

            $(this).addClass('active'); //visual
            $(this).children().addClass('active'); //data

        });


        $('.sidebar [name="prescription"]').on('click', function() {
            $('.sidebar [name="prescription"]').removeClass('active');
            $('.sidebar [name="prescription"] a').removeClass('active');

            $(this).addClass('active'); //visual
            $(this).children().addClass('active'); //data

        });

        //on click of age group
        //make active and other age groups inactive

        $('#apply_filters').on('click', getNewData);
    }
});

function setupSidebar() {
    currentPath = window.location.pathname;
    //console.log(currentPath);
    if(/^\/clinicians\/clinic_dashboard/.test(currentPath)) {
        //$('.sidebar #datepicker').remove();
        $('.sidebar [name="start_date"]').attr("value", "");
        $('.sidebar [name="end_date"]').attr("value", "");
    } else {
        console.log("Not changing sidebar due to path");
    }
}

function getNewData() {
    var successFunction;
    var type = "json";
    currentPath = window.location.pathname;
    console.log(currentPath);
    if(/^\/dashboard/.test(currentPath)) {
        successFunction = renderDashboardData;
    } else if(/^\/socials/.test(currentPath)) {
        successFunction = renderSocialsData;
    } else if(/^\/charts/.test(currentPath)) {
        successFunction = renderChartsData;
    } else if(/^\/patients\/\d+/.test(currentPath)) { // /patients/:id
        successFunction = renderPatientsData;
    } else if(/^\/clinicians\/\d+\/clinic_dashboard/.test(currentPath)) {
        successFunction = renderClinicData;
    } else if(/^\/patients/.test(currentPath)) {
        successFunction = renderPatientsList;
        type = "script";
    } else {
        console.log("Unknown page called from getNewData");
    }

    if(successFunction != undefined) {
        $.ajax({
            dataType: type,
            url: currentPath,
            data: {
                start_date: $("input[name='start_date']").val(),
                end_date: $("input[name='end_date']").val(),
                race: $(".active[name='race'] a").html(),
                gender: $(".active[name='gender'] a").html(),
                diagnosis: $(".active[name='diagnosis'] a").html(),
                age_start: $(".active[name='age_group'] a").attr('data-start'),
                age_end: $(".active[name='age_group'] a").attr('data-end'),
                prescription: $("#sel2").find(":selected").val()
            },
            success: successFunction
        });
    }
}

function renderPatientsList() {
    $('.dataTables_info, .dataTables_filter, .dataTables_paginate, .dataTables_length').remove();

    $('#patients').dataTable({
        "bPaginate":true,
        "sPaginationType":"ellipses",
        "iDisplayLength": 10,
        "responsive": true
    });
}
if($.fn.dataTableExt !== undefined) {
    $.extend( $.fn.dataTableExt.oStdClasses, {
        "sSortAsc": "header headerSortDown",
        "sSortDesc": "header headerSortUp",
        "sSortable": "header"
    } );
}


<!-- CHARTS -->
var moodChart;
var moodChartModal;
var moodChartPDF;
var observeeMoodChartModal;
var observeemadrsdimChart;
var observeesideffectsChart;
var MADRSChart;
var MADRSDimensionsChart;
var additionalMadrsDimensionsChart;
var symptomChart;
var genderChart;
var raceChart;
var genderHospitalizationChart;
var memberDiagnosisPieChart;
var PatientMoodChart;
var PatientMADRSScoreChart;
var patientMadrsDim;
var patientMadrsAddDim;
var patientSymptoms;
var patientCountChart;
var patientHospitalizationCountChart;
var clinicDiagnosisPie;
var clinicPiebyAgeChart;
var clinicbyMedsColumn;
var clinicHospitalizationsBarChart;
var genderWorkLifeChart;
var patientSheehanChart;
var patientSheehanZoomChart;
var memberSheehanChart;
var memberSheehanZoomChart;
var prescriptionConsistencyChart;
var patientPrescriptionConsistencyChart;
var patientMoodZoomChart;
var postings;

function setupCharts() {

    if ($('#moodChart').length > 0) {
        moodChart = new Highcharts.Chart({
            chart: {
                defaultSeriesType: 'spline',
                renderTo: 'moodChart',
                borderWidth: 0,
                borderRadius: 0,
                credits: 'false'
            },
            credits: {
                enabled: false
            },
            legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'bottom',
                borderWidth: 0
            },
            title: {
                text: ''
            },

            subtitle: {
                text: '',
                x: -20,
                style: {
                    color: '#fff'
                }
            },

            xAxis: {
                gridLineWidth: 1,
                lineColor: '#000',
                tickColor: '#000',
                type: 'datetime'
                //maxZoom: 30 * 24 * 3600000 // fourteen days


            },
            yAxis: {
                lineColor: '#000',
                min: 0, max: 6,
                tickInterval: 1,
                lineWidth: 1,
                tickWidth: 1,
                tickColor: '#000',
                title: {
                    text: 'Daily Avg Mood'
                }
            },

            series: [{
                //pointInterval: 86400000,
                name: 'My Mood'
            }
                // Commenting out to not show everyone else mood
                // , {
                //     //pointInterval: 86400000,
                //     name: 'Everyone Else'
                // }
            ],

            rangeSelector: {
                inputDateFormat: '%a %d %b %H:%M:%S'
            }

        });
    }

    // if ($('#socialsChart').length > 0) {
    //     socialsChart = new Highcharts.Chart({
    //         chart: {
    //             defaultSeriesType: 'line',
    //             renderTo: 'socialsChart',
    //             borderWidth: 0,
    //             borderRadius: 0,
    //             credits: 'false'
    //         },
    //         credits: {
    //             enabled: false
    //         },
    //         legend: {
    //             layout: 'horizontal',
    //             align: 'center',
    //             verticalAlign: 'bottom',
    //             borderWidth: 0
    //         },
    //         title: {
    //             text: ''
    //         },

    //         subtitle: {
    //             text: '',
    //             x: -20,
    //             style: {
    //                 color: '#fff'
    //             }
    //         },

    //         xAxis: {
    //             gridLineWidth: 1,
    //             lineColor: '#000',
    //             tickColor: '#000',
    //             type: 'datetime'
    //             //maxZoom: 30 * 24 * 3600000 // fourteen days


    //         },
    //         yAxis: {
    //             lineColor: '#000',
    //             min: 0, max: 6,
    //             tickInterval: 1,
    //             lineWidth: 1,
    //             tickWidth: 1,
    //             tickColor: '#000',
    //             title: {
    //                 text: 'Daily Avg Mood'
    //             }
    //         },

    //         series: [{
    //             //pointInterval: 86400000,
    //             color: '#FF0000',
    //             name: 'Me'
    //         }, {
    //             //pointInterval: 86400000,
    //             name: 'Everyone Else'
    //         }],

    //         rangeSelector: {
    //             inputDateFormat: '%a %d %b %H:%M:%S'
    //         }

    //     });
    // }

    if ($('#moodChartModal').length > 0) {
        moodChartModal = new Highcharts.Chart({
            chart: {
                defaultSeriesType: 'spline',
                renderTo: 'moodChartModal',
                borderWidth: 0,
                borderRadius: 0,
                borderColor: 'grey',
                credits: 'false'
            },
            credits: {
                enabled: false
            },

            legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'bottom',
                borderWidth: 0
            },
            title: {
                text: 'Mood Chart'
            },

            subtitle: {
                text: 'Trend of your Daily Avg Mood',
                style: {
                    color: 'black'
                }
            },

            xAxis: {
                gridLineWidth: 1,
                lineColor: '#000',
                tickColor: '#000',
                type: 'datetime',
                dateTimeLabelFormats: {
                    day: '%e of %b'
                }
                //maxZoom: 30 * 24 * 3600000 // fourteen days
            },
            yAxis: {
                lineColor: '#000',
                min: 0, max: 6,
                tickInterval: 1,
                lineWidth: 1,
                tickWidth: 1,
                tickColor: '#000',
                title: {
                    text: 'Severity of Mood'
                },
                plotBands: [{ // Occasional sadness in keeping with the circumstances
                    from: 0,
                    to: 1,
                    color: '#fff',
                    label: {
                        text: 'Occasional sadness in keeping with the circumstances',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Sad or low but brithtens up without difficulty
                    from: 1,
                    to: 2,
                    color: '#DFF0E7',
                    label: {
                        text: 'Sad or low but brightens up without difficulty',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Sad and lownes, with difficulty brightening up
                    from: 2,
                    to: 3,
                    color: '#fff',
                    label: {
                        text: 'Sad and lowness, with difficulty brightening up',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Pervasive feelings of sadness or gloominess. Mood influenced by external circumstances
                    from: 3,
                    to: 4,
                    color: '#DFF0E7',
                    label: {
                        text: 'Pervasive feelings of sadness or gloominess. Mood influenced by external circumstances',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Pervasive sadness originating internally and externally
                    from: 4,
                    to: 5,
                    color: '#fff',
                    label: {
                        text: 'Pervasive sadness originating internally and externally',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Continuous or unvarying sadness, misery or dispondency
                    from: 5,
                    to: 6,
                    color: '#DFF0E7',
                    label: {
                        text: 'Continuous or unvarying sadness, misery or dispondency',
                        style: {
                            color: '#606060'
                        }
                    }
                }]
            },
            plotOptions: {
                spline: {
                    dataLabels: {
                        enabled: false
                    },
                    lineWidth: 4,
                    states: {
                        hover: {
                            lineWidth: 5
                        }
                    },
                    marker: {
                        enabled: true
                    },
                    enableMouseTracking: true
                }
            },
            series: [{
                name: 'My Mood'
            }]
        });
    }

    if ($('#observeeMoodChartModal').length > 0) {
        observeeMoodChartModal = new Highcharts.Chart({
            chart: {
                defaultSeriesType: 'spline',
                renderTo: 'observeeMoodChartModal',
                borderWidth: 0,
                borderRadius: 0,
                borderColor: 'grey',
                credits: 'false'
            },
            credits: {
                enabled: false
            },

            legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'bottom',
                borderWidth: 0
            },
            title: {
                text: ''
            },

            subtitle: {
                text: 'Trended Daily Avg Mood',
                style: {
                    color: 'black'
                }
            },

            xAxis: {
                gridLineWidth: 1,
                lineColor: '#000',
                tickColor: '#000',
                type: 'datetime',
                dateTimeLabelFormats: {
                    day: '%e of %b'
                }
                //maxZoom: 30 * 24 * 3600000 // fourteen days
            },
            yAxis: {
                lineColor: '#000',
                min: 0, max: 6,
                tickInterval: 1,
                lineWidth: 1,
                tickWidth: 1,
                tickColor: '#000',
                title: {
                    text: 'Severity of Mood'
                },
                plotBands: [{ // Occasional sadness in keeping with the circumstances
                    from: 0,
                    to: 1,
                    color: '#fff',
                    label: {
                        text: 'Occasional sadness in keeping with the circumstances',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Sad or low but brithtens up without difficulty
                    from: 1,
                    to: 2,
                    color: '#DFF0E7',
                    label: {
                        text: 'Sad or low but brightens up without difficulty',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Sad and lownes, with difficulty brightening up
                    from: 2,
                    to: 3,
                    color: '#fff',
                    label: {
                        text: 'Sad and lowness, with difficulty brightening up',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Pervasive feelings of sadness or gloominess. Mood influenced by external circumstances
                    from: 3,
                    to: 4,
                    color: '#DFF0E7',
                    label: {
                        text: 'Pervasive feelings of sadness or gloominess. Mood influenced by external circumstances',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Pervasive sadness originating internally and externally
                    from: 4,
                    to: 5,
                    color: '#fff',
                    label: {
                        text: 'Pervasive sadness originating internally and externally',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Continuous or unvarying sadness, misery or dispondency
                    from: 5,
                    to: 6,
                    color: '#DFF0E7',
                    label: {
                        text: 'Continuous or unvarying sadness, misery or dispondency',
                        style: {
                            color: '#606060'
                        }
                    }
                }]
            },
            plotOptions: {
                spline: {
                    dataLabels: {
                        enabled: false
                    },
                    lineWidth: 4,
                    states: {
                        hover: {
                            lineWidth: 5
                        }
                    },
                    marker: {
                        enabled: true
                    },
                    enableMouseTracking: true
                }
            },
            series: [{
                name: 'Observee Mood'
            }]
        });
    }

    if ($('#moodChartPDF').length > 0) {
        moodChartPDF = new Highcharts.Chart({
            chart: {
                defaultSeriesType: 'spline',
                renderTo: 'moodChartPDF',
                borderWidth: 0,
                borderRadius: 0,
                borderColor: 'grey',
                credits: 'false'
            },
            credits: {
                enabled: false
            },

            legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'bottom',
                borderWidth: 0
            },
            title: {
                text: 'Mood Chart'
            },

            subtitle: {
                text: 'Trend of your Daily Avg Mood',
                style: {
                    color: 'black'
                }
            },

            xAxis: {
                gridLineWidth: 1,
                lineColor: '#000',
                tickColor: '#000',
                type: 'datetime',
                dateTimeLabelFormats: {
                    day: '%e of %b'
                }
                //maxZoom: 30 * 24 * 3600000 // fourteen days
            },
            yAxis: {
                lineColor: '#000',
                min: 0, max: 6,
                tickInterval: 1,
                lineWidth: 1,
                tickWidth: 1,
                tickColor: '#000',
                title: {
                    text: 'Severity of Mood'
                },
                plotBands: [{ // Occasional sadness in keeping with the circumstances
                    from: 0,
                    to: 1,
                    color: '#fff',
                    label: {
                        text: 'Occasional sadness in keeping with the circumstances',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Sad or low but brithtens up without difficulty
                    from: 1,
                    to: 2,
                    color: '#DFF0E7',
                    label: {
                        text: 'Sad or low but brightens up without difficulty',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Sad and lownes, with difficulty brightening up
                    from: 2,
                    to: 3,
                    color: '#fff',
                    label: {
                        text: 'Sad and lowness, with difficulty brightening up',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Pervasive feelings of sadness or gloominess. Mood influenced by external circumstances
                    from: 3,
                    to: 4,
                    color: '#DFF0E7',
                    label: {
                        text: 'Pervasive feelings of sadness or gloominess. Mood influenced by external circumstances',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Pervasive sadness originating internally and externally
                    from: 4,
                    to: 5,
                    color: '#fff',
                    label: {
                        text: 'Pervasive sadness originating internally and externally',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Continuous or unvarying sadness, misery or dispondency
                    from: 5,
                    to: 6,
                    color: '#DFF0E7',
                    label: {
                        text: 'Continuous or unvarying sadness, misery or dispondency',
                        style: {
                            color: '#606060'
                        }
                    }
                }]
            },
            plotOptions: {
                spline: {
                    dataLabels: {
                        enabled: false
                    },
                    lineWidth: 4,
                    states: {
                        hover: {
                            lineWidth: 5
                        }
                    },
                    marker: {
                        enabled: true
                    },
                    enableMouseTracking: true
                }
            },
            series: [{
                name: 'My Mood'
            }]
        });
    }

    if ($('#memberSheehanChart').length > 0) {
        memberSheehanChart = new Highcharts.Chart({
            chart: {
                defaultSeriesType: 'spline',
                renderTo: 'memberSheehanChart',
                credits: 'false',
                borderWidth: 0,
                borderRadius: 0
            },
            credits: {
                enabled: false
            },
            legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'bottom',
                borderWidth: 0
            },
            title: {
                text: ''
            },

            subtitle: {
                text: ''
            },

            xAxis: {
                gridLineWidth: 1,
                lineColor: '#000',
                tickColor: '#000',
                type: 'datetime'
                //maxZoom: 30 * 24 * 3600000 // fourteen days


            },
            yAxis: {
                min: 0, max: 10,
                lineColor: '#000',
                minTickInterval: 1,
                //tickInterval: 1,
                lineWidth: 1,
                tickWidth: 1,
                tickColor: '#000',
                title: {
                    text: ''
                }
            },

            rangeSelector: {
                inputDateFormat: '%y-%m-%e'
            },

            series: [{
                type: 'line',
                name: 'Social Life',
                lineWidth: 2

            }, {

                type: 'line',
                name: 'Work/School Life',
                lineWidth: 2


            }, {
                type: 'line',
                name: "Family Life",
                lineWidth: 2
            }]
        });
    }

    if ($('#memberSheehanZoomChart').length > 0) {
        memberSheehanZoomChart = new Highcharts.Chart({
            chart: {
                defaultSeriesType: 'spline',
                renderTo: 'memberSheehanZoomChart',
                credits: 'false',
                borderWidth: 0,
                borderRadius: 0,
                borderColor: 'grey'
            },
            credits: {
                enabled: false
            },
            legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'bottom',
                borderWidth: 0
            },
            title: {
                text: 'Life Scale Rating'
            },

            subtitle: {
                text: 'Measures the impact your condition is having on your daily life'
            },

            xAxis: {
                gridLineWidth: 1,
                lineColor: '#000',
                tickColor: '#000',
                type: 'datetime'
                //maxZoom: 30 * 24 * 3600000 // fourteen days


            },
            yAxis: {
                min: 0, max: 10,
                lineColor: '#000',
                //minTickInterval: 1,
                tickInterval: 2,
                lineWidth: 1,
                tickWidth: 1,
                tickColor: '#000',
                title: {
                    text: 'Severity of impact'
                },
                plotBands: [{ // Occasional sadness in keeping with the circumstances
                    from: 0,
                    to: 1,
                    color: '#fff',
                    label: {
                        text: 'No issues in this area',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Sad or low but brithtens up without difficulty
                    from: 1,
                    to: 3,
                    color: '#DFF0E7',
                    label: {
                        text: 'Mildly Impacting',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Sad and lownes, with difficulty brightening up
                    from: 3,
                    to: 6,
                    color: '#fff',
                    label: {
                        text: 'Moderately Impacting',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Pervasive feelings of sadness or gloominess. Mood influenced by external circumstances
                    from: 6,
                    to: 9,
                    color: '#DFF0E7',
                    label: {
                        text: 'Highly Impacting',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Pervasive sadness originating internally and externally
                    from: 9,
                    to: 10,
                    color: '#fff',
                    label: {
                        text: 'Extremely Impacting',
                        style: {
                            color: '#606060'
                        }
                    }
                }],

            },

            rangeSelector: {
                inputDateFormat: '%y-%m-%e'
            },
            series: [{
                name: 'Social Life',
                lineWidth: 4

            }, {

                name: 'Work/School Life',
                lineWidth: 4


            }, {
                name: "Family Life",
                lineWidth: 4
            }]
        });
    }

    if ($('#observeeSheehanZoomChart').length > 0) {
        observeeSheehanZoomChart = new Highcharts.Chart({
            chart: {
                defaultSeriesType: 'spline',
                renderTo: 'observeeSheehanZoomChart',
                credits: 'false',
                borderWidth: 0,
                borderRadius: 0,
                borderColor: 'grey'
            },
            credits: {
                enabled: false
            },
            legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'bottom',
                borderWidth: 0
            },
            title: {
                text: ''
            },

            subtitle: {
                text: 'Measures the impact of daily life'
            },

            xAxis: {
                gridLineWidth: 1,
                lineColor: '#000',
                tickColor: '#000',
                type: 'datetime'
                //maxZoom: 30 * 24 * 3600000 // fourteen days


            },
            yAxis: {
                min: 0, max: 10,
                lineColor: '#000',
                //minTickInterval: 1,
                tickInterval: 2,
                lineWidth: 1,
                tickWidth: 1,
                tickColor: '#000',
                title: {
                    text: 'Severity of impact'
                },
                plotBands: [{ // Occasional sadness in keeping with the circumstances
                    from: 0,
                    to: 1,
                    color: '#fff',
                    label: {
                        text: 'No issues in this area',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Sad or low but brithtens up without difficulty
                    from: 1,
                    to: 3,
                    color: '#DFF0E7',
                    label: {
                        text: 'Mildly Impacting',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Sad and lownes, with difficulty brightening up
                    from: 3,
                    to: 6,
                    color: '#fff',
                    label: {
                        text: 'Moderately Impacting',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Pervasive feelings of sadness or gloominess. Mood influenced by external circumstances
                    from: 6,
                    to: 9,
                    color: '#DFF0E7',
                    label: {
                        text: 'Highly Impacting',
                        style: {
                            color: '#606060'
                        }
                    }
                }, { // Pervasive sadness originating internally and externally
                    from: 9,
                    to: 10,
                    color: '#fff',
                    label: {
                        text: 'Extremely Impacting',
                        style: {
                            color: '#606060'
                        }
                    }
                }],

            },

            rangeSelector: {
                inputDateFormat: '%y-%m-%e'
            },
            series: [{
                name: 'Social Life',
                lineWidth: 4

            }, {

                name: 'Work/School Life',
                lineWidth: 4


            }, {
                name: "Family Life",
                lineWidth: 4
            }]
        });
    }

    if($('#madrsChart').length > 0) {
        MADRSChart = new Highcharts.Chart({
            chart: {
                type: 'spline',
                borderWidth: 0,
                borderRadius: 10,
                renderTo: 'madrsChart'
            },
            title: {
                text: '',
                x: -20 //center
            },
            subtitle: {
                text: '',
                style: {
                    color: '#fff'
                },
                x: -20
            },
            credits: {
                enabled: false
            },
            xAxis: {
                type: 'datetime'
                //maxZoom: 30 * 24 * 3600000 // fourteen days
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Score'
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            tooltip: {
                valueSuffix: 'score'
            },
            legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'bottom',
                borderWidth: 0
            },
            series: [{
                name: 'Me',
            }, {
                name: 'Everyone Else'
            }]
        });
    }

    if($('#observeemadrsdimChart').length > 0) {
        observeemadrsdimChart = new Highcharts.Chart({
            chart: {
                type: 'spline',
                borderWidth: 0,
                borderRadius: 10,
                renderTo: 'observeemadrsdimChart'
            },
            title: {
                text: '',
                x: -20 //center
            },
            subtitle: {
                text: '',
                style: {
                    color: '#fff'
                },
                x: -20
            },
            credits: {
                enabled: false
            },
            xAxis: {
                type: 'datetime'
                //maxZoom: 30 * 24 * 3600000 // fourteen days
            },
            yAxis: {
                min: 0, max: 6,
                tickInterval: 1,
                title: {
                    text: ''
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            tooltip: {
                valueSuffix: ' avg'
            },
            legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'bottom',
                borderWidth: 0
            },
            series: [{
                name: 'Activity',
                color: '#4FA59F',
                lineWidth: 4
            }, {
                name: 'Energy',
                color: '#F19A20',
                lineWidth: 4
            }, {
                name: 'Hyper',
                color: '#CC246F',
                lineWidth: 4
            }, {
                name: 'Hopelessness',
                color: '#B4D336',
                lineWidth: 4
            }]
        });
    }

    if($('#observeesideffectsChart').length > 0) {
        observeesideffectsChart = new Highcharts.Chart({
            chart: {
                type: 'spline',
                borderWidth: 0,
                borderRadius: 10,
                renderTo: 'observeesideffectsChart'
            },
            title: {
                text: '',
                x: -20 //center
            },
            subtitle: {
                text: '',
                style: {
                    color: '#fff'
                },
                x: -20
            },
            credits: {
                enabled: false
            },
            xAxis: {
                type: 'datetime'
                //maxZoom: 30 * 24 * 3600000 // fourteen days
            },
            yAxis: {
                min: 0, max: 6,
                tickInterval: 1,
                title: {
                    text: ''
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            tooltip: {
                valueSuffix: ' avg'
            },
            legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'bottom',
                borderWidth: 0
            },
            series: [{
                name: 'Delusions',
                color: '#4FA59F',
                lineWidth: 4
            }, {
                name: 'Hallucinations',
                color: '#F19A20',
                lineWidth: 4
            }, {
                name: 'Dangerous Behavior',
                color: '#CC246F',
                lineWidth: 4
            }, {
                name: 'Substance Abuse',
                color: '#B4D336',
                lineWidth: 4
            }]
        });
    }

    if($('#madrsdimChart').length > 0) {
        MADRSDimensionsChart = new Highcharts.Chart({

            chart: {
                defaultSeriesType: 'spline',
                renderTo: 'madrsdimChart',
                borderWidth: 0,
                borderRadius: 0,
                credits: 'false'
            },
            credits: {
                enabled: false
            },
            legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'bottom',
                borderWidth: 0
            },
            title: {
                // text: 'Symptoms & Side Effects',
                text: '',
                color: '#fff'
            },

            subtitle: {
                text: '',
                style: {
                    color: '#fff'
                },
                y: 0,
                x: -20
            },

            xAxis: {
                gridLineWidth: 1,
                lineColor: '#000',
                tickColor: '#000',
                type: 'datetime'
                //maxZoom: 30 * 24 * 3600000 // fourteen days
            },
            yAxis: {
                lineColor: '#000',
                min: 0, max: 6,
                tickInterval: 1,
                lineWidth: 1,
                tickWidth: 1,
                tickColor: '#000',
                title: {
                    text: 'Score'
                }
            },

            rangeSelector: {
                inputDateFormat: '%y-%m-%e'
            },

            series: [{
                name: 'Appetite',
                color: '#4FA59F',
                lineWidth: 4
            }, {
                name: 'Sleep',
                color: '#F19A20',
                lineWidth: 4
            }, {
            //     name: 'Pessimism',
            //     color: '#CC246F',
            //     lineWidth: 4
            // }, {
                name: 'Hopelessness',
                color: '#B4D336',
                lineWidth: 4
            }]

        });
    }

    if($('#addmadrsdimChart').length > 0) {
        additionalMadrsDimensionsChart = new Highcharts.Chart({
            chart: {
                type: 'spline',
                borderWidth: 0,
                borderRadius: 0,
                renderTo: 'addmadrsdimChart'
            },
            title: {
                text: '',
                x: -20 //center
            },
            subtitle: {
                text: '',
                style: {
                    color: '#fff'
                },
                x: 0
            },
            credits: {
                enabled: false
            },
            xAxis: {
                gridLineWidth: 1,
                lineColor: '#000',
                tickColor: '#000',
                type: 'datetime'
                //maxZoom: 30 * 24 * 3600000 // fourteen days
            },
            yAxis: {
                lineColor: '#000',
                min: 0, max: 6,
                tickInterval: 1,
                lineWidth: 1,
                tickWidth: 1,
                tickColor: '#000',
                title: {
                    text: 'Score'
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            tooltip: {
                valueSuffix: 'score'
            },
            legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'bottom',
                borderWidth: 0
            },
            series: [{
                name: 'Anxiety',
                color: '#4FA59F',
                lineWidth: 4
            }, {
                name: 'Sleep',
                color: '#F19A20',
                lineWidth: 4
            }, {
                name: 'Energy',
                color: '#CC246F',
                lineWidth: 4
            }, {
                name: 'Concentration',
                color: '#B4D336',
                lineWidth: 4
            }, {
                name: 'MOOD',
                color: 'red',
                lineWidth: 4
            }]
        });
    }

    if($('#symptomChart').length > 0) {
        symptomChart = new Highcharts.Chart({
            chart: {
                type: 'column',
                borderWidth: 0,
                borderRadius: 0,
                renderTo: 'symptomChart'
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
                //tickInterval: 1,
                lineWidth: 1,
                tickWidth: 1,
                tickColor: '#000',
                title: {
                    text: 'Count'
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
            series: [{
                name: 'Panic Attacks',
                pointWidth: 10
            }, {
                name: 'Suicidal Thoughts',
                pointWidth: 10
            }, {
                name: 'Headache',
                pointWidth: 10
            }, {
                name: 'Restlessness',
                pointWidth: 10
            }, {
                name: 'Nausea',
                pointWidth: 10
            }]
        });
    }

    if ($('#weightChart').length > 0) {
        weightChart = new Highcharts.Chart({
            chart: {
                defaultSeriesType: 'spline',
                renderTo: 'weightChart',
                credits: 'false',
                borderWidth: 0,
                borderRadius: 0
            },
            credits: {
                enabled: false
            },
            legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'bottom',
                borderWidth: 0
            },
            title: {
                text: ''
            },

            subtitle: {
                text: ''
            },

            xAxis: {
                gridLineWidth: 1,
                lineColor: '#000',
                tickColor: '#000',
                type: 'datetime'
                //maxZoom: 30 * 24 * 3600000 // fourteen days


            },
            yAxis: {
                minPadding: 0,
                lineColor: '#000',
                minTickInterval: 1,
                //tickInterval: 1,
                lineWidth: 1,
                tickWidth: 1,
                tickColor: '#000',
                title: {
                    text: ''
                }
            },

            rangeSelector: {
                inputDateFormat: '%y-%m-%e'
            },

            series: [{
                name: 'Weight',
                lineWidth: 4

            }]
        });
    }


    if($('#genderChart').length > 0) {
        setupGenderChart();
    }

    if($('#raceChart').length > 0) {
        setupRaceChart();
    }

    if($('#genderHospitalizationChart').length > 0) {
        setupGenderHospitalizationChart();
    }

    if($('#memberDiagnosisPieChart').length > 0) {
        setupMemberDiagnosisPieChart();
    }

    if($('#patientMoodChart').length > 0) {
        setupPatientMoodChart();
    }

    if($('#PatientMADRSScoreChart').length > 0) {
        setupPatientMADRSScoreChart();
    }

    if($('#patientMadrsDim').length > 0) {
        setupPatientMadrsDimChart();
    }

    if($('#patientMadrsAddDim').length > 0) {
        setupPatientMadrsAdditionalDimChart();
    }
    if($('#patientSymptoms').length > 0) {
        setupPatientSymptoms();
    }

    if($('#patientSheehanChart').length > 0) {
        setupPatientSheehanChart();
    }

    if($('#patientSheehanZoomChart').length > 0) {
        setupPatientSheehanZoomChart();
    }

    if($('#clinicDiagnosisPie').length > 0) {
        setupClinicDiagnosisPieChart();
    }

    if($('#clinicPiebyAgeChart').length > 0) {
        setupClinicPiebyAgeChart();
    }

    if($('#clinicbyMedsColumn').length > 0) {
        setupClinicbyMedsColumnChart();
    }

    if($('#clinicHospitalizationsBarChart').length > 0) {
        setupClinicHospitalizationsBarChart();
    }

    if($('#patientCountChart').length > 0) {
        setuppatientCountChart();
    }

    if($('#patientHospitalizationCountChart').length > 0) {
        setuppatientHospitalizationCountChart();
    }

    if($('#genderWorkLifeChart').length > 0) {
        setupGenderWorkLifeChart();
    }

    if($('#patientMoodZoomChart').length > 0) {
        setupPatientMoodZoomChart();
    }

    if($('#patientWeightChart').length > 0) {
        setupPatientWeightChart();
    }
}

$(document).ready(function() {
    $("#remove-filters").click(function() {
        resetData();
        $(".side-menu").find(".active").removeClass("active");
        $("#sel2").find(":selected").removeAttr("selected");
        $("input[name=start_date]").val("");
        $("input[name=end_date]").val("");
    });
});

// copied from getNewData and amended
function resetData() {
    var successFunction;
    var type = "json";
    currentPath = window.location.pathname;

    if(/^\/dashboard/.test(currentPath)) {
        successFunction = renderDashboardData;
    } else if(/^\/charts/.test(currentPath)) {
        successFunction = renderChartsData;
    } else if(/^\/socials/.test(currentPath)) {
        successFunction = renderSocialsData;
    } else if(/^\/prescriptions/.test(currentPath)) {
        successFunction = renderPrescriptionData;
    } else if(/^\/patients\/\d+/.test(currentPath)) { // /patients/:id
        successFunction = renderPatientsData;
    } else if(/^\/clinicians\/clinic_dashboard/.test(currentPath)) {
        successFunction = renderClinicData;
    } else if(/^\/patients/.test(currentPath)) {
        successFunction = renderPatientsList;
        type = "script";
    } else {
        console.log("Unknown page called from getNewData");
    }

    if(successFunction != undefined) {
        $.ajax({
            dataType: type,
            url: currentPath,
            data: undefined,
            success: successFunction
        });
    }
}

