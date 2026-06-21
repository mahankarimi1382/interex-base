{{-- Enhanced KYC document upload field: live preview, upload progress % and success icon.
     Expects: $item (kyc field with ->name and ->label) --}}
<div class="col-xl-6 col-lg-6 col-md-4 form-group">
    <div class="kyc-file-field">
        <label class="kyc-file-label" for="kyc-file-{{ $item->name }}">{{ __($item->label) }}</label>
        <div class="kyc-file-drop">
            <input type="file" class="kyc-file-input" id="kyc-file-{{ $item->name }}"
                   name="{{ $item->name }}" accept="image/*">
            <div class="kyc-file-placeholder">
                <i class="fas fa-cloud-upload-alt"></i>
                <span class="kyc-file-placeholder-text">{{ __("Click or drag a file to upload") }}</span>
            </div>
            <div class="kyc-file-preview">
                <img src="" alt="" class="kyc-file-img">
                <span class="kyc-file-doc"><i class="fas fa-file-alt"></i><span class="kyc-file-name"></span></span>
                <span class="kyc-file-success" title="{{ __('Uploaded') }}"><i class="fas fa-check-circle"></i></span>
                <button type="button" class="kyc-file-remove" aria-label="{{ __('Remove') }}"><i class="fas fa-times"></i></button>
            </div>
        </div>
        <div class="kyc-file-progress">
            <div class="kyc-file-progress-bar"><span></span></div>
            <small class="kyc-file-progress-text">0%</small>
        </div>
    </div>
    @error($item->name)
        <span class="invalid-feedback d-block" role="alert"><strong>{{ $message }}</strong></span>
    @enderror
</div>

