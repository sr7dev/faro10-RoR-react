
function renderDashboardData(data) {
    all = data["all"];
    user = data["user"];
    observations = data["observations"];   //need to figure out how to get data for guardian dashboard charts (this isn't working)


    // diff = all["feeling"] - all_old["feeling"]
    //   = + if trending upwards
    // if diff > 0
    // display an up arrow
    // size-of-arrow = 0-1 of diff
    //$('#all_feeling').html(all["feeling"] + "<i class='fa fa-arrow-up'></i>");
    //   = - if trending downwards
    //$('#all_feeling').html(all["feeling"] + "<i class='fa fa-arrow-down'></i>");
    //   = 0 if staying the same
    //$('#all_feeling').html(all["feeling"]);

    $('#all_feeling').html(all["feeling"]);
    $('#all_emotion').html(all["emotion"]);
    $('#all_energy').html(all["energy"]);
    $('#all_activity').html(all["activity"]);
    $('#all_anxiety').html(all["anxiety"]);
    $('#all_headache').html(all["headache"]);
    $('#all_hrs_slept').html(all["hrs_slept"]);
    $('#all_took_meds').html(all["took_meds"]);
    $('#all_suicide_thought').html(all["suicide_thought"]);
    $('#all_zest').html(all["zest"]);
    $('#all_pessimism').html(all["pessimism"]);
    $('#all_panic_attack').html(all["panic_attack"]);
    $('#all_initiative').html(all["initiative"]);
    $('#all_concentration').html(all["concentration"]);
    $('#all_appetite').html(all["appetite"]);
    $('#all_restlessness').html(all["restlessness"]);
    $('#all_dry_mouth').html(all["dry_mouth"]);
    $('#all_nausea').html(all["nausea"]);
    $('#all_nightmare').html(all["nightmare"]);
    $('#all_weight').html(all["weight"]);


    $('#user_feeling').html(user["feeling"]);
    $('#user_emotion').html(user["emotion"]);
    $('#user_energy').html(user["energy"]);
    $('#user_activity').html(user["activity"]);
    $('#user_anxiety').html(user["anxiety"]);
    $('#user_headache').html(user["headache"]);
    $('#user_hrs_slept').html(user["hrs_slept"]);
    $('#user_took_meds').html(user["took_meds"]);
    $('#user_suicide_thought').html(user["suicide_thought"]);
    $('#user_zest').html(user["zest"]);
    $('#user_pessimism').html(user["pessimism"]);
    $('#user_panic_attack').html(user["panic_attack"]);
    $('#user_initiative').html(user["initiative"]);
    $('#user_concentration').html(user["concentration"]);
    $('#user_appetite').html(user["appetite"]);
    $('#user_restlessness').html(user["restlessness"]);
    $('#user_dry_mouth').html(user["dry_mouth"]);
    $('#user_nausea').html(user["nausea"]);
    $('#user_nightmare').html(user["nightmare"]);
    $('#user_weight').html(user["weight"]);

    console.log("Got a successful response. Data:", data);

    user_mood_feelings = user["chart"]["feeling"];
    all_mood_feelings = all["chart"]["feeling"];
    user_appetite = user["chart"]["appetite"];
    user_initiative = user["chart"]["initiative"];
    user_pessimism = user["chart"]["pessimism"];
    user_zest = user["chart"]["zest"];
    user_anxiety = user["chart"]["anxiety"];
    user_sleep = user["chart"]["sleep"];
    user_energy = user["chart"]["energy"];
    user_concentration = user["chart"]["concentration"];
    user_panic_attack = user["chart"]["panic_attack"];
    user_suicide_thought = user["chart"]["suicide_thought"];
    user_restlessness = user["chart"]["restlessness"];
    user_nausea = user["chart"]["nausea"];
    user_headache = user["chart"]["headache"];
    user_nightmare = user["chart"]["nightmare"];
    user_social = user["chart"]["social_life"];
    user_work = user["chart"]["work_life"];
    user_family = user["chart"]["family_life"];
    user_weight = user["chart"]["weight"];
    observed_feeling = observations["chart"]["feeling"];
    observed_social = observations["chart"]["social_interaction"];
    observed_family = observations["chart"]["family_life"];
    observed_work = observations["chart"]["work_life"];
    observed_delusional = observations["chart"]["delusional"];
    observed_hallucination = observations["chart"]["hallucination"];
    observed_hyperactive = observations["chart"]["hyperactive"];
    observed_energy = observations["chart"]["energy"];
    observed_activity = observations["chart"]["activity"];
    observed_zest = observations["chart"]["zest"];
    observed_dangerous_behavior = observations["chart"]["dangerous_behavior"];
    observed_substance_abuse = observations["chart"]["substance_abuse"];

    if($('#moodChart').length > 0) {
        moodChart.series[0].setData(user_mood_feelings);
        // Commenting out to not show everyone else mood
        // moodChart.series[1].setData(all_mood_feelings);
    }

    if($('#moodChartModal').length > 0) {
        moodChartModal.series[0].setData(user_mood_feelings);
        // Commenting out to not show everyone else mood
        // moodChartModal.series[1].setData(all_mood_feelings);
    }

    if($('#moodChartPDF').length > 0) {
        moodChartPDF.series[0].setData(user_mood_feelings);
        // Commenting out to not show everyone else mood
        // moodChartModal.series[1].setData(all_mood_feelings);
    }

    if($('#observeeMoodChartModal').length > 0) {
        observeeMoodChartModal.series[0].setData(observed_feeling);
    }

    if($('#memberSheehanChart').length > 0) {
        memberSheehanChart.series[0].setData(user_social);
        memberSheehanChart.series[1].setData(user_work);
        memberSheehanChart.series[2].setData(user_family);
    }

    if($('#memberSheehanZoomChart').length > 0) {
        memberSheehanZoomChart.series[0].setData(user_social);
        memberSheehanZoomChart.series[1].setData(user_work);
        memberSheehanZoomChart.series[2].setData(user_family);
    }

    if($('#observeeSheehanZoomChart').length > 0) {
        observeeSheehanZoomChart.series[0].setData(observed_social);
        observeeSheehanZoomChart.series[1].setData(observed_work);
        observeeSheehanZoomChart.series[2].setData(observed_family);
    }


    if($('#madrsdimChart').length > 0) {
        MADRSDimensionsChart.series[0].setData(user_appetite);
        MADRSDimensionsChart.series[1].setData(user_sleep);
        // MADRSDimensionsChart.series[2].setData(user_pessimism);
        MADRSDimensionsChart.series[2].setData(user_zest);
    }

    if($('#observeemadrsdimChart').length > 0) {
        observeemadrsdimChart.series[0].setData(observed_activity);
        observeemadrsdimChart.series[1].setData(observed_energy);
        observeemadrsdimChart.series[2].setData(observed_hyperactive);
        observeemadrsdimChart.series[3].setData(observed_zest);
    }

    if($('#observeesideffectsChart').length > 0) {
        observeesideffectsChart.series[0].setData(observed_delusional);
        observeesideffectsChart.series[1].setData(observed_hallucination);
        observeesideffectsChart.series[2].setData(observed_dangerous_behavior);
        observeesideffectsChart.series[3].setData(observed_substance_abuse);
    }

    if($('#addmadrsdimChart').length > 0) {
        additionalMadrsDimensionsChart.series[0].setData(user_anxiety);
        additionalMadrsDimensionsChart.series[1].setData(user_sleep);
        additionalMadrsDimensionsChart.series[2].setData(user_energy);
        additionalMadrsDimensionsChart.series[3].setData(user_concentration);
        additionalMadrsDimensionsChart.series[4].setData(user_mood_feelings);
    }
    if($('#symptomChart').length > 0) {
        symptomChart.series[0].setData(user_panic_attack);
        symptomChart.series[1].setData(user_suicide_thought);
        symptomChart.series[2].setData(user_headache);
        symptomChart.series[3].setData(user_restlessness);
        symptomChart.series[4].setData(user_nausea);

    }

    if($('#PatientMoodChart').length > 0) {
        PatientMoodChart.series[0].setData(all_mood_feelings);
        PatientMoodChart.series[1].setData(all_mood_feelings);
        PatientMoodChart.series[2].setData(all_mood_feelings);
    }

    if($('#weightChart').length > 0) {
        weightChart.series[0].setData(user_weight);
    }


}

//series: [, {
//    pointInterval: <%= 1.day * 1000 %>,
//        type: 'line',
//
//        name: "Everyone Else",
//        data: all_mood_feelings
//}]
