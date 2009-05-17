// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function _ajax_request(url, data, callback, type, method) {
    if (jQuery.isFunction(data)) {
        callback = data;
        data = {};
    }
    return jQuery.ajax({
        type: method,
        url: url,
        data: data,
        success: callback,
        dataType: type
    });
}

jQuery.extend({
    put: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'PUT');
    },
    delete_: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'DELETE');
    }
});

// Form default helpers
function field_focus(ele) {
    if(ele.value == ele.defaultValue) {
        ele.value = '';
        $(ele).removeClass('dim');
    }
}

function field_blur(ele) {
    if(ele.value == '') {
        ele.value = ele.defaultValue;
        $(ele).addClass('dim');
    }
}

function fill_loot(item_name, item_url) {
    $('#loot_item_name').attr('value', item_name);
    $('#loot_item_url').attr('value', item_url);

    if(item_name == '') {
        field_blur($('#loot_item_name').get(0));
        field_blur($('#loot_item_url').get(0));
    } else {
        $('#loot_item_name, #loot_item_url').removeClass('dim');
    }
}        

// Seating
function make_signup(ele) {
    $(ele).draggable({ helper: 'clone',
                       opacity: 0.5,
                       revert: false,
                       revertDuration: 250,
                       scope: 'signups',
                       zIndex: 5 });
}

function make_slot(ele, accepts) {
    $(ele).droppable({ hoverClass: 'hovering',
                       scope: 'signups',
                       accept: accepts,
                       drop: signup_dropped });
}

function signup_dropped(event, ui) {
    // Now check what we're doing
    if(this.id == 'waiting_list') {
        if(ui.draggable.hasClass('slot')) {
            slot_id = ui.draggable.attr('id').replace(/^slot_/, '');
            $.delete_('/raids/' + raid_id + '/slots/' + slot_id, {}, null, "script");
        }
    } else {
        if(ui.draggable.hasClass('slot')) {
            from_slot_id = ui.draggable.attr('id').replace(/^slot_/, '');
            data = { from_slot_id: from_slot_id, _method: 'put', authenticity_token: AUTH_TOKEN };
        } else {
            from_signup_id = ui.draggable.attr('id').replace(/^signup_/, '');
            data = { from_signup_id: from_signup_id, _method: 'put', authenticity_token: AUTH_TOKEN };
        }

        slot_id = this.id.replace(/^slot/, '');
        $.put('/raids/' + raid_id + '/slots/' + slot_id, data, null, "script");
    }
}

// Ajax Calls
function character_roles(ele, place) {
    $(place).html('<img src="/images/loading.gif">');
    $(place).load('/roles/' + ele.value);
}

// Validation
function validate_loot() {
    if($('#loot_item_name').attr('value') == 'Name' || $('#loot_item_url').attr('value') == 'URL') {
        alert('Please fill out the loot form before submitting');
        return false;
    } else if($('#loot_character_id').attr('value') == '') {
        alert('A character must be seated and selected before you can assign loot');
        return false;
    } else {
        return confirm('Are you sure you wish to assign loot?');
    }
}
