    function renderClinicData(data) {
        members = data["members"];

        $('#members_count').html(members["count"]);

        patients_count = data["charts"]["members"]["count"];
        if($('#patientCountChart').length > 0)  {
            patientCountChart.series[0].setData(patients_count);
        }
        if($('#clinicDiagnosisPie').length > 0) {
            if(clinicDiagnosisPie.series.length > 0) {
                clinicDiagnosisPie.series[0].remove();
            }
            clinicDiagnosisPie.addSeries(data["charts"]["diagnosis"]);
        }
        if($('#clinicPiebyAgeChart').length > 0) {
            if(clinicPiebyAgeChart.series.length > 0) {
                clinicPiebyAgeChart.series[0].remove();
            }
            clinicPiebyAgeChart.addSeries(data["charts"]["age_range"]);
        }
        if($('#clinicbyMedsColumn').length > 0) {
            if(clinicbyMedsColumn.series.length > 0) {
                clinicbyMedsColumn.series[0].remove();
            }
            clinicbyMedsColumn.addSeries(data["charts"]["meds"]);
        }
    }


    function setuppatientCountChart() {
        patientCountChart = new Highcharts.Chart({
            chart: {
                defaultSeriesType: 'column',
                borderWidth: 3,
                borderRadius: 10,
                renderTo: 'patientCountChart'
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
                text: 'Dates when Patients were added or removed'
            },

            xAxis: {
                type: 'datetime'
                //maxZoom: 30 * 24 * 3600000 // fourteen days
            },

            series: [{
                name: 'Patients added',
                color: 'green'
            }],

            yAxis: {
                minTickInterval: 1,
                title: {
                    text: 'Number of Patients'
                }
            }
        });
    }

    function setupClinicDiagnosisPieChart() {
        clinicDiagnosisPie = new Highcharts.Chart({
            chart: {
                plotShadow: false,
                type: 'pie',
                borderRadius: 10,
                backgroundColor: '#fdfcfc',
                renderTo: 'clinicDiagnosisPie'
            },
            credits: {
                enabled: false
            },

            title: {
                text: 'by Diagnosis'
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

    function setupClinicPiebyAgeChart() {
        clinicPiebyAgeChart = new Highcharts.Chart({
            chart: {
                plotShadow: false,
                type: 'pie',
                borderRadius: 10,
                backgroundColor: '#fdfcfc',
                renderTo: 'clinicPiebyAgeChart'
            },
            title: {
                text: 'Patients by Age Group'
            },
            credits: {
                enabled: false
            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.y}</b>'
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

    function setupClinicbyMedsColumnChart() {
        clinicbyMedsColumn = new Highcharts.Chart({

            colors: ['#4FA59F','#F19A20','#CC246F','#B4D336','#8CD2CB','#DFF0E7','#326867'],
            chart: {
                    type: 'column',
                    borderRadius: 0,
                    borderWidth: 1,
                    borderColor: 'lightgrey',
                    renderTo: 'clinicbyMedsColumn'
                },
                title: {
                    text: '# of Patients by Medication'
                },
                credits: {
                    enabled: false
                },
                xAxis: {
                    type: 'category',
                    labels: {
                        rotation: -45,
                        style: {
                            fontSize: '13px',
                            fontFamily: 'Verdana, sans-serif'
                        }
                    }
                },
                yAxis: {
                    min: 0,
                    minTickInterval: 1,
                    title: {
                        text: 'Patients'
                    }
                },
                legend: {
                    enabled: false
                },
                tooltip: {
                    pointFormat: 'Patients <b>{point.y:.1f} </b>'
                },
                series: [{
                    name: '# of Patients',
                    dataLabels: {
                        enabled: true,
                        rotation: -90,
                        color: '#FFFFFF',
                        align: 'right',
                        format: '{point.y:.1f}', // one decimal
                        y: 10, // 10 pixels down from the top
                        style: {
                            fontSize: '13px',
                            fontFamily: 'Verdana, sans-serif'
                        }
                    }
                }]
            });
    }

    function setupClinicHospitalizationsBarChart() {
        clinicHospitalizationsBarChart = new Highcharts.Chart({

            colors: ['#4FA59F','#F19A20','#CC246F','#B4D336','#8CD2CB','#DFF0E7','#326867'],
            chart: {
                    type: 'bar',
                    borderRadius: 0,
                    borderWidth: 1,
                    borderColor: 'lightgrey',
                    renderTo:'clinicHospitalizationsBarChart'
                },
                credits: {
                    enabled: false
                },
                title: {
                    text: '# of Patient Hospitalizations by Diagnosis'
                },
                xAxis: {
                    categories: ['Patients <30 days', 'Patients <60 days', 'Patients <6 mo', 'Patients <9mo', 'Patients >1yr']
                },
                yAxis: {
                    min: 0,
                    minTickInterval: 1,
                    title: {
                        text: '# of Patients'
                    }
                },
                legend: {
                    reversed: true
                },
                plotOptions: {
                    series: {
                        stacking: 'normal'
                    }
                },
                series: [{
                    name: 'Bipolar Mania',
                    data: [5, 3, 3, 3, 2]
                }, {
                    name: 'MDD',
                    data: [4, 3, 3, 2, 1]
                }, {
                    name: 'Borderline',
                    data: [2, 2, 1, 2, 1]
                }]
            });
    }
