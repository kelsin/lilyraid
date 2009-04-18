// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
    var assign_type = null;
    var assign_id = null;
});

function select_slot(id) {
    $("td.selected:not(#td_slot_" + id + ")").removeClass("selected");

    if($("td#td_slot_" + id).hasClass("selected")) {
        $("td#td_slot_" + id).removeClass("selected");
        assign_type = null;
        assign_id = null;
    } else {
        $("td#td_slot_" + id).addClass("selected");
        assign_type = 'slot';
        assign_id = id;
    }
}

function assign_slot(id) {
    if(assign_type && assign_id) {
        alert('Assigning');
    }
}
