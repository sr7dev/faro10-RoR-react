function renderSocialsData(data) {
    posts = data["posts"];

    $('#user_posting').html(posts["two_week_rolling_average"]);
    console.log("Got a successful response. Data:", data);
    postings = posts["two_week_rolling_average"];
}

//series: [, {
//    pointInterval: <%= 1.day * 1000 %>,
//        type: 'line',
//
//        name: "Everyone Else",
//        data: all_mood_feelings
//}]
