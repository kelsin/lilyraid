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

function fill_loot_with_location(item_name, item_url, location_id) {
    fill_loot(item_name, item_url);

    $('#loot_location_id').val(location_id);
}

function swap_loot() {
    var temp = $('#loot_item_url').attr('value');
    $('#loot_item_url').attr('value', $('#loot_item_name').attr('value'));
    $('#loot_item_name').attr('value', temp);
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
            $.delete_('/raids/' + raid_id + '/slots/' + slot_id, { authenticity_token: AUTH_TOKEN }, null, "script");
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

// Wowhead search
function wowhead_search(str) {
    str = str.replace(/^\s+|\s+$/g, '');

    if(str !== '') {
        $('#wowhead_search_loading_image').fadeIn();
        $.get('/wowhead/' + escape(str),'', function(data) {
            wowhead_items(data);
            $('#wowhead_search_loading_image').fadeOut(); }, 'json');
    }
}

function wowhead_items(data) {
    // Clear search box
    $('ul#wowhead_results').empty();
    
    var items = data[1];

    if (items.length > 0) {
        var meta = data[7];

        $.each(items, function(i, name) {
            var m = meta[i];

            // Check for an item
            if(m[0] === 3 && m[3] === 4) {
                // Found first item, fill out and quit
                item_name = name.replace(/ \(Item\)/, '');
                item_url = 'http://www.wowhead.com/?item=' + m[1];

                dd = $('<li><a href="' + item_url + '" onclick="fill_loot(unescape(\'' + escape(item_name) + '\'), unescape(\'' + escape(item_url) + '\')); return false;">' + item_name + '</a></li>');

                $('ul#wowhead_results').append(dd);
            }
        });
    }
}

function wowhead_pull() {
    $('#wowhead_search').val($('#loot_item_name').val());

    if($('#loot_item_name').val() !== '') {
        $('#wowhead_search').change();
    }
}

function raid_edit_slots(ele) {
    if($(ele).val() === '') {
        $('select.slot_select').removeAttr('disabled');
    } else {
        $('select.slot_select').attr('disabled', 'disabled');
    }
}

$(function () {
    // Wow Heroes Lookup
    $('dd > span.character').live('dblclick', function() { window.open('http://www.wowarmory.com/character-sheet.xml?r=Bronzebeard&n=' + $(this).text(), '_blank'); });

    // Hide hidden logs
    $('tr.log.hidden').hide();
    $('tr.log.shown').last().after($('<tr><td colspan="6"><a id="more_logs" href="#">Show More Logs ...</a></td></tr>'));
    $('#more_logs').click(function() {
        if($('tr.log.hidden').is(':visible')) {
            $(this).html('Show More Logs ...');
        } else {
            $(this).html('Hide Logs ...');
        }
        $('tr.log.hidden').toggle();
        return false;
    });

    $('dd#tags td span.stat').hide();
    $('dd#tags td span.stat.seated').show();
    $('#tag_select').change(function() {
        $('dd#tags td span.stat').hide();
        $('dd#tags td span.stat.' + $(this).val()).show();
    });

    $('#caltime').timepicker({ timeSeparator: ":", showPeriod: true });
});

