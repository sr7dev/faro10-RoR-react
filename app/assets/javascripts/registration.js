$(function() {
  $('#clinician_submit').prop('disabled', true);
  $('#member_submit').prop('disabled', true);
  $('#user_invitation_submit').prop('disabled', true);

  $("#clinician_is_clinician").attr('checked',false);
  $("#member_is_clinician").attr('checked',false);
  $("#user_is_clinician").attr('checked',false);


  $("#clinician_is_clinician").click(function() {
    if ($(this).prop('checked')) {
      $('#clinician_submit').prop('disabled', false);
    } else {
      $('#clinician_submit').prop('disabled', true);
    }
  });

  $("#member_is_clinician").click(function() {
    if ($(this).prop('checked')) {
      $('#member_submit').prop('disabled', false);
    } else {
      $('#member_submit').prop('disabled', true);
    }
  });

  $("#user_is_clinician").click(function() {
    if ($(this).prop('checked')) {
      $('#user_invitation_submit').prop('disabled', false);
    } else {
      $('#user_invitation_submit').prop('disabled', true);
    }
  });
});
