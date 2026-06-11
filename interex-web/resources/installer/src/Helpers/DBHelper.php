<?php

namespace Project\Installer\Helpers;

use Exception;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Schema;
use Symfony\Component\Process\Process;

class DBHelper
{
    public function create(array $data)
    {
        $this->updateEnv([
            'DB_CONNECTION' => 'mysql',
            'DB_HOST' => $data['host'],
            'DB_PORT' => $data['port'],
            'DB_DATABASE' => $data['db_name'],
            'DB_USERNAME' => $data['db_user'],
            'DB_PASSWORD' => $data['db_user_password'],
        ]);
        $this->setStepSession();
        $this->saveDataInSession($data);
        $helper = new Helper;
        $helper->cache($data);
    }

    public function updateEnv(array $replace_array)
    {
        sleep(2);
        $env_content_string = File::get(App::environmentFilePath());

        cache()->driver('file')->set(Helper::ENV_CONTENT_CACHE_KEY, $env_content_string);
        $array_going_to_modify = $replace_array;
        if (count($array_going_to_modify) == 0) {
            return false;
        }
        $env_file_content_string = cache()->driver('file')->get(Helper::ENV_CONTENT_CACHE_KEY);
        $lines = array_values(array_filter(explode("\n", $env_file_content_string)));
        $env_content = [];
        foreach ($lines as $line) {
            $line = trim($line);
            if ($line) {
                [$key, $value] = explode('=', $line, 2);
                // Remove any quotes from the value
                $value = trim($value, '"');
                // Store the key-value pair in the array
                $env_content[$key] = $value;
            }
        }
        $update_array = ['APP_ENV' => App::environment()];
        foreach ($env_content as $key => $value) {
            foreach ($array_going_to_modify as $modify_key => $modify_value) {
                if (! array_key_exists($modify_key, $env_content) && ! array_key_exists($modify_key, $update_array)) {
                    $update_array[$modify_key] = $this->setEnvValue($modify_key, $modify_value);
                    break;
                }
                if ($key == $modify_key) {
                    $update_array[$key] = $this->setEnvValue($key, $modify_value);
                    break;
                } else {
                    $update_array[$key] = $this->setEnvValue($key, $value);
                }
            }
        }
        $string_content = '';
        foreach ($update_array as $key => $item) {
            $line = $key.'='.$item;
            $string_content .= $line."\r\n\n";
        }
        $env_file = App::environmentFilePath();
        File::put($env_file, $string_content);
    }

    public function setEnvValue($key, $value)
    {
        if ($key == 'APP_KEY') {
            return $value;
        }

        return '"'.$value.'"';
    }

    public function saveDataInSession($data)
    {
        session()->put('database_config_data', $data);
    }

    public static function getSessionData()
    {
        return session('database_config_data');
    }

    public function setStepSession()
    {
        session()->put('database_config', 'PASSED');
    }

    public static function step($step = 'database_config')
    {
        return session($step);
    }

    public function migrate()
    {
        if (App::environment() != 'local') {
            $this->updateEnv([
                'APP_ENV' => 'local',
            ]);
            sleep(2);
        }

        // Run the artisan commands in-process using the current request's working
        // database connection and PHP runtime. Shelling out to a "php artisan"
        // subprocess was fragile on Windows: it could fail with "'php' is not
        // recognized" (PHP not on the web server's PATH) or a SQLSTATE[2002]
        // connection error from the spawned process.
        @set_time_limit(0);

        Artisan::call('migrate:fresh', ['--seed' => true, '--force' => true]);
        Artisan::call('migrate', ['--force' => true]);

        // Passport's artisan commands are only registered when running in the
        // console, so Artisan::call('passport:install') is unavailable from a
        // web request ("command does not exist"). Replicate it in-process.
        $this->installPassport();

        try {
            // The symlink may already exist on re-runs; that is not fatal.
            Artisan::call('storage:link');
        } catch (Exception $e) {
            // ignore: storage link already present
        }

        $this->setMigrateStepSession();

        // update env to production
        $this->updateEnv([
            'APP_ENV' => 'production',
            'APP_URL' => rtrim(url('/'), '/'),
        ]);
    }

    /**
     * Prepare Passport for use without invoking its console commands.
     *
     * Mirrors `passport:install`: generates the RSA encryption keys and creates
     * the "personal access" grant client. Passport registers its artisan
     * commands only when running in the console, so they cannot be reached via
     * Artisan::call() from a web request.
     */
    protected function installPassport(): void
    {
        // 1) Encryption keys (equivalent to `passport:keys --force`)
        $public_key = \Laravel\Passport\Passport::keyPath('oauth-public.key');
        $private_key = \Laravel\Passport\Passport::keyPath('oauth-private.key');

        $key = \phpseclib3\Crypt\RSA::createKey(4096);
        file_put_contents($public_key, (string) $key->getPublicKey());
        file_put_contents($private_key, (string) $key);

        if (! windows_os()) {
            @chmod($public_key, 0660);
            @chmod($private_key, 0600);
        }

        // 2) Personal access grant clients (equivalent to `passport:client --personal`).
        // Passport 12+ scopes personal access clients to a user provider, so we
        // need one per provider used by a passport guard (users/merchants/agents).
        $clients = app(\Laravel\Passport\ClientRepository::class);
        foreach ($this->passportProviders() as $provider) {
            $clients->createPersonalAccessGrantClient(config('app.name'), $provider);
        }
    }

