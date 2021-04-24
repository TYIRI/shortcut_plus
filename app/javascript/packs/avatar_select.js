$(function() {
    $('#user_avatar').on('change', function () {
    var file = $(this).prop('files')[0];
    $('.selected-avatar').text(file.name);
  });
});