
@if($basic_settings->merchant_kyc_verification)
    @foreach ($kyc_fields as $item)
        @if ($item->type == "select")
            <div class="col-lg-12 form-group">
                <label for="{{ $item->name }}">{{ __($item->label) }}</label>
                <select name="{{ $item->name }}" id="{{ $item->name }}" class="form--control nice-select">
                    <option value="" disabled {{ old($item->name) ? '' : 'selected' }}>{{ __("Choose One") }}</option>
                    @foreach ($item->validation->options as $innerItem)
                        <option value="{{ $innerItem }}" {{ old($item->name) == $innerItem ? 'selected' : '' }}>{{ $innerItem }}</option>
                    @endforeach
                </select>
                @error($item->name)
                    <span class="invalid-feedback d-block" role="alert">
                        <strong>{{ $message }}</strong>
                    </span>
                @enderror
            </div>
        @elseif ($item->type == "file")
            @include('partials.kyc-file-field', ['item' => $item])
        @elseif ($item->type == "text")
            <div class="col-lg-12 form-group">
                @include('admin.components.form.input',[
                    'label'     => __($item->label),
                    'name'      => $item->name,
                    'type'      => $item->type,
                    'value'     => old($item->name),
                ])
            </div>
        @elseif ($item->type == "textarea")
            <div class="col-lg-12 form-group">
                @include('admin.components.form.textarea',[
                    'label'     => __($item->label),
                    'name'      => $item->name,
                    'value'     => old($item->name),
                ])
            </div>
        @endif
    @endforeach
@endif
