document.addEventListener("DOMContentLoaded", function(event) {
  var btn = document.getElementById('removeFlash');
  if (btn && btn.addEventListener) {
    // DOM2 standard
    btn.addEventListener('click', function() {
      btn.parentNode.remove();
      return false;
    }, false);
  }

  var dates = document.querySelectorAll("a.due-date");
  for (var i in dates) {
    if (dates[i] && dates[i].addEventListener) {
      dates[i].addEventListener('click', function() {
        console.log(this);
        document.querySelector("input[name=duedate]").value = this.innerHTML;
      }, false);
    }
  }
});
