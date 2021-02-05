$(function() {
	if ($('#prescriptionConsistencyChart').length > 0) {
			getPrescriptionData();
	}

	$("#prescription_as_needed").on("change", function () {
		if ($("#prescription_as_needed").is(":checked")) {
			$("#prescription_reminder_group").slideToggle();
		} else {
			$("#prescription_reminder_group").slideToggle();
		}
    $("#prescription_reminder").prop("disabled", $("#prescription_as_needed").prop("checked"));
	});
});

function getPrescriptionData() {
	$.ajax({
			dataType: "json",
			url: "/prescriptions.json",
			success: renderPrescriptionChart
	});
}

function renderPrescriptionChart(data) {
	setupPrescriptionChart(data);
}

function setupPrescriptionChart(data) {
	prescriptionChart = new Highcharts.Chart({
        chart: {
			type: 'column',
			borderWidth: 0,
			borderRadius: 0,
			renderTo: 'prescriptionConsistencyChart'
		},
		title: {
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
		series: data["series"]
	});
}
