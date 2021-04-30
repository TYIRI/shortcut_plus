$(function() {
  $(document).on('change', '#user_avatar', function() {
    var file = $(this).prop('files')[0];
    $('.selected-avatar').text(file.name);
  })
});