    /**
     * Distinct user providers used by guards whose driver is "passport".
     *
     * @return array<int,string>
     */
    protected function passportProviders(): array
    {
        $providers = [];
        foreach ((array) config('auth.guards') as $guard) {
            if (($guard['driver'] ?? null) === 'passport' && ! empty($guard['provider'])) {
                $providers[] = $guard['provider'];
            }
        }

        return array_values(array_unique($providers));
    }

    /**
     * resolve command base path for mac, linux based etc. os - will return artisan command
     */
    public function resolveCommandPath(): string
    {
        $php_binary = explode(DIRECTORY_SEPARATOR, PHP_BINARY);
        $remove_last_item = array_pop($php_binary);
        $php_binary = implode(DIRECTORY_SEPARATOR, $php_binary);

        $cli_suffix = 'php';

        $php_cli_binary = rtrim($php_binary, DIRECTORY_SEPARATOR).DIRECTORY_SEPARATOR.$cli_suffix;

        $project_path = base_path('artisan');

        $command_base_path = '"'.$php_cli_binary.'" '.$project_path;

        return $command_base_path;
    }

    /**
     * resolve command base path for windows based os - will return artisan command
     */
    public function resolveWindowsCommandPath(): string
    {
        // Use the absolute path of the running PHP binary (php.exe) instead of a
        // bare "php", because the web server's subprocess environment may not
        // have PHP on its PATH ("'php' is not recognized" otherwise).
        $php_binary = PHP_BINARY;

        // Under a web SAPI the binary may resolve to php-cgi/php-fpm; prefer the
        // sibling php.exe CLI when it exists.
        $cli_candidate = dirname($php_binary).DIRECTORY_SEPARATOR.'php.exe';
        if (is_file($cli_candidate)) {
            $php_binary = $cli_candidate;
        }

        $base_path = '"'.$php_binary.'" "'.base_path('artisan').'"';

        return $base_path;
    }

    public function setMigrateStepSession()
    {
        session()->put('migrate', 'PASSED');
    }

    public function updateAccountSettings(array $data)
    {
        $helper = new Helper;
        $helper->cache($data);
        $p_key = $helper->cache()['product_key'] ?? '';
        if ($p_key == '') {
            cache()->driver('file')->forget($helper->cache_key);
            throw new Exception('Something went wrong! Purchase code registration failed! Please try again');
        }
        $admin = DB::table('admins')->first();
        if (! $admin) {
            DB::table('admins')->insert([
                'firstname' => $data['f_name'],
                'lastname' => $data['l_name'],
                'password' => Hash::make($data['password']),
                'email' => $data['email'],
            ]);
        } else {
            DB::table('admins')->where('id', $admin->id)->update([
                'firstname' => $data['f_name'],
                'lastname' => $data['l_name'],
                'password' => Hash::make($data['password']),
                'email' => $data['email'],
            ]);
        }
        $validator = new ValidationHelper;
        if ($validator->isLocalInstallation() == false) {
            $helper->connection($helper->cache());
        }

        $client_host = request()->getHttpHost();
        $filter_host = preg_replace('/^www\./', '', $client_host);

        if (Schema::hasTable('script')) {
            DB::table('script')->truncate();
            DB::table('script')->insert([
                'client' => $filter_host,
                'signature' => $helper->signature($helper->cache()),
            ]);
        }
        if (Schema::hasTable('basic_settings')) {
            try {
                DB::table('basic_settings')->where('id', 1)->update([
                    'site_name' => $helper->cache()['app_name'] ?? '',
                ]);
            } catch (Exception $e) {
                // handle error
            }
        }
        $db = new DBHelper;
        $db->updateEnv([
            'PRODUCT_KEY' => $p_key,
            'APP_MODE' => 'live',
            'APP_DEBUG' => 'false',
        ]);
        $this->setAdminAccountStepSession();
        Artisan::call('cache:clear');
        Artisan::call('config:clear');
    }

    public function setAdminAccountStepSession()
    {
        session()->put('admin_account', 'PASSED');
    }

    public static function execute($cmd): string
    {
        $process = Process::fromShellCommandline($cmd);
        $processOutput = '';
        $captureOutput = function ($type, $line) use (&$processOutput) {
            $processOutput .= $line;
        };
        $process->setTimeout(null)
            ->run($captureOutput);
        if ($process->getExitCode()) {
            throw new Exception($cmd.' - '.$processOutput);
        }

        return $processOutput;
    }
}
