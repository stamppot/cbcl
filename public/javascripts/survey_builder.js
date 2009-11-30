
function no_rows()
{
  var rows = $$("tr.row");
  alert("No. rows: " + rows.length);
}

function delete_question_row()
{
  var rows = $$("tr.row");  
  if(rows.length == 1) {
    alert("Cannot delete last row");
    return;
  }
  var rowsno = rows.length;
  var lastrow = rows.last();
  Element.remove(lastrow);
  var rowsno = $$("tr.row");
}

/* returns new row id, works in IE! */
function add_question_row()
{
  var rows = $$("tr.row");
  var rowsno = rows.length+1;
  var rowid = "row"+rows.length.toString();
  var newid = "row" + rowsno;
  var lastrow = rows.last();
  var tablerow = "<tr class='row' id='row" + rowsno + "'>";
  new Insertion.After(rowid, tablerow + increment_row_id(increment_item_number(lastrow.innerHTML.toString()) + "</tr>", rowsno));
  var row = $(newid);
  return newid;
}

function add_question_column()
{ /* each row, getTableCells, insert cell after last */
  var rows = $$("tr.row");
  var newcell = "cell1_1";
  rows.each(function(row, index) { 
    var tdcells = $('row'+(index+1)).getElementsByClassName('cell');
    var cellsno = tdcells.length;
    var lasttd = tdcells[cellsno-1];
    newcell = "cell"+(index+1)+"_"+(cellsno+1);
    var tdcell = "<td class='cell' id='"+newcell+"'>";
    new Insertion.After(lasttd.id, tdcell + increment_col_id(lasttd.innerHTML, cellsno) + "</td>");
  });
  return newcell;
}

function delete_question_column()
{
  var rows = $$("tr.row");
/*  if( $('row1').getElementsByClassName('cell').length == 1) {
    alert("Cannot delete last column");
    return;
  }*/
  rows.each(function(row, index) { 
    var tdcells = $('row'+(index+1)).getElementsByClassName('cell');
    if( tdcells.length == 1) {
      alert("Cannot delete last column");
      throw $break;
    }
    var lastcell = tdcells[tdcells.length-1];
    lastcell.remove();
  });
}

function increment_row_id(tabledata, n)
{ /* match celln_m, increment n. match rown, increment n. Match both twice */
  /* replace n's */
//  alert("increment_row_id to: " + n);
  tabledata = tabledata.gsub(/cell[0-9]+/, ("cell"+n));
  tabledata = tabledata.gsub(/row[0-9]+/, ("row"+n));  // changed from ' to "
  return tabledata;
}

function increment_item_number(arg)
{ // id='cell1_0'>1</td>     id="item4"
  var re = /item([0-9]+)/;    //cell[0-9]+_[0-9]+(\D)*([0-9]+)/;
  var matches = arg.match(re);
  var val = /value=.?([0-9]+)([a-z]*)/;   // value="1"
  var matchval = arg.match(val);
  if(matchval == null)
      return arg;

  // cut off end matching only numbers
  var rep = matches[0].replace(/[0-9]+$/,"");  // id="item9"
//  alert("rep: " + rep);
  var rep = rep.replace(/\"/, "");
//  alert("rep2: " + rep);
  var newrow = arg.sub(re, rep + (parseInt(matches[1])+1)); // + "'");  // replace item
//  alert("newrow " + newrow);   // \"" gives rise to bug when deleting text and then add row (IE)
  var newrow1 = newrow.sub(val, "value=\"" + (parseInt(matchval[1])+1) + "\"");  // replace value
//  alert("newrow1: " + newrow1);
  return newrow1;
}

function increment_col_id(tabledata, n)
{ /* match cellm_n, increment n. match coln, increment n. Match both twice */
  /* replace n's */
  var cell = new String(tabledata.match(/cell[0-9]+_[0-9]+/));
  var inc = n+1;
  var row = (new String(cell.match(/cell[0-9]+/)).gsub(/cell/,''));
  var newcell = new String('cell'+row+'_'+inc);
  tabledata = tabledata.gsub(/cell[0-9]+_[0-9]+/, newcell);
  tabledata = tabledata.gsub(/col[0-9]+/, 'col'+inc);
  return tabledata;
}
