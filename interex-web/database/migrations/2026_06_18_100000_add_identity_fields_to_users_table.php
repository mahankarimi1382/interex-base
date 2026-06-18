<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            if (!Schema::hasColumn('users', 'national_id')) {
                $table->string('national_id')->nullable()->after('full_mobile');
            }
            if (!Schema::hasColumn('users', 'passport_no')) {
                $table->string('passport_no')->nullable()->after('national_id');
            }
            if (!Schema::hasColumn('users', 'nationality')) {
                $table->string('nationality')->nullable()->after('passport_no');
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['national_id', 'passport_no', 'nationality']);
        });
    }
};
