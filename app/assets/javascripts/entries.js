function updateSliderVal(attr, val) {
    if (val == -1 || val === undefined) {
        $('#' + attr + '-val').text("");
    } else {
        $('#' + attr + '-val').text(val);
    }
}
