<!DOCTYPE html>
<html lang="{{ get_default_language_code() }}" dir="{{ selectedLangDir() ?? 'ltr' }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>{{ __("Card Payment") }} </title>
</head>
<body class="{{ selectedLangDir() ?? 'ltr' }}">
    <form action="{{ setRoute('card.payment') }}" method="POST">
        @csrf
        <button type="submit">{{ __("Submit") }}</button>
    </form>
</body>
</html>
