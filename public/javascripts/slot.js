function choose_char(select) {
    var selects = $$('select.char_select');
    for(var i=0; i < selects.length; i++) {
        if(selects[i] != select && selects[i].value == select.value) {
            selects[i].value = "";
        }
    }
}

function get_selected_slot() {
    var id = $$('td.slot.selected')[0].id;

    return '' + id.replace(/^td_slot_/,'');
}

function get_selected_url() {
    var id = $$('td.selected')[0].id; 
    
    if(id.match(/signup_/)) {
        return 'from_signup_id=' + id.replace(/^td_signup_/,'');
    } else if(id.match(/slot_/)) {
        return 'from_slot_id=' + id.replace(/^td_slot_/,'');
    } else {
        return '';
    }
}
    
function list_display(cclass_name, checked) {
    eles = $$('tr.' + cclass_name);
    for(var i=0; i < eles.length; i++) {
        ele = eles[i];
        if (checked) {
            ele.show();
        } else {
            ele.hide();
        }
    }
}
