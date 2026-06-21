@extends('user.layouts.user_auth')

@php
    $type =  Illuminate\Support\Str::slug(App\Constants\GlobalConst::USEFUL_LINKS);
    $policies = App\Models\Admin\SetupPage::orderBy('id')->where('type', $type)->where('slug',"terms-and-conditions")->where('status',1)->first();
@endphp

@push('css')
<style>
    .identity-field { display: none; }
    .password-strength-bar {
        height: 6px;
        width: 100%;
        background: #e9ecef;
        border-radius: 4px;
        overflow: hidden;
    }
    .password-strength-bar span {
        display: block;
        height: 100%;
        width: 0;
        transition: width .3s ease, background .3s ease;
    }
    .strength-weak   { background: #dc3545 !important; }
    .strength-medium { background: #ffc107 !important; }
    .strength-strong { background: #28a745 !important; }
    .password-match-icon { display: none; }
    .password-match-icon.is-ok    { display: inline-block; color: #28a745; }
    .password-match-icon.is-error { display: inline-block; color: #dc3545; }
    .text-match-ok    { color: #28a745; }
    .text-match-error { color: #dc3545; }
</style>
@endpush

@section('content')
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Start acount
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
<section class="account kyc">
    <div id="body-overlay" class="body-overlay"></div>
    <div class="account-area">
        <div class="account-wrapper kyc">
            <div class="account-logo text-center">
                <a href="{{ url('/') }}" class="site-logo">
                    <img src="{{ get_logo($basic_settings) }}"  data-white_img="{{ get_logo($basic_settings,'white') }}"
                    data-dark_img="{{ get_logo($basic_settings,'dark') }}"
                        alt="site-logo">
                </a>
            </div>
            <h5 class="title">{{ __("KYC Form") }}</h5>
            <p>{{ __("Please input all the fild for login to your account to get access to your dashboard.") }}</p>
            <form class="account-form" action="{{ setRoute('user.register.submit') }}" method="POST" enctype="multipart/form-data">
                @csrf
                <div class="row ml-b-20">
                    <div class="col-xl-4 col-lg-4 col-md-4 form-group">
                        @include('admin.components.form.input',[
                            'name'          => "firstname",
                          'placeholder'   => __("first Name"),
                            'value'         => old("firstname"),
                        ])
                    </div>
                    <div class="col-xl-4 col-lg-4 col-md-4 form-group">
                        @include('admin.components.form.input',[
                                    'name'          => "lastname",
                                    'placeholder'   => __("last Name"),
                                    'value'         => old("lastname"),
                        ])
                    </div>
                    <div class="col-xl-4 col-lg-4 col-md-4 form-group">
                        <select name="country" class="form--control country-select select2-basic">
                            <option value="" disabled selected>{{ __("select Country") }}</option>
                            @foreach (freedom_countries(global_const()::USER) ?? [] as $country)
                                @if (isset($mobile_code))
                                    @if ($mobile_code == $country->mobile_code && $country_name == $country->name)
                                        <option value="{{ $country->name }}" data-mobile-code="{{$country->mobile_code}}" selected>{{ $country->name }}</option>
                                    @endif
                                @else
                                <option value="{{ $country->name }}" data-mobile-code="{{$country->mobile_code}}" {{ old('country') == $country->name ? 'selected' : '' }}>{{ $country->name }}</option>
                                @endif
                            @endforeach
                        </select>
                    </div>
                    <div class="col-xl-4 col-lg-4 col-md-4 form-group">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text copytext">{{__("Email")}}</span>
                            </div>
                            <input type="email" name="email" class="form--control" placeholder="{{ __("Email") }}" value="{{ old('email',$register_type == global_const()::EMAIL ? $credentials : '') }}" @if(@$register_type == global_const()::EMAIL) readonly @endif>

                        </div>
                    </div>
                    <div class="col-xl-4 col-lg-4 col-md-4 form-group">
                        @include('admin.components.form.input',[
                            'name'          => "city",
                            'placeholder'   =>__( "city"),
                            'value'         => old("city"),
                        ])
                    </select>
                    </div>
                    <div class="col-xl-4 col-lg-4 col-md-4 form-group">
                        @include('admin.components.form.input',[
                            'name'          => "zip_code",
                            'placeholder'   =>__( "enter Zip Code"),
                            'value'         => old('zip_code',auth()->user()->address->zip ?? ""),
                            'class'         => 'zip-code-input',
                        ])
                        <small class="text-muted iran-only-hint d-none">{{ __("Iranian postal code must be exactly 10 digits.") }}</small>
                        @error('zip_code')
                            <span class="invalid-feedback d-block" role="alert"><strong>{{ $message }}</strong></span>
                        @enderror
                    </div>

                    {{-- Iranian identity field: shown when the selected country is Iran --}}
                    <div class="col-xl-4 col-lg-4 col-md-4 form-group identity-field identity-iran">
                        @include('admin.components.form.input',[
                            'name'          => "national_id",
                            'placeholder'   => __("enter National Code"),
                            'value'         => old('national_id'),
                            'class'         => 'national-id-input',
                        ])
                        @error('national_id')
                            <span class="invalid-feedback d-block" role="alert"><strong>{{ $message }}</strong></span>
                        @enderror
                    </div>

                    {{-- Foreign identity fields: shown when the selected country is not Iran --}}
                    <div class="col-xl-4 col-lg-4 col-md-4 form-group identity-field identity-foreign">
                        <select name="nationality" class="form--control">
                            <option value="" disabled {{ old('nationality') ? '' : 'selected' }}>{{ __("select Nationality") }}</option>
                            @foreach (freedom_countries(global_const()::USER) ?? [] as $country)
                                <option value="{{ $country->name }}" {{ old('nationality') == $country->name ? 'selected' : '' }}>{{ $country->name }}</option>
                            @endforeach
                        </select>
                        @error('nationality')
                            <span class="invalid-feedback d-block" role="alert"><strong>{{ $message }}</strong></span>
                        @enderror
                    </div>
                    <div class="col-xl-4 col-lg-4 col-md-4 form-group identity-field identity-foreign">
                        @include('admin.components.form.input',[
                            'name'          => "passport_no",
                            'placeholder'   => __("enter Passport Number"),
                            'value'         => old('passport_no'),
                        ])
                        @error('passport_no')
                            <span class="invalid-feedback d-block" role="alert"><strong>{{ $message }}</strong></span>
                        @enderror
                    </div>

                    <div class="{{  isset($referral_info) &&  $referral_info->status == true ? "col-xl-6 col-lg-6" : "col-xl-12 col-lg-12" }} form-group">
                        <div class="input-group">
                            <div class="input-group-text phone-code">+{{ $mobile_code??"" }}</div>
                            <input class="phone-code" type="hidden" name="phone_code" value="{{ $mobile_code ??'' }}" />
                            <input type="number" class="form--control" placeholder="{{ __("enter Phone Number") }}" name="phone" value="{{ old('phone',$register_type == global_const()::PHONE ? $credentials : '') }}" @if(@$register_type == global_const()::PHONE) readonly @endif>
                        </div>
                    </div>
                    @if(isset($referral_info) &&  $referral_info->status == true)
                        <div class="col-xl-6 col-lg-6 col-md-6 form-group">
                            <input type="text" class="form-control form--control" name="refer" placeholder="{{ __("Enter Referral Id") }} {{"(" .__("Optional").")" }}" value="{{ $refer }}">
                        </div>
                    @endif

                    @if($basic_settings->kyc_verification)
                        @include('user.components.register-kyc',compact("kyc_fields"))
                    @endif
                    <div class="col-lg-6 col-md-4 form-group show_hide_password" id="">
                        <input type="password" class="form--control" id="register-password" name="password" placeholder="{{ __('enter Password') }}" required minlength="8">
                        <a href="javascript:void(0)" class="show-pass"><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
                        <div class="password-strength-meter mt-2 d-none">
                            <div class="password-strength-bar"><span></span></div>
                            <small class="password-strength-text"></small>
                        </div>
                    </div>
                    <div class="col-lg-6 col-md-4 form-group show_hide_password-2" id="">
                        <input type="password" class="form--control" id="register-password-confirm" name="password_confirmation" placeholder="{{ __('confirm Password') }}" required minlength="8">
                        <a href="javascript:void(0)" class="show-pass"><i class="fa fa-eye-slash" aria-hidden="true"></i></a>
                        <i class="fa password-match-icon" aria-hidden="true"></i>
                        <small class="password-match-text d-block mt-1"></small>
                    </div>
                    @if($basic_settings->agree_policy)
                    <div class="col-lg-12 form-group">
                        <div class="custom-check-group">
                            <div class="custom-check-group mb-0">
                                <input type="checkbox" id="level-1" name="agree">
                                <label for="level-1" class="mb-0">{{ __("I have agreed with") }} <a href="{{  $policies != null? setRoute('useful.link',$policies->slug):"javascript:void(0)" }}">{{__("Terms Of Use & Privacy Policy")}}</a></label>
                            </div>
                        </div>
                    </div>
                    @endif
                    <div class="col-lg-12 form-group text-center">
                        <button type="submit" class="btn--base w-100 btn-loading">{{ __("Register") }} <i class="fas fa-arrow-alt-circle-right ms-1"></i></button>
                    </div>
                    <div class="or-area">
                        <span class="or-line"></span>
                        <span class="or-title">Or</span>
                        <span class="or-line"></span>
                    </div>
                    <div class="col-lg-12 text-center">
                        <div class="account-item">
                            <label>{{ __("already Have An Account") }} <a href="{{ setRoute('user.login') }}" class="account-control-btn">{{ __("Login Now") }}</a></label>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</section>
<!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    End acount
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->

<ul class="bg-bubbles">
    <li></li>
    <li></li>
    <li></li>
    <li></li>
    <li></li>
    <li></li>
    <li></li>
    <li></li>
    <li></li>
    <li></li>
</ul>
@endsection

@push('script')
<script>
        $(document).ready(function(){
            $("select[name=country]").on('change',function(){
                var phoneCode = $("select[name=country] :selected").attr("data-mobile-code");
                placePhoneCode(phoneCode);
                toggleIdentityFields();
            });

            // ---- Identity fields toggle (Iran vs foreign) ----
            function toggleIdentityFields() {
                var country = $("select[name=country]").val();
                var isIran = (country === 'Iran');

                if (isIran) {
                    $('.identity-iran').show().find('input, select').prop('disabled', false);
                    $('.identity-foreign').hide().find('input, select').prop('disabled', true);
                    $('.iran-only-hint').removeClass('d-none');
                } else {
                    $('.identity-iran').hide().find('input, select').prop('disabled', true);
                    $('.identity-foreign').show().find('input, select').prop('disabled', false);
                    $('.iran-only-hint').addClass('d-none');
                }
            }
            toggleIdentityFields();

            // ---- Password strength meter ----
            function evaluatePasswordStrength(pw) {
                var score = 0;
                if (pw.length >= 8) score++;
                if (/[a-z]/.test(pw) && /[A-Z]/.test(pw)) score++;
                if (/\d/.test(pw)) score++;
                if (/[^A-Za-z0-9]/.test(pw)) score++;
                return score; // 0..4
            }

            var labels = {
                weak: "{{ __('Weak') }}",
                medium: "{{ __('Medium') }}",
                strong: "{{ __('Strong') }}"
            };

            $('#register-password').on('input', function(){
                var pw = $(this).val();
                var meter = $('.password-strength-meter');
                var bar = $('.password-strength-bar span');
                var text = $('.password-strength-text');

                if (pw.length === 0) {
                    meter.addClass('d-none');
                    bar.css('width', '0');
                    text.text('');
                    checkPasswordMatch();
                    return;
                }
                meter.removeClass('d-none');

                var score = evaluatePasswordStrength(pw);
                bar.removeClass('strength-weak strength-medium strength-strong');
                if (pw.length < 8 || score <= 1) {
                    bar.css('width', '33%').addClass('strength-weak');
                    text.text(labels.weak).removeClass('text-match-ok').addClass('text-match-error');
                } else if (score === 2 || score === 3) {
                    bar.css('width', '66%').addClass('strength-medium');
                    text.text(labels.medium).removeClass('text-match-ok text-match-error');
                } else {
                    bar.css('width', '100%').addClass('strength-strong');
                    text.text(labels.strong).removeClass('text-match-error').addClass('text-match-ok');
                }
                checkPasswordMatch();
            });

            // ---- Password confirmation match indicator ----
            function checkPasswordMatch() {
                var pw = $('#register-password').val();
                var confirm = $('#register-password-confirm').val();
                var icon = $('.password-match-icon');
                var text = $('.password-match-text');

                if (confirm.length === 0) {
                    icon.removeClass('is-ok is-error fa-check fa-times');
                    text.text('').removeClass('text-match-ok text-match-error');
                    return;
                }
                if (pw === confirm) {
                    icon.removeClass('is-error fa-times').addClass('is-ok fa-check');
                    text.text("{{ __('Passwords match') }}").removeClass('text-match-error').addClass('text-match-ok');
                } else {
                    icon.removeClass('is-ok fa-check').addClass('is-error fa-times');
                    text.text("{{ __('Passwords do not match') }}").removeClass('text-match-ok').addClass('text-match-error');
                }
            }
            $('#register-password-confirm').on('input', checkPasswordMatch);
        });


</script>

@endpush
