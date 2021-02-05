var options = {
  format: 'YYYY-MM-DD hh:mm A Z',
  inline: true,
  sideBySide: true
};

$(document).ready(function(){
  if ($('#appointment_start_time').length) {
    $('#appointment_start_time').datetimepicker(options);

    // when 2 datepickers, set min/max date based on the other

    // $('#appointment_end_time').datetimepicker(options);

    // $('#appointment_end_time').data("DateTimePicker").useCurrent(false);

    // $('#appointment_start_time').on("dp.change", function(e) {
    //   $('#appointment_end_time').data("DateTimePicker").minDate(e.date);
    // });
    // $('#appointment_end_time').on("dp.change", function(e) {
    //   $('#appointment_start_time').data("DateTimePicker").maxDate(e.date);
    // });
  }
});