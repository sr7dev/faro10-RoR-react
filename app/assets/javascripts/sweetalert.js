$(function () {
    $('.sweet_delete').on('.filelink' ).click( function( e ) {

        e.preventDefault();

        //save the url of the <a> tag that  was clicked.
        var url = $(this).attr("/members/observers/#{observation.id}");

        var $self = $(this);

        swal({
            title: "Are you sure?",
            text: "Please confirm you wish to delete this Observer",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Yes, delete it!",
            closeOnConfirm: true
        }, function (isConfirm) {

            if (isConfirm)
            {
                //append a hidden frame and point it to the url of the <a> tag that was clicked.
                //$('<iframe src="'+url+'" style="position:absolute;left=-1000em;"></iframe>').appendTo('body'
                //$('.delete').trigger('click', {});
                console.log('confirmed');
                $self.unbind('click').click();
                swal("Deleted!", "This observer has been removed.", "success");
            }
            else
            {
                swal("Cancelled", "This observer has not been removed :)", "error");
            }
        });
        return false;
    });
});

$(document).ready(function () {

    $('.sweet_delete_clinician').on('.filelink' ).click( function( e ) {

        e.preventDefault();

        //save the url of the <a> tag that  was clicked.
        var url = $(this).attr("/clinicians/members/#{clinician.id}");

        var $self = $(this);

        swal({
            title: "Are you sure?",
            text: "Please confirm you wish to remove this Clinician",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Yes, remove it!",
            closeOnConfirm: true
        }, function (isConfirm) {

            if (isConfirm)
            {
                //append a hidden frame and point it to the url of the <a> tag that was clicked.
                //$('<iframe src="'+url+'" style="position:absolute;left=-1000em;"></iframe>').appendTo('body'
                //$('.delete').trigger('click', {});
                console.log('confirmed');
                $self.unbind('click').click();
                swal("Deleted!", "This Clinician has been removed.", "success");
            }
            else
            {
                swal("Cancelled", "This Clinician has not been removed :)", "error");
            }
        });
        return false;
    });
});

$(document).ready(function () {

    $('.sweet_delete_patient').on('.filelink' ).click( function( e ) {

        e.preventDefault();

        //save the url of the <a> tag that  was clicked.
        var url = $(this).attr("/clinicians/members/#{member.id}");

        var $self = $(this);

        swal({
            title: "Are you sure?",
            text: "Please confirm you wish to remove this Patient",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Yes, remove it!",
            closeOnConfirm: true
        }, function (isConfirm) {

            if (isConfirm)
            {
                //append a hidden frame and point it to the url of the <a> tag that was clicked.
                //$('<iframe src="'+url+'" style="position:absolute;left=-1000em;"></iframe>').appendTo('body'
                //$('.delete').trigger('click', {});
                console.log('confirmed');
                $self.unbind('click').click();
                swal("Deleted!", "This patient has been removed.", "success");
            }
            else
            {
                swal("Cancelled", "This patient has not been removed :)", "error");
            }
        });
        return false;
    });
});

$(document).ready(function () {

    $('.sweet_delete_observe').on('.filelink' ).click( function( e ) {

        e.preventDefault();

        //save the url of the <a> tag that  was clicked.
        var url = $(this).attr("/clinicians/members/#{member.id}");

        var $self = $(this);

        swal({
            title: "Are you sure?",
            text: "Please confirm you wish to stop observing this person",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Yes, remove it!",
            closeOnConfirm: true
        }, function (isConfirm) {

            if (isConfirm)
            {
                //append a hidden frame and point it to the url of the <a> tag that was clicked.
                //$('<iframe src="'+url+'" style="position:absolute;left=-1000em;"></iframe>').appendTo('body'
                //$('.delete').trigger('click', {});
                console.log('confirmed');
                $self.unbind('click').click();
                swal("Deleted!", "This Observer has been removed.", "success");
            }
            else
            {
                swal("Cancelled", "This Observer has not been removed :)", "error");
            }
        });
        return false;
    });
});