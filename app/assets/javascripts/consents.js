function resizeCanvas(canvas) {
  var ratio =  Math.max(window.devicePixelRatio || 1, 1);
  canvas.width = canvas.offsetWidth * ratio;
  canvas.height = canvas.offsetHeight * ratio;
  canvas.getContext("2d").scale(ratio, ratio);
}

$(document).ready(function(){
  $('.accept-consent').click(function(){
    var membership_id = $(this).data('membership-id');
    var signatureCanvas = document.getElementById('signatureCanvas' + membership_id );

    if (signatureCanvas) {
      var signaturePad = new SignaturePad(signatureCanvas);
      window.addEventListener("resize", resizeCanvas);
      resizeCanvas(signatureCanvas);
      signaturePad.clear(); 
    }

    $('#newConsent' + membership_id).on('shown.bs.modal', function (e) {
      resizeCanvas(signatureCanvas);
      signaturePad.clear();
    });

    $('#accept_consent').click(function(event){
      if (signaturePad.isEmpty()){
        alert('You must sign the authorization to accept the clinician request.');
        event.preventDefault();
      } else {
        $('#consent_signature').val(signaturePad.toDataURL());
      }
    });
  });

  $('.renew-consent').click(function(){
    var membership_id = $(this).data('membership-id');
    var signatureCanvas = document.getElementById('signatureCanvas' + membership_id );

    if (signatureCanvas) {
      var signaturePad = new SignaturePad(signatureCanvas);
      window.addEventListener("resize", resizeCanvas);
      resizeCanvas(signatureCanvas);
      signaturePad.clear(); 
    }

    $('#renewConsent' + membership_id).on('shown.bs.modal', function (e) {
      resizeCanvas(signatureCanvas);
      signaturePad.clear();
    });

    $('#renew_consent').click(function(event){
      if (signaturePad.isEmpty()){
        alert('You must sign the authorization to accept the clinician request.');
        event.preventDefault();
      } else {
        $('#consent_signature').val(signaturePad.toDataURL());
      }
    });
  });
});
