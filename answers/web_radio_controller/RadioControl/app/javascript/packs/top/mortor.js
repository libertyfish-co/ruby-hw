$(function() {
  $('#forward').on('click', function() {
    radioApi('forward')
  });

  $('#left').on('click', function() {
    radioApi('left')
  });

  $('#right').on('click', function() {
    radioApi('right')
  });

  $('#back').on('click', function() {
    radioApi('back')
  });

  $('#breake').on('click', function() {
    radioApi('breake')
  });
});
var mortorControls ={ArrowUp: false, ArrowLeft: false, ArrowRight: false, ArrowDown: false};

$(window).keydown(function(e){
  var code = e.code;
  if(!(code == 'ArrowUp' || code == 'ArrowLeft' || code == 'ArrowRight' || code == 'ArrowDown'))
  {
    return false;
  }

  if(mortorControls[code])
  {
    return false;
  }

  mortorControls[code] = true;

  console.log('keydown:' + code);

  switch (code) {
    case 'ArrowUp':
      radioApi('forward')
      break;
    case 'ArrowLeft':
      radioApi('left')
      break;
    case 'ArrowRight':
      radioApi('right')
      break;
    case 'ArrowDown':
      radioApi('back')
      break;
    default:
      break;
  }

  return true;
});

$(window).keyup(function(e){
  var code = e.code;
  console.log('keyup:' + code);
  mortorControls[code] = false;

  radioApi('breake')
  return true;
});

function radioApi(apiName)
{
  var url = '/mortor/' + apiName;
  $.ajax({
    url: url,
    type: 'GET',
    dataType: 'json',
    timeout: 5000,
  })
  .done(function(data) {
  })
  .fail(function() {
  });
}
