(function($){
    $.fn.lilydate = function(format) {
        if(format === undefined) {
            format = 'ddd MMM d yyyy HH:mm:ss' }

        function select(type, value) {
            $('#lilydate_' + type + ' .selected').removeClass('selected');
            $('#lilydate_' + type + '_' + value).addClass('selected');
        }

        function build_field(field) {
            return $('<div id="lilydate_' + field + '" class="lilydate_field"></div>');
        }

        function build_button(field, value, label) {
            return $('<div id="lilydate_' + field + '_' + value + '" class="lilydate_button" data-' + field + '="' + value + '">' + label + '</div>');
        }

        return this.each(function() {
            var $input = $(this);
            var $container = null;

            $input.addClass('lilydate');

            // Date info
            var date = Date.parse($input.val());
            if(date === null) {
                date = new Date();
                $input.val(date.toString(format));
            }
            var original_date = date.clone();

            function select_date() {
                select('year', date.getFullYear());
                select('month', date.getMonth());
                select('day', date.getDate());
                select('hours', parseInt(date.toString('h')));
                select('minutes', Math.floor(date.getMinutes()/15) * 15);
                select('ampm', date.toString('tt'));
            }

            function build_year(center_year) {
                var year = date.getFullYear();
                if(center_year === undefined) { center_year = year; }
                var $year = build_field('year');
                var $prev = build_button('year', 'prev', '<<');
                var $next = build_button('year', 'next', '>>');

                $year.append($prev);
                for(i=-2; i <= 2; i++) {
                    var i_year = center_year + i;
                    var $year_div = build_button('year', i_year, i_year);
                    if (i_year == year) { $year_div.addClass('selected'); }

                    $year_div.click(function() {
                        var year = $(this).data('year');
                        select('year', year);
                        date.setYear(year);
                        update_day();
                    });

                    $year.append($year_div);
                }
                $year.append($next);

                function recenter_year(center) {
                    $('#lilydate_year').replaceWith(build_year(center));
                }

                // Next and Prev Buttons
                $next.addClass('ui');
                $prev.addClass('ui');
                $next.click(function() { recenter_year(center_year + 1); });
                $prev.click(function() { recenter_year(center_year - 1); });

                return $year;
            }

            function build_month() {
                var month = date.getMonth();

                var $month = build_field('month');
                for(i=0; i < 12; i++) {
                    var month_str = new Date().moveToMonth(i).toString('MMM');

                    var $month_div = build_button('month', i, month_str);
                    if (i == month) { $month_div.addClass('selected'); }

                    $month_div.click(function() {
                        var month = $(this).data('month');
                        var days_in_month = Date.getDaysInMonth(date.getFullYear(), month);
                        select('month', month);
                        date.setMonth(month, Math.min(date.getDate(), days_in_month));
                        update_day();
                    });

                    $month.append($month_div);
                }
                return $month;
            }

            function build_day() {
                var day = date.getDate();
                var days_in_month = Date.getDaysInMonth(date.getFullYear(), date.getMonth());

                if (day > days_in_month) { day = days_in_month }

                var $day = build_field('day');
                for(i=1; i <= days_in_month; i++) {
                    var $day_div = build_button('day', i, i);
                    if (i == day) { $day_div.addClass('selected'); }

                    $day_div.click(function() {
                        var day = $(this).data('day');
                        select('day', day);
                        date.setDate(day);
                    });

                    $day.append($day_div);
                }
                return $day;
            }

            function update_day() {
                $('#lilydate_day').replaceWith(build_day());
            }

            function build_hours() {
                var hours = parseInt(date.toString('h'));
                var $hours = build_field('hours');
                for(i=1; i <= 12; i++) {
                    var $hours_div = build_button('hours', i, i);
                    if (i == hours) { $hours_div.addClass('selected'); }

                    $hours_div.click(function() {
                        var hours = $(this).data('hours');
                        select('hours', hours);
                        date.setHours(hours);
                    });

                    $hours.append($hours_div);
                }
                return $hours;
            }

            function build_minutes() {
                var minutes = date.getMinutes();
                var $minutes = build_field('minutes');
                for(i=0; i < 60; i += 15) {
                    var $minutes_div = build_button('minutes', i, i);
                    if (i < minutes) { $minutes.find('div').removeClass('selected'); $minutes_div.addClass('selected'); }

                    $minutes_div.click(function() {
                        var minutes = $(this).data('minutes');
                        select('minutes', minutes);
                        date.setMinutes(minutes);
                    });

                    $minutes.append($minutes_div);
                }
                return $minutes;
            }

            function build_ampm() {
                var $ampm = build_field('ampm');
                var $am_div = build_button('ampm', 'AM', 'AM');
                var $pm_div = build_button('ampm', 'PM', 'PM');
                if (date.toString('tt') == 'AM') {
                    $am_div.addClass('selected');
                } else {
                    $pm_div.addClass('selected');
                }

                $am_div.click(function() {
                    var hours = date.getHours();
                    select('ampm', 'AM');
                    if(hours > 11) { date.addHours(12); }
                });

                $pm_div.click(function() {
                    var hours = date.getHours();
                    select('ampm', 'PM');
                    if(hours < 12) { date.addHours(-12); }
                });

                $ampm.append($am_div);
                $ampm.append($pm_div);
                return $ampm;
            }

            function build_container() {
                var doc_height = $(document).height();

                $('#lilydate_container').remove();
                $container = $('<div id="lilydate_container"></div>');
                $container.append('<input type="button" id="lilydate_yesterday" value="Yesterday" />');
                $container.append('<input type="button" id="lilydate_today" value="Today" />');
                $container.append('<input type="button" id="lilydate_tomorrow" value="Tomorrow" />');
                $container.append('<input type="button" id="lilydate_next_week" value="Next Week" />');
                $container.append('<h2>Date</h2>');
                $container.append(build_year());
                $container.append(build_month());
                $container.append(build_day());
                $container.append('<h2>Time</h2>');
                $container.append(build_hours());
                $container.append(build_minutes());
                $container.append(build_ampm());
                $container.append('<input type="button" id="lilydate_submit" value="Ok" />');
                $container.append('<input type="button" id="lilydate_cancel" value="Cancel" />');

                var offset = $input.offset();

                $('body').append($container);

                var $container = $('#lilydate_container');
                $container.css('top', offset.top + 'px').css('left', offset.left + 'px');

                var max_height = doc_height - $container.outerHeight(true);

                if($container.position().top > max_height) {
                    $container.css('top', max_height + 'px');
                }

                $('#lilydate_submit').click(function() { submit(); });
                $('#lilydate_cancel').click(function() { cancel(); });

                $('#lilydate_yesterday').click(function() { date = Date.now().addDays(-1); select_date(); });
                $('#lilydate_today').click(function() { date = Date.now(); select_date(); });
                $('#lilydate_tomorrow').click(function() { date = Date.now().addDays(1); select_date(); });
                $('#lilydate_next_week').click(function() { date = Date.now().addDays(7); select_date(); });
            }

            function cancel() {
                date = original_date.clone();
                $input.val(date.toString(format));
                $('#lilydate_container').remove();
                $input.show();
            }

            function submit() {
                $input.val(date.toString(format));
                original_date = date.clone();
                $('#lilydate_container').remove();
                $input.change();
                // $input.show();
            }

            $input.focus(function() {
                build_container();
                // $input.hide();
            });
        });
    };
})(jQuery);
