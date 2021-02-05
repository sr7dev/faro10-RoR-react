function renderPatientsData(data) {
		all = data["all"];
		patient = data["patient"];
		observer = data["observer"];
		user_prescription = data["user_prescription"];

		series = data["series"];
		
		setupPatientPrescriptionConsistencyChart(series);
		
//KPI Bar
		$('#patient_feeling').html(patient["feeling"]);
		$('#patient_energy').html(patient["energy"]);
		$('#patient_hospitalization').html(patient["hospitalization"]);
		$('#patient_social_life').html(patient["social_life"]);
		$('#patient_activity').html(patient["activity"]);
		$('#patient_panic_attack').html(patient["panic_attack"]);


//Primary Symptoms Table
		$('#patient_table_feeling').html(patient["feeling"]);
		$('#patient_table_energy').html(patient["energy"]);
		$('#patient_table_activity').html(patient["activity"]);
		$('#patient_suicide_thought').html(patient["suicide_thought"]);
		$('#patient_sleep').html(patient["hrs_slept"]);
		$('#patient_nightmare').html(patient["nightmare"]);


//Adverse Events Table
		$('#patient_ae_weight').html(patient["weight"]);
		$('#patient_ae_dry_mouth').html(patient["dry_mouth"]);
		$('#patient_ae_headache').html(patient["headache"]);
		$('#patient_ae_hrs_slept').html(patient["hrs_slept"]);
		$('#patient_ae_restlessness').html(patient["restlessness"]);
		$('#patient_ae_nausea').html(patient["nausea"]);



		patient_mood_feelings = patient["chart"]["feeling"];
		all_mood_feelings = all["chart"]["feeling"];
		observed_mood_feelings = observer["chart"]["feeling"];
		patient_appetite = patient["chart"]["appetite"];
		patient_initiative = patient["chart"]["initiative"];
		patient_pessimism = patient["chart"]["pessimism"];
		patient_zest = patient["chart"]["zest"];
		patient_anxiety = patient["chart"]["anxiety"];
		patient_sleep = patient["chart"]["sleep"];
		patient_energy = patient["chart"]["energy"];
		patient_concentration = patient["chart"]["concentration"];
		patient_panic_attack = patient["chart"]["panic_attack"];
		patient_suicide_thought = patient["chart"]["suicide_thought"];
		patient_headache = patient["chart"]["headache"];
		patient_nightmare = patient["chart"]["nightmare"];
		patient_hospitalization = patient["chart"]["hospitalization"];
		patient_social_life = patient["chart"]["social_life"];
		patient_work_life = patient["chart"]["work_life"];
		patient_family_life = patient["chart"]["family_life"];
		patient_user_prescription = user_prescription["chart"]["meds_taken"];
		patient_weight = patient["chart"]["weight"];


		if($('#patientMoodChart').length > 0) {
				patientMoodChart.series[0].setData(patient_mood_feelings);
				patientMoodChart.series[1].setData(observed_mood_feelings);
				patientMoodChart.series[2].setData(all_mood_feelings);
		}

		if($('#PatientMADRSScoreChart').length > 0) {
				PatientMADRSScoreChart.series[0].setData(patient_mood_feelings);
		}

		if($('#patientMadrsDim').length > 0) {
				patientMadrsDim.series[0].setData(patient_appetite);
				patientMadrsDim.series[1].setData(patient_initiative);
				patientMadrsDim.series[2].setData(patient_pessimism);
				patientMadrsDim.series[3].setData(patient_zest);
		}
		if($('#patientMadrsAddDim').length > 0) {
				patientMadrsAddDim.series[0].setData(patient_anxiety);
				patientMadrsAddDim.series[1].setData(patient_sleep);
				patientMadrsAddDim.series[2].setData(patient_energy);
				patientMadrsAddDim.series[3].setData(patient_concentration);
		}
		if($('#patientSymptoms').length > 0) {
				patientSymptoms.series[0].setData(patient_panic_attack);
				patientSymptoms.series[1].setData(patient_suicide_thought);
				patientSymptoms.series[2].setData(patient_headache);
				patientSymptoms.series[3].setData(patient_nightmare);
		}
		if($('#patientHospitalizationCountChart').length > 0) {
				patientHospitalizationCountChart.series[0].setData(patient_hospitalization);
		}
		if($('#patientSheehanChart').length > 0) {
				patientSheehanChart.series[0].setData(patient_social_life);
				patientSheehanChart.series[1].setData(patient_work_life);
				patientSheehanChart.series[2].setData(patient_family_life);
		}
		if($('#patientSheehanZoomChart').length > 0) {
				patientSheehanZoomChart.series[0].setData(patient_social_life);
				patientSheehanZoomChart.series[1].setData(patient_work_life);
				patientSheehanZoomChart.series[2].setData(patient_family_life);
		}

		if($('#patientPrescriptionConsistencyChart').length > 0) {
				patientPrescriptionConsistencyChart.series[0].setData(patient_user_prescription);
		}

		if($('#patientMoodZoomChart').length > 0) {
				patientMoodZoomChart.series[0].setData(patient_mood_feelings);
				patientMoodZoomChart.series[1].setData(observed_mood_feelings);
				patientMoodZoomChart.series[2].setData(all_mood_feelings);
		}

		if($('#patientWeightChart').length > 0) {
				patientWeightChart.series[0].setData(patient_weight);
		}
}

