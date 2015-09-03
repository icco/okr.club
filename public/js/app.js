document.addEventListener("DOMContentLoaded", function(event) {
  var btn = document.getElementById('removeFlash');
  if (btn.addEventListener) {
    // DOM2 standard
    btn.addEventListener('click', function() {
      btn.parentNode.remove();
      return false;
    }, false);
  }
});
