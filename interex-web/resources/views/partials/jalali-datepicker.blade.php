{{-- Locale-aware Jalali (Shamsi) date picker.
     Only active when the application locale is Persian ("fa").
     It turns native <input type="date"> fields into a Jalali date picker for the
     user, while still submitting a Gregorian (Y-m-d) value to the server, so no
     controller/validation changes are required. Opt out on a field with class
     "no-jalali". --}}
@if (app()->getLocale() === 'fa')
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@majidh1/jalalidatepicker/dist/jalalidatepicker.min.css">
    <script src="https://cdn.jsdelivr.net/npm/@majidh1/jalalidatepicker/dist/jalalidatepicker.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/moment@2.30.1/moment.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/moment-jalaali@0.10.4/build/moment-jalaali.js"></script>
    <script>
        (function () {
            if (typeof moment === 'undefined' || typeof jalaliDatepicker === 'undefined') {
                return;
            }

            var GREG = 'YYYY-MM-DD';
            var JAL = 'jYYYY/jMM/jDD';

            function gregToJalali(value) {
                if (!value) return '';
                var m = moment(value, GREG, true);
                if (!m.isValid()) m = moment(value);
                return m.isValid() ? m.format(JAL) : '';
            }

            function jalaliToGreg(value) {
                if (!value) return '';
                var m = moment(value, JAL, true);
                return m.isValid() ? m.format(GREG) : '';
            }

            function enhance(input) {
                if (input.dataset.jalaliReady) return;
                if (input.readOnly || input.disabled) return;
                if (input.classList.contains('no-jalali')) return;
                input.dataset.jalaliReady = '1';

                // Hidden field keeps the original name and submits a Gregorian value.
                var hidden = document.createElement('input');
                hidden.type = 'hidden';
                hidden.name = input.getAttribute('name') || '';
                hidden.value = input.value || '';
                input.removeAttribute('name');

                // Turn the original field into a Jalali text picker.
                input.type = 'text';
                input.setAttribute('autocomplete', 'off');
                input.setAttribute('data-jdp', '');
                input.value = gregToJalali(hidden.value);
                input.parentNode.insertBefore(hidden, input.nextSibling);

                var sync = function () {
                    hidden.value = jalaliToGreg(input.value);
                };
                input.addEventListener('change', sync);
                input.addEventListener('jdp:change', sync);
                input.addEventListener('blur', sync);
            }

            document.addEventListener('DOMContentLoaded', function () {
                document.querySelectorAll('input[type="date"]').forEach(enhance);
                if (jalaliDatepicker && jalaliDatepicker.startWatch) {
                    jalaliDatepicker.startWatch({ time: false, persianDigit: false, autoHide: true, hideAfterChange: true });
                }
            });
        })();
    </script>
@endif