function setupPatientMoodChart() {
				patientMoodChart = new Highcharts.Chart({
						chart: {
								defaultSeriesType: 'spline',
								renderTo: 'patientMoodChart',
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
								min: 0, max: 6,
								lineColor: '#000',
								minTickInterval: 1,
								//tickInterval: 1,
								lineWidth: 1,
								tickWidth: 1,
								tickColor: '#000',
								title: {
										text: 'Daily Avg Mood'
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

						rangeSelector: {
								inputDateFormat: '%y-%m-%e'
						},

						series: [{
								name: 'Patient Mood',
								lineWidth:4

						}, {

								name: 'Observed Mood',
								lineWidth:4


						},{
								name: "Peer Benchmark",
								lineWidth:4
						}]
		});
}


function setupPatientMADRSScoreChart() {
				PatientMADRSScoreChart = new Highcharts.Chart({
				chart: {
						type: 'spline',
						borderRadius: 0,
						borderWidth: 0,
						renderTo: 'PatientMADRSScoreChart'
				},
				title: {
						text: ''
						//x: -20 //center
				},
				subtitle: {
						text: ''
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
						min: 0,
						lineColor: '#000',
						minTickInterval: 1,
						//tickInterval: 1,
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
						name: 'Patient MADRS',
						lineWidth:2
						//data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]
				}]
		});
}


function setupPatientMadrsDimChart() {
				patientMadrsDim = new Highcharts.Chart({

						chart: {
								defaultSeriesType: 'spline',
								renderTo: 'patientMadrsDim',
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
								min: 0, max:6,
								lineColor: '#000',
								minTickInterval: 1,
								//tickInterval: 1,
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
								lineWidth:4
						}, {
								name: 'Initiative',
								lineWidth:4
						}, {
								name: 'Pessimism',
								lineWidth:4
						}, {
								name: 'Hopelessness',
								lineWidth:4
						}]

				});
}


function setupPatientMadrsAdditionalDimChart() {
				patientMadrsAddDim = new Highcharts.Chart({
						chart: {
								type: 'spline',
								borderWidth: 0,
								borderRadius: 0,
								renderTo: 'patientMadrsAddDim'
						},
						title: {
								text: ''
								//x: -20 //center
						},
						subtitle: {
								text: ''
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
								min: 0, max:6,
								lineColor: '#000',
								minTickInterval: 1,
								//tickInterval: 1,
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
								lineWidth:4
						}, {
								name: 'Sleep',
								lineWidth:4
						}, {
								name: 'Energy',
								lineWidth:4
						}, {
								name: 'Concentration',
								lineWidth:4
						}]
				});
}

