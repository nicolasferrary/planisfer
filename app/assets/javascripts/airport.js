var app = window.app = {};

app.Airports = function() {
  this._input = $('#airports-search-txt');
  this._initAutocomplete();
};

app.Airports.prototype = {

};


_initAutocomplete: function() {
  this._input
    .autocomplete({
      source: '/airports',
      appendTo: '#airports-search-results',
      select: $.proxy(this._select, this)
    })
    .autocomplete('instance')._renderItem = $.proxy(this._render, this);
}

_select: function(e, ui) {
  this._input.val(ui.item.name + ' - ' + ui.item.iata);
  return false;
}

_render: function(ul, item) {
  var markup = [
    '<span class="name">' + item.name + '</span>',
    '<span class="iata">' + item.iata + '</span>'p
  ];
  return $('<li>')
    .append(markup.join(''))
    .appendTo(ul);
}
