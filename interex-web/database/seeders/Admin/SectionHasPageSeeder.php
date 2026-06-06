<?php

namespace Database\Seeders\Admin;

use App\Models\Admin\SetupPageHasSection;
use Illuminate\Database\Seeder;

class SectionHasPageSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $setup_page_has_sections = [
            ['id' => '1', 'setup_page_id' => '1', 'site_section_id' => '2', 'position' => '1', 'status' => '1', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '2', 'setup_page_id' => '1', 'site_section_id' => '3', 'position' => '2', 'status' => '1', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '3', 'setup_page_id' => '1', 'site_section_id' => '5', 'position' => '3', 'status' => '1', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '4', 'setup_page_id' => '1', 'site_section_id' => '4', 'position' => '4', 'status' => '1', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '5', 'setup_page_id' => '1', 'site_section_id' => '14', 'position' => '5', 'status' => '1', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '6', 'setup_page_id' => '1', 'site_section_id' => '6', 'position' => '6', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '7', 'setup_page_id' => '1', 'site_section_id' => '15', 'position' => '7', 'status' => '1', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '8', 'setup_page_id' => '1', 'site_section_id' => '16', 'position' => '8', 'status' => '1', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '9', 'setup_page_id' => '1', 'site_section_id' => '8', 'position' => '9', 'status' => '1', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '10', 'setup_page_id' => '1', 'site_section_id' => '17', 'position' => '10', 'status' => '1', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '11', 'setup_page_id' => '1', 'site_section_id' => '7', 'position' => '11', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '12', 'setup_page_id' => '1', 'site_section_id' => '9', 'position' => '12', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '13', 'setup_page_id' => '1', 'site_section_id' => '11', 'position' => '13', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '14', 'setup_page_id' => '6', 'site_section_id' => '4', 'position' => '1', 'status' => '1', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '15', 'setup_page_id' => '6', 'site_section_id' => '5', 'position' => '2', 'status' => '1', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '16', 'setup_page_id' => '6', 'site_section_id' => '7', 'position' => '3', 'status' => '1', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '17', 'setup_page_id' => '6', 'site_section_id' => '8', 'position' => '4', 'status' => '1', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '18', 'setup_page_id' => '6', 'site_section_id' => '2', 'position' => '5', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '19', 'setup_page_id' => '6', 'site_section_id' => '3', 'position' => '6', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '20', 'setup_page_id' => '6', 'site_section_id' => '6', 'position' => '7', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '21', 'setup_page_id' => '6', 'site_section_id' => '9', 'position' => '8', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '22', 'setup_page_id' => '6', 'site_section_id' => '14', 'position' => '9', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '23', 'setup_page_id' => '6', 'site_section_id' => '15', 'position' => '10', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '24', 'setup_page_id' => '6', 'site_section_id' => '16', 'position' => '11', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '25', 'setup_page_id' => '6', 'site_section_id' => '17', 'position' => '12', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '26', 'setup_page_id' => '7', 'site_section_id' => '6', 'position' => '1', 'status' => '1', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '27', 'setup_page_id' => '7', 'site_section_id' => '2', 'position' => '2', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '28', 'setup_page_id' => '7', 'site_section_id' => '3', 'position' => '3', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '29', 'setup_page_id' => '7', 'site_section_id' => '4', 'position' => '4', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '30', 'setup_page_id' => '7', 'site_section_id' => '5', 'position' => '5', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '31', 'setup_page_id' => '7', 'site_section_id' => '7', 'position' => '6', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '32', 'setup_page_id' => '7', 'site_section_id' => '8', 'position' => '7', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '33', 'setup_page_id' => '7', 'site_section_id' => '9', 'position' => '8', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '34', 'setup_page_id' => '7', 'site_section_id' => '14', 'position' => '9', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '35', 'setup_page_id' => '7', 'site_section_id' => '15', 'position' => '10', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '36', 'setup_page_id' => '7', 'site_section_id' => '16', 'position' => '11', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '37', 'setup_page_id' => '7', 'site_section_id' => '17', 'position' => '12', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '38', 'setup_page_id' => '9', 'site_section_id' => '2', 'position' => '1', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '39', 'setup_page_id' => '9', 'site_section_id' => '3', 'position' => '2', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '40', 'setup_page_id' => '9', 'site_section_id' => '4', 'position' => '3', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '41', 'setup_page_id' => '9', 'site_section_id' => '5', 'position' => '4', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '42', 'setup_page_id' => '9', 'site_section_id' => '6', 'position' => '5', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '43', 'setup_page_id' => '9', 'site_section_id' => '7', 'position' => '6', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '44', 'setup_page_id' => '9', 'site_section_id' => '8', 'position' => '7', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '45', 'setup_page_id' => '9', 'site_section_id' => '9', 'position' => '8', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '46', 'setup_page_id' => '9', 'site_section_id' => '14', 'position' => '9', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '47', 'setup_page_id' => '9', 'site_section_id' => '15', 'position' => '10', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '48', 'setup_page_id' => '9', 'site_section_id' => '16', 'position' => '11', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '49', 'setup_page_id' => '9', 'site_section_id' => '17', 'position' => '12', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '50', 'setup_page_id' => '13', 'site_section_id' => '9', 'position' => '1', 'status' => '1', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '51', 'setup_page_id' => '13', 'site_section_id' => '2', 'position' => '2', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '52', 'setup_page_id' => '13', 'site_section_id' => '3', 'position' => '3', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '53', 'setup_page_id' => '13', 'site_section_id' => '4', 'position' => '4', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '54', 'setup_page_id' => '13', 'site_section_id' => '5', 'position' => '5', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '55', 'setup_page_id' => '13', 'site_section_id' => '6', 'position' => '6', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '56', 'setup_page_id' => '13', 'site_section_id' => '7', 'position' => '7', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '57', 'setup_page_id' => '13', 'site_section_id' => '8', 'position' => '8', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '58', 'setup_page_id' => '13', 'site_section_id' => '14', 'position' => '9', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '59', 'setup_page_id' => '13', 'site_section_id' => '15', 'position' => '10', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '60', 'setup_page_id' => '13', 'site_section_id' => '16', 'position' => '11', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
            ['id' => '61', 'setup_page_id' => '13', 'site_section_id' => '17', 'position' => '12', 'status' => '0', 'created_at' => now(), 'updated_at' => now()],
        ];

        SetupPageHasSection::upsert($setup_page_has_sections, ['id'], ['setup_page_id', 'site_section_id', 'position', 'status']);
    }
}