function setupPatientSymptoms() {
				patientSymptoms = new Highcharts.Chart({
                    chart: {
								type: 'column',
								borderWidth: 0,
								borderRadius: 0,
								renderTo: 'patientSymptoms'
						},
						title: {
								text: ''
						},
						subtitle: {
								text: ''
						},
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
								'<td style="padding:0"><b>{point.y:f}</b></td></tr>',
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

						}, {
								name: 'Suicidal Thoughts',

						}, {
								name: 'Headache',

						}, {
								name: 'Vivid Dreams/Nightmares',

						}]
				});
}

function setuppatientHospitalizationCountChart() {
		patientHospitalizationCountChart = new Highcharts.Chart({
            chart: {
						defaultSeriesType: 'column',
						borderWidth: 3,
						borderRadius: 10,
						renderTo: 'patientHospitalizationCountChart'
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
						text: 'Dates when Patients were Hospitalized'
				},

				xAxis: {
						type: 'datetime'
						//maxZoom: 30 * 24 * 3600000 // fourteen days
				},

				series: [{
						name: 'Hospitalization',
						color: 'red'
				}
				],

				yAxis: {
						minTickInterval: 1,
						title: {
								text: 'Date in Hospital'
						}
				}
		});
}

function setupPatientSheehanChart() {
		patientSheehanChart = new Highcharts.Chart({
				chart: {
						defaultSeriesType: 'spline',
						renderTo: 'patientSheehanChart',
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
						//minTickInterval: 1,
						tickInterval: 2,
						lineWidth: 1,
						tickWidth: 1,
						tickColor: '#000',
						title: {
								text: ''
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
                    }]
				},

				rangeSelector: {
						inputDateFormat: '%y-%m-%e'
				},

				series: [{
						name: 'Social Life',
						lineWidth:4

				}, {

						name: 'Work/School Life',
						lineWidth:4


				},{
						name: "Family Life",
						lineWidth:4
				}]
		});
}

function setupPatientSheehanZoomChart() {
		patientSheehanZoomChart = new Highcharts.Chart({
				chart: {
						defaultSeriesType: 'spline',
						renderTo: 'patientSheehanZoomChart',
						credits: 'false',
						borderWidth: 0,
						borderRadius: 10
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
						minTickInterval: 1,
						//tickInterval: 1,
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
                    }]
				},

				rangeSelector: {
						inputDateFormat: '%y-%m-%e'
				},

				series: [{
						name: 'Social Life',
						lineWidth:4

				}, {

						name: 'Work/School Life',
						lineWidth:4


				},{
						name: "Family Life",
						lineWidth:4
				}]
		});
}

function setupPatientPrescriptionConsistencyChart(series) {

		patientPrescriptionConsistencyChart = new Highcharts.Chart({
            chart: {
					type: 'column',
					borderWidth: 0,
					borderRadius: 0,
					renderTo: 'patientPrescriptionConsistencyChart'
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
							text: '# of Doses'
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
			series: series
		});
		
		$('#patientPrescriptionHistoryModal').on('shown.bs.modal', function() {
			patientPrescriptionConsistencyChart.reflow();
		});
}

function setupPatientMoodZoomChart() {
		patientMoodZoomChart = new Highcharts.Chart({
				chart: {
						defaultSeriesType: 'spline',
						renderTo: 'patientMoodZoomChart',
						credits: 'false',
						borderWidth: 0,
						borderRadius: 10
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
						text: 'Patient Mood Chart'
				},

				subtitle: {
						text: 'Patient and Observer Mood Feedback'
				},

				xAxis: {
						gridLineWidth: 1,
						lineColor: '#000',
						tickColor: '#000',
						type: 'datetime'
						//maxZoom: 30 * 24 * 3600000 // fourteen days


				},
				yAxis: {
						min: 0, max: 6,
						lineColor: '#000',
						minTickInterval: 1,
						//tickInterval: 1,
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

				rangeSelector: {
						inputDateFormat: '%y-%m-%e'
				},

				series: [{
						name: 'Patient Mood',
						lineWidth:4

				}, {

						name: 'Observed Mood',
						lineWidth:4


				},{
						name: "Peer Benchmark",
						lineWidth:4
				}]
		});
}

function setupPatientWeightChart() {
				patientWeightChart = new Highcharts.Chart({
						chart: {
								defaultSeriesType: 'spline',
								renderTo: 'patientWeightChart',
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
