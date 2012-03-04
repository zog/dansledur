// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require fb
//= require_tree .

$(document).ready(function(){
  if($('#next_page')[0]){
    shortcut.add("N",function() {
      document.location = $('#next_page')[0].href
    });
  }
  if($('#prev_page')[0]){
    shortcut.add("P",function() {
      document.location = $('#prev_page')[0].href
    });
  }
})