@once
@push('css')
<style>
    .kyc-file-field { width: 100%; }
    .kyc-file-label { display: block; margin-bottom: 6px; font-weight: 500; }
    .kyc-file-drop {
        position: relative; display: flex; align-items: center; justify-content: center;
        min-height: 120px; padding: 12px; border: 2px dashed #c9ced6; border-radius: 10px;
        background: #f8f9fb; cursor: pointer; text-align: center;
        transition: border-color .2s ease, background .2s ease;
    }
    .kyc-file-drop:hover, .kyc-file-drop.is-dragover { border-color: #5b6be8; background: #eef0ff; }
    .kyc-file-drop.has-file { border-style: solid; border-color: #28a745; background: #fff; }
    .kyc-file-input { position: absolute; inset: 0; width: 100%; height: 100%; opacity: 0; cursor: pointer; z-index: 1; }
    .kyc-file-placeholder { color: #8a94a6; pointer-events: none; }
    .kyc-file-placeholder i { font-size: 28px; display: block; margin-bottom: 6px; }
    .kyc-file-preview { display: none; position: relative; width: 100%; align-items: center; justify-content: center; gap: 10px; }
    .kyc-file-drop.has-file .kyc-file-placeholder { display: none; }
    .kyc-file-drop.has-file .kyc-file-preview { display: flex; }
    .kyc-file-img { max-height: 120px; max-width: 100%; border-radius: 8px; object-fit: contain; }
    .kyc-file-doc { display: none; flex-direction: column; align-items: center; color: #5b6be8; }
    .kyc-file-doc i { font-size: 34px; margin-bottom: 6px; }
    .kyc-file-doc .kyc-file-name { font-size: 12px; word-break: break-all; max-width: 160px; }
    .kyc-file-drop.is-doc .kyc-file-img { display: none; }
    .kyc-file-drop.is-doc .kyc-file-doc { display: flex; }
    .kyc-file-success {
        position: absolute; top: -8px; right: -8px; width: 24px; height: 24px; line-height: 24px;
        background: #28a745; color: #fff; border-radius: 50%; font-size: 14px; display: none; z-index: 2;
    }
    .kyc-file-drop.is-done .kyc-file-success { display: inline-block; }
    .kyc-file-remove {
        position: absolute; top: -8px; left: -8px; width: 24px; height: 24px; padding: 0;
        background: #dc3545; color: #fff; border: none; border-radius: 50%; font-size: 12px;
        cursor: pointer; display: none; z-index: 2;
    }
    .kyc-file-drop.has-file .kyc-file-remove { display: inline-block; }
    .kyc-file-progress { display: none; margin-top: 8px; }
    .kyc-file-progress.is-active { display: block; }
    .kyc-file-progress-bar { height: 6px; width: 100%; background: #e9ecef; border-radius: 4px; overflow: hidden; }
    .kyc-file-progress-bar span { display: block; height: 100%; width: 0; background: #5b6be8; transition: width .15s ease; }
    .kyc-file-progress.is-complete .kyc-file-progress-bar span { background: #28a745; }
    .kyc-file-progress-text { color: #6c757d; }
</style>
@endpush

@push('script')
<script>
    (function () {
        var UPLOADED_LABEL = "{{ __('Uploaded') }}";

        function updateProgress(bar, text, pct) {
            bar.style.width = pct + '%';
            text.textContent = pct + '%';
        }

        function animateTo100(field) {
            var bar = field.querySelector('.kyc-file-progress-bar span');
            var text = field.querySelector('.kyc-file-progress-text');
            var progress = field.querySelector('.kyc-file-progress');
            var drop = field.querySelector('.kyc-file-drop');
            var current = parseInt(bar.style.width, 10) || 0;

            (function step() {
                current += 8;
                if (current >= 100) {
                    updateProgress(bar, text, 100);
                    text.textContent = UPLOADED_LABEL + ' 100%';
                    progress.classList.add('is-complete');
                    drop.classList.add('is-done');
                    return;
                }
                updateProgress(bar, text, current);
                window.requestAnimationFrame(step);
            })();
        }

        function resetField(field) {
            var input = field.querySelector('.kyc-file-input');
            var drop = field.querySelector('.kyc-file-drop');
            var progress = field.querySelector('.kyc-file-progress');
            var img = field.querySelector('.kyc-file-img');
            if (input) input.value = '';
            if (img) img.src = '';
            drop.classList.remove('has-file', 'is-done', 'is-doc');
            progress.classList.remove('is-active', 'is-complete');
        }

        function handleFile(field, file) {
            if (!file) { resetField(field); return; }

            var drop = field.querySelector('.kyc-file-drop');
            var progress = field.querySelector('.kyc-file-progress');
            var bar = field.querySelector('.kyc-file-progress-bar span');
            var text = field.querySelector('.kyc-file-progress-text');
            var img = field.querySelector('.kyc-file-img');
            var nameEl = field.querySelector('.kyc-file-name');
            var isImage = file.type && file.type.indexOf('image/') === 0;

            drop.classList.add('has-file');
            drop.classList.remove('is-done');
            drop.classList.toggle('is-doc', !isImage);
            progress.classList.add('is-active');
            progress.classList.remove('is-complete');
            updateProgress(bar, text, 0);
            if (nameEl) nameEl.textContent = file.name || '';

            var reader = new FileReader();
            reader.onprogress = function (e) {
                if (e.lengthComputable) {
                    var pct = Math.round((e.loaded / e.total) * 100);
                    updateProgress(bar, text, Math.min(pct, 90));
                }
            };
            reader.onload = function (e) {
                if (isImage && img) img.src = e.target.result;
                animateTo100(field);
            };
            reader.onerror = function () { resetField(field); };
            reader.readAsDataURL(file);
        }

        document.addEventListener('DOMContentLoaded', function () {
            var fields = document.querySelectorAll('.kyc-file-field');
            Array.prototype.forEach.call(fields, function (field) {
                var input = field.querySelector('.kyc-file-input');
                var drop = field.querySelector('.kyc-file-drop');
                var removeBtn = field.querySelector('.kyc-file-remove');
                if (!input || !drop) return;

                input.addEventListener('change', function () {
                    handleFile(field, input.files && input.files[0]);
                });

                ['dragenter', 'dragover'].forEach(function (ev) {
                    drop.addEventListener(ev, function (e) { e.preventDefault(); drop.classList.add('is-dragover'); });
                });
                ['dragleave', 'drop'].forEach(function (ev) {
                    drop.addEventListener(ev, function (e) { e.preventDefault(); drop.classList.remove('is-dragover'); });
                });
                drop.addEventListener('drop', function (e) {
                    if (e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files.length) {
                        input.files = e.dataTransfer.files;
                        handleFile(field, input.files[0]);
                    }
                });

                if (removeBtn) {
                    removeBtn.addEventListener('click', function (e) {
                        e.preventDefault();
                        e.stopPropagation();
                        resetField(field);
                    });
                }
            });
        });
    })();
</script>
@endpush
@endonce
