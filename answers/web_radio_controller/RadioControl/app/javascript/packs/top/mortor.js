$(function() {
  $('#forward').on('click', function() {
    radioApi('Forward')
  });

  $('#left').on('click', function() {
    radioApi('Left')
  });

  $('#right').on('click', function() {
    radioApi('Right')
  });

  $('#back').on('click', function() {
    radioApi('Back')
  });

  $('#breake').on('click', function() {
    radioApi('Breake')
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
      radioApi('Forward')
      break;
    case 'ArrowLeft':
      radioApi('Left')
      break;
    case 'ArrowRight':
      radioApi('Right')
      break;
    case 'ArrowDown':
      radioApi('Back')
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

  radioApi('Breake')
  return true;
});

function radioApi(functionName)
{
  var url = '/mortor/control';
  $.ajax({
    url: url,
    type: 'POST',
    dataType: 'json',
    data : {control : functionName},
    timeout: 5000,
  })
  .done(function(data) {
      console.log(JSON.stringify(data));
  })
  .fail(function() {
  });
}
