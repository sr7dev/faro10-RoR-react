//= require jquery
//= require jquery_ujs
//= require jquery.readyselector
//= require moment
//= require bootstrap
//= require bootstrap-datepicker/core
//= require bootstrap-datetimepicker
//= require cocoon
//= require modernizr
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require highcharts
//= require signature_pad
//= require sweet-alert
//= require select2
//= require twilio-video
//= require_tree .

// Profile Page JS
$(function() {
    $("div.bhoechie-tab-menu>div.list-group>a").click(function(e) {
        e.preventDefault();
        $(this).siblings('a.active').removeClass("active");
        $(this).addClass("active");
        var index = $(this).index();
        $("div.bhoechie-tab>div.bhoechie-tab-content").removeClass("active");
        $("div.bhoechie-tab>div.bhoechie-tab-content").eq(index).addClass("active");
    });
});
// END Profile Page JS


// SIDE BAR for Chart Filter

$(function () {
    $('.input-daterange').datepicker({todayHighlight: true});

    $('.navbar-toggle-sidebar').click(function () {
        $('.navbar-nav').toggleClass('slide-in');
        $('.side-body').toggleClass('body-slide-in');
        $('#search').removeClass('in').addClass('collapse').slideUp(200);
    });

    $('#search-trigger').click(function () {
        $('.navbar-nav').removeClass('slide-in');
        $('.side-body').removeClass('body-slide-in');
        $('.search-input').focus();
    });
});

// END OF SIDE BAR for Chart Filter

// When the DOM is ready, run this function... this is for the Quote Carousel in static_pages/endorsements ....  (document).ready

//$(function() {
//    //Set the carousel options
//    if($('#quote-carousel').length > 0) {
//        //Import Carousel Library Code
//        $('#quote-carousel').carousel({
//            pause: true,
//            interval: 4000
//        });
//    }
//});
// End of Quote Carousel in static_pages/endorsements


$(function() {
    $(".audioButton1").on("click", function () {
        $(".audio-play")[0].currentTime = 0;
        return $(".audio-play")[0].play();
    });
});

$(function() {
    $(".audioButton2").on("click", function () {
        $(".audio-play")[1].currentTime = 0;
        return $(".audio-play")[1].play();
    });
});

$(function() {

    //
    //if($.fn.dataTableExt !== undefined) {
    //  $.extend( $.fn.dataTableExt.oStdClasses, {
    //    "sSortAsc": "header headerSortDown",
    //    "sSortDesc": "header headerSortUp",
    //    "sSortable": "header"
    //  } );
    //}

    if($('#messageCenter').length > 0) {
        $('#messageCenter').dataTable({
            "sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
            "bPaginate":true,
            "sPaginationType":"ellipses",
            "iDisplayLength": 6,
            "responsive": true,
            "bScrollCollapse": true
        });
    }

    if($('#observer_entries_td').length > 0) {
        $('#observer_entries_td').dataTable({
            "bPaginate":true,
            "sPaginationType":"ellipses",
            "iDisplayLength": 10,
            "responsive": true,
            "bScrollCollapse": true
        });
    }

    if($('#clinician_entry_table').length > 0) {
        $('#clinician_entry_table').dataTable({
            "bPaginate":true,
            "sPaginationType":"ellipses",
            "iDisplayLength": 6,
            "responsive": true,
            "bScrollCollapse": true
        });
    }

    if($('#patient_exercises').length > 0) {
        $('#patient_exercises').dataTable({
            "bPaginate":true,
            "sPaginationType":"ellipses",
            "iDisplayLength": 10,
            "responsive": true,
            "bScrollCollapse": true
        });
    }

    if($('#meetingsInprogressTable').length > 0) {
        $('#meetingsInprogressTable').dataTable({
            "bPaginate":true,
            "sPaginationType":"ellipses",
            "iDisplayLength": 10,
            "responsive": true,
            "bScrollCollapse": true
        });
    }

    if($('#meetingsWaitingTable').length > 0) {
        $('#meetingsWaitingTable').dataTable({
            "bPaginate":true,
            "sPaginationType":"ellipses",
            "iDisplayLength": 10,
            "responsive": true,
            "bScrollCollapse": true
        });
    }

    if($('#meetingsScheduledTable').length > 0) {
        $('#meetingsScheduledTable').dataTable({
            "bPaginate":true,
            "sPaginationType":"ellipses",
            "iDisplayLength": 10,
            "responsive": true,
            "bScrollCollapse": true
        });
    }


    if($('#meetingsCompletedTable').length > 0) {
        $('#meetingsCompletedTable').dataTable({
            "bPaginate":true,
            "sPaginationType":"ellipses",
            "iDisplayLength": 10,
            "responsive": true,
            "bScrollCollapse": true
        });
    }


    if($('#user_completed_exercises').length > 0) {
        $('#user_completed_exercises').dataTable({
            "bPaginate":true,
            "sPaginationType":"ellipses",
            "iDisplayLength": 6,
            "responsive": true,
            "bScrollCollapse": true
        });
    }

    if($('#patients').length > 0) {
        // $('#patients').dataTable({
        //     "bPaginate":true,
        //     "sPaginationType":"ellipses",
        //     "iDisplayLength": 10,
        //     "responsive": true,
        //     "bScrollCollapse": true
        // });
    }

});

$(function() {
    $("#member_diagnosis").select2({
        theme: "bootstrap"
    });

    $("#dsm5-select").select2({
        theme: "bootstrap",
        width: "100%",
        placeholder: "Type to search DSM...",
        minimumInputLength: 3,
        ajax: {
            url: "/search-dsm5",
            dataType: "json",
            processResults: function(data) {
                return { results: $.map( data, function(mc) {
                    return { "id": mc.id, "text": mc.dsm_code + " : " + mc.short_description }
                })}
            }
        },
    });

    $("#icd10-select").select2({
        theme: "bootstrap",
        width: "100%",
        placeholder: "Type to search ICD...",
        minimumInputLength: 3,
        ajax: {
            url: "/search-icd10",
            dataType: "json",
            processResults: function(data) {
                return { results: $.map( data, function(mc) {
                    return { "id": mc.id, "text": mc.icd10_code + " : " + mc.short_description }
                })}
            }
        },
    });
})

$(document).ready( function() {
    $('#myCarousel').carousel({

        interval:   100000
    });

    var clickEvent = false;
    $('#myCarousel').on('click', '.nav a', function() {
        clickEvent = true;
        $('.nav li').removeClass('active');
        $(this).parent().addClass('active');
    }).on('slid.bs.carousel', function(e) {
        if(!clickEvent) {
            var count = $('.nav').children().length -1;
            var current = $('.nav li.active');
            current.removeClass('active').next().addClass('active');
            var id = parseInt(current.data('slide-to'));
            if(count == id) {
                $('.nav li').first().addClass('active');
            }
        }
        clickEvent = false;
    });
});

Highcharts.theme = {
    colors: ['#4FA59F','#F19A20','#CC246F','#B4D336','#8CD2CB','#DFF0E7','#326867']

};

// Apply the theme
Highcharts.setOptions(Highcharts.theme);